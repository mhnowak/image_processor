import 'dart:typed_data';

import 'package:image_processor/features/histogram/domain/models/histogram_model.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

class HistogramStretchingTransformation {
  ImageModel call(ImageModel image) {
    assert(image.format == ImageFormat.ppm, 'Only PPM format is supported');

    final histogram = HistogramModel.fromImage(image);

    int minRed = histogram.firstRed, maxRed = histogram.lastRed;
    int minGreen = histogram.firstGreen, maxGreen = histogram.lastGreen;
    int minBlue = histogram.firstBlue, maxBlue = histogram.lastBlue;

    final pixels = Uint8List(image.pixels.length);
    for (int i = 0; i < image.pixels.length; i += 3) {
      pixels[i] = _transform(image.pixels[i], minRed, maxRed);
      pixels[i + 1] = _transform(image.pixels[i + 1], minGreen, maxGreen);
      pixels[i + 2] = _transform(image.pixels[i + 2], minBlue, maxBlue);
    }

    return ImageModel(
      format: ImageFormat.ppm,
      width: image.width,
      height: image.height,
      maxValue: 255,
      pixels: pixels,
    );
  }

  int _transform(int value, int min, int max) {
    final result = (255 / (max - min)) * (value - min);

    return result.round().clamp(0, 255);
  }
}
