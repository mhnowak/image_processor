import 'dart:math' as math;

import 'package:image_processor/features/histogram/domain/utils/luminance.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

class HistogramModel {
  final List<int> red;
  final List<int> green;
  final List<int> blue;
  final List<int> grayscale;
  final int totalPixels;

  const HistogramModel({
    required this.red,
    required this.green,
    required this.blue,
    required this.grayscale,
    required this.totalPixels,
  });

  factory HistogramModel.fromImage(ImageModel image) {
    assert(image.format == ImageFormat.ppm, 'Only PPM format is supported');

    final red = List<int>.filled(256, 0);
    final green = List<int>.filled(256, 0);
    final blue = List<int>.filled(256, 0);
    final grayscale = List<int>.filled(256, 0);

    for (int i = 0; i < image.pixels.length; i += 3) {
      final r = image.pixels[i];
      final g = image.pixels[i + 1];
      final b = image.pixels[i + 2];

      red[r]++;
      green[g]++;
      blue[b]++;

      final l = luminance(r, g, b);
      grayscale[l]++;
    }

    return HistogramModel(
      red: red,
      green: green,
      blue: blue,
      grayscale: grayscale,
      totalPixels: image.width * image.height,
    );
  }

  int get maxValue {
    int max = 0;
    for (int i = 0; i < 256; i++) {
      max = math.max(max, red[i]);
      max = math.max(max, green[i]);
      max = math.max(max, blue[i]);
      max = math.max(max, grayscale[i]);
    }
    return max;
  }

  int get firstRed => _getFirstNonZero(red);

  int get firstGreen => _getFirstNonZero(green);

  int get firstBlue => _getFirstNonZero(blue);

  int get lastRed => _getLastNonZero(red);

  int get lastGreen => _getLastNonZero(green);

  int get lastBlue => _getLastNonZero(blue);

  List<int> get cdfRed => _getCDF(red);

  List<int> get cdfGreen => _getCDF(green);

  List<int> get cdfBlue => _getCDF(blue);

  List<int> _getCDF(List<int> values) {
    final cdf = List<int>.filled(256, 0);
    var sum = 0;

    for (int i = 0; i < 256; i++) {
      sum += values[i];
      cdf[i] = ((sum * 255.0) / totalPixels).round().clamp(0, 255);
    }

    return cdf;
  }

  int _getFirstNonZero(List<int> values) {
    for (int i = 0; i < 256; i++) {
      if (values[i] > 0) return i;
    }
    return 0;
  }

  int _getLastNonZero(List<int> values) {
    for (int i = 255; i >= 0; i--) {
      if (values[i] > 0) return i;
    }
    return 0;
  }
}
