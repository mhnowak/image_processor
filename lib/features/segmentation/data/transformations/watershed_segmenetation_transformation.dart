import 'dart:collection';
import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/grayscale/data/transformations/gray_scale_transformation.dart';

const int _init = -1; // initial value of lab image
const int _mask = -2; // initial value at each level
const int _wshed = 0; // label of the watershed pixels
const int _fictitiousX = -1, _fictitiousY = -1; // fictitious pixel coordinates

class WatershedSegmentationTransformation {
  ImageModel call(ImageModel model) {
    final grayImage = _ensureGrayscale(model);

    final labelled = _watershedByImmersion(
      grayImage.pixels,
      grayImage.width,
      grayImage.height,
    );

    final colorPixels = _labelsToColor(
      labelled,
      grayImage.width,
      grayImage.height,
    );

    return ImageModel(
      format: ImageFormat.ppm,
      width: grayImage.width,
      height: grayImage.height,
      maxValue: 255,
      pixels: Uint8List.fromList(colorPixels),
    );
  }

  ImageModel _ensureGrayscale(ImageModel model) {
    if (model.format == ImageFormat.pgm) {
      return model;
    }

    final grayScaleTransformation = GrayScaleTransformation();
    return grayScaleTransformation.call(model);
  }

  List<int> _watershedByImmersion(Uint8List image, int width, int height) {
    final int size = width * height;

    // Initialize arrays
    final lab = List.filled(size, _init); // label image
    final dist = List.filled(size, 0); // distance image

    // Find min and max grey values
    int hmin = 255;
    int hmax = 0;
    for (int i = 0; i < size; i++) {
      if (image[i] < hmin) hmin = image[i];
      if (image[i] > hmax) hmax = image[i];
    }

    // Sort pixels by grey value for direct access
    final sortedPixels = <int, List<int>>{};
    for (int level = hmin; level <= hmax; level++) {
      sortedPixels[level] = <int>[];
    }

    for (int i = 0; i < size; i++) {
      sortedPixels[image[i]]!.add(i);
    }

    // Initialize FIFO queue
    final queue = Queue<int>();
    int curlab = 0; // current label

    // Start flooding
    for (int h = hmin; h <= hmax; h++) {
      final pixelsAtLevel = sortedPixels[h]!;

      // Mask all pixels at level h
      for (final p in pixelsAtLevel) {
        lab[p] = _mask;

        // Check if p has a neighbour with (lab[q] > 0 or lab[q] = wshed)
        final neighbors = _getNeighbors(p, width, height);
        for (final q in neighbors) {
          if (lab[q] > 0 || lab[q] == _wshed) {
            // Initialize queue with neighbours at level h of current basins or watersheds
            dist[p] = 1;
            queue.add(p);
            break;
          }
        }
      }

      int curdist = 1;
      queue.add(
        _encodePixel(_fictitiousX, _fictitiousY, width),
      ); // add fictitious pixel

      // Extend basins
      while (queue.isNotEmpty) {
        int p = queue.removeFirst();

        if (_isFictitious(p, width)) {
          if (queue.isEmpty) {
            break;
          } else {
            queue.add(
              _encodePixel(_fictitiousX, _fictitiousY, width),
            ); // add fictitious pixel
            curdist++;
            p = queue.removeFirst();
          }
        }

        // Label p by inspecting neighbours
        final neighbors = _getNeighbors(p, width, height);
        for (final q in neighbors) {
          if (dist[q] < curdist && (lab[q] > 0 || lab[q] == _wshed)) {
            // q belongs to an existing basin or to watersheds
            if (lab[q] > 0) {
              if (lab[p] == _mask || lab[p] == _wshed) {
                lab[p] = lab[q];
              } else if (lab[p] != lab[q]) {
                lab[p] = _wshed;
              }
            } else if (lab[p] == _mask) {
              lab[p] = _wshed;
            }
          } else if (lab[q] == _mask && dist[q] == 0) {
            // q is plateau pixel
            dist[q] = curdist + 1;
            queue.add(q);
          }
        }
      }

      // Detect and process new minima at level h
      for (final p in pixelsAtLevel) {
        dist[p] = 0; // reset distance to zero

        if (lab[p] == _mask) {
          // p is inside a new minimum
          curlab++; // create new label
          queue.add(p);
          lab[p] = curlab;

          while (queue.isNotEmpty) {
            final q = queue.removeFirst();
            final neighbors = _getNeighbors(q, width, height);

            for (final r in neighbors) {
              if (lab[r] == _mask) {
                queue.add(r);
                lab[r] = curlab;
              }
            }
          }
        }
      }
    }

    return lab;
  }

  List<int> _getNeighbors(int index, int width, int height) {
    final neighbors = <int>[];
    final x = index % width;
    final y = index ~/ width;

    for (int dy = -1; dy <= 1; dy++) {
      for (int dx = -1; dx <= 1; dx++) {
        if (dx == 0 && dy == 0) continue;

        final nx = x + dx;
        final ny = y + dy;

        if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
          neighbors.add(ny * width + nx);
        }
      }
    }

    return neighbors;
  }

  int _encodePixel(int x, int y, int width) {
    if (x == _fictitiousX && y == _fictitiousY) {
      return -1;
    }
    return y * width + x;
  }

  bool _isFictitious(int p, int width) {
    return p == -1;
  }

  List<int> _labelsToColor(List<int> labels, int width, int height) {
    final colors = <int>[];
    final labelGrays = <int, int>{};

    final maxLabel = labels
        .where((label) => label > 0)
        .fold(0, (max, label) => label > max ? label : max);

    for (final label in labels) {
      if (label > 0 && !labelGrays.containsKey(label)) {
        final grayValue = (50 + ((label - 1) * 150) / maxLabel).round().clamp(
          50,
          200,
        );
        labelGrays[label] = grayValue;
      }
    }

    for (int i = 0; i < labels.length; i++) {
      final label = labels[i];

      if (label == _wshed) {
        // Border
        colors.addAll([255, 255, 255]);
      } else if (label > 0) {
        // Segment
        final grayValue = labelGrays[label]!;
        colors.addAll([grayValue, grayValue, grayValue]);
      } else {
        // Unprocessed
        colors.addAll([0, 0, 0]);
      }
    }

    return colors;
  }
}
