import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image_processor/features/convolution/data/transformations/convolution_transformation.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

abstract class EdgeTransformation extends ConvolutionTransformation {
  double calculateGradientMagnitude(double gx, double gy) {
    return math.sqrt(gx * gx + gy * gy);
  }

  ImageModel transform(ImageModel image, EdgeMode edgeMode) {
    assert(
      image.format == ImageFormat.ppm || image.format == ImageFormat.pgm,
      'Only PPM and PGM formats are supported',
    );

    final horizontalMask = getHorizontalMask();
    final verticalMask = getVerticalMask();
    
    final channels = image.format == ImageFormat.ppm ? 3 : 1;
    final pixels = Uint8List(image.pixels.length);

    for (int channel = 0; channel < channels; channel++) {
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final horizontalWindow = getWindow(image, x, y, horizontalMask.length, channel, edgeMode);
          final horizontalResult = join(horizontalWindow, horizontalMask);
          final gx = sum(horizontalResult);

          final verticalWindow = getWindow(image, x, y, verticalMask.length, channel, edgeMode);
          final verticalResult = join(verticalWindow, verticalMask);
          final gy = sum(verticalResult);

          final magnitude = calculateGradientMagnitude(gx, gy);
          final clampedValue = magnitude.clamp(0, 255).round();

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

  List<List<double>> getHorizontalMask();

  List<List<double>> getVerticalMask();
}

