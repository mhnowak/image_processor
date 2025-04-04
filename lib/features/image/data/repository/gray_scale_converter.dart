import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_model.dart';

class GreyScaleConverter {
  ImageModel call(ImageModel model) {
    assert(
      model.format != ImageFormat.pgm,
      "Already PGM format, can't convert PGM to PGM",
    );

    switch (model.format) {
      case ImageFormat.pbm:
        return _pbmToPgm(model);
      case ImageFormat.pgm:
        throw FormatException("Already PGM format, can't convert PGM to PGM");
      case ImageFormat.ppm:
        return _ppmToPgm(model);
    }
  }

  ImageModel _pbmToPgm(ImageModel model) {
    final pixels = <int>[];
    for (final pixel in model.pixels) {
      if (pixel == 0) {
        pixels.add(0);
      } else {
        pixels.add(255);
      }
    }

    return ImageModel(
      format: ImageFormat.pgm,
      width: model.width,
      height: model.height,
      maxValue: 255,
      pixels: Uint8List.fromList(pixels),
    );
  }

  ImageModel _ppmToPgm(ImageModel model) {
    final pixels = <int>[];
    for (var i = 0; i < model.pixels.length; i += 3) {
      final r = model.pixels[i];
      final g = model.pixels[i + 1];
      final b = model.pixels[i + 2];
      final greyValue = getGreyValueFromRGB(r, g, b);
      pixels.add(greyValue);
    }

    return ImageModel(
      format: ImageFormat.pgm,
      width: model.width,
      height: model.height,
      maxValue: 255,
      pixels: Uint8List.fromList(pixels),
    );
  }

  int getGreyValueFromRGB(int r, int g, int b) {
    return (0.299 * r + 0.587 * g + 0.114 * b).round();
  }
}
