import 'dart:typed_data';
import 'dart:math' as math;

import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

enum EdgeMode { cyclic, nullEdge, repeat }

class ConvolutionTransformation {
  static const List<List<double>> identity = [
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0],
  ];

  static const List<List<double>> blur = [
    [1/9, 1/9, 1/9],
    [1/9, 1/9, 1/9],
    [1/9, 1/9, 1/9],
  ];

  static const List<List<double>> sharpen = [
    [0, -1, 0],
    [-1, 5, -1],
    [0, -1, 0],
  ];

  static const List<List<double>> edgeDetection = [
    [-1, -1, -1],
    [-1, 8, -1],
    [-1, -1, -1],
  ];

  ImageModel call(
    ImageModel image,
    EdgeMode edgeMode,
    List<List<double>> mask,
  ) {
    assert(
      image.format == ImageFormat.ppm || image.format == ImageFormat.pgm,
      'Only PPM and PGM formats are supported',
    );
    assert(
      mask.length % 2 == 1 && mask.length > 0,
      'Mask size must be a positive odd number',
    );
    assert(
      mask.length == mask[0].length,
      'Mask must be a square matrix',
    );

    final maskSize = mask.length;
    final weight = sum(mask);
    final channels = image.format == ImageFormat.ppm ? 3 : 1;
    final pixels = Uint8List(image.pixels.length);

    for (var channel = 0; channel < channels; channel++) {
      for (var y = 0; y < image.height; y++) {
        for (var x = 0; x < image.width; x++) {
          final window = getWindow(image, x, y, maskSize, channel, edgeMode);
          final accumulator = join(window, mask);
          var sum = this.sum(accumulator);

          if (weight != 0) {
            sum = sum / weight;
          }

          final clampedValue = sum.clamp(0, 255).round();

          if (image.format == ImageFormat.ppm) {
            final index = (y * image.width + x) * 3 + channel;
            pixels[index] = clampedValue;
          } else {
            final index = y * image.width + x;
            pixels[index] = clampedValue;
          }
        }
      }
    }

    return ImageModel(
      format: image.format,
      width: image.width,
      height: image.height,
      maxValue: 255,
      pixels: pixels,
    );
  }

  int getPixelCyclic(ImageModel image, int x, int y, int channel) {
    final width = image.width;
    final height = image.height;

    // Handle cyclic wrapping for x and y coordinates
    final wrappedX = ((x % width) + width) % width;
    final wrappedY = ((y % height) + height) % height;

    if (image.format == ImageFormat.ppm) {
      final index = (wrappedY * width + wrappedX) * 3 + channel;
      return image.pixels[index];
    } else {
      final index = wrappedY * width + wrappedX;
      return image.pixels[index];
    }
  }

  int getPixelNull(ImageModel image, int x, int y, int channel) {
    if (x < 0 || x >= image.width || y < 0 || y >= image.height) {
      return 0;
    }

    if (image.format == ImageFormat.ppm) {
      final index = (y * image.width + x) * 3 + channel;
      return image.pixels[index];
    } else {
      final index = y * image.width + x;
      return image.pixels[index];
    }
  }

  int getPixelRepeat(ImageModel image, int x, int y, int channel) {
    final clampedX = x.clamp(0, image.width - 1);
    final clampedY = y.clamp(0, image.height - 1);

    if (image.format == ImageFormat.ppm) {
      final index = (clampedY * image.width + clampedX) * 3 + channel;
      return image.pixels[index];
    } else {
      final index = clampedY * image.width + clampedX;
      return image.pixels[index];
    }
  }

  List<List<int>> getWindow(
    ImageModel image,
    int x,
    int y,
    int size,
    int channel,
    EdgeMode mode,
  ) {
    final halfSize = size ~/ 2;
    final window = List.generate(size, (i) => List.generate(size, (j) => 0));

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        final pixelX = x + (j - halfSize);
        final pixelY = y + (i - halfSize);

        switch (mode) {
          case EdgeMode.cyclic:
            window[i][j] = getPixelCyclic(image, pixelX, pixelY, channel);
          case EdgeMode.nullEdge:
            window[i][j] = getPixelNull(image, pixelX, pixelY, channel);
          case EdgeMode.repeat:
            window[i][j] = getPixelRepeat(image, pixelX, pixelY, channel);
        }
      }
    }

    return window;
  }

  List<List<double>> getMask(int size) {
    final mask = List.generate(size, (i) => List.generate(size, (j) => 0.0));
    final center = size ~/ 2;
    mask[center][center] = 1.0;
    return mask;
  }

  List<List<double>> join(List<List<int>> window, List<List<double>> mask) {
    final size = window.length;
    final result = List.generate(size, (i) => List.generate(size, (j) => 0.0));

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        result[i][j] = window[i][j] * mask[i][j];
      }
    }

    return result;
  }

  double sum(List<List<double>> matrix) {
    return matrix.fold<double>(
      0,
      (sum, row) =>
          sum + row.fold<double>(0, (rowSum, value) => rowSum + value),
    );
  }

  List<List<double>> reflection(List<List<double>> matrix) {
    final size = matrix.length;
    final result = List.generate(size, (i) => List.generate(size, (j) => 0.0));

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        result[i][j] = matrix[size - 1 - i][size - 1 - j];
      }
    }

    return result;
  }
}
