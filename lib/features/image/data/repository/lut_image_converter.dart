import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/image/domain/models/lut.dart';

class LutImageConverter {
  ImageModel call(ImageModel model, LutModel lut) {
    assert(model.format == ImageFormat.ppm, 'Only PPM format is supported');

    final brightnessLUT = lut.createBrightnessLUT();
    final contrastLUT = lut.createContrastLUT();
    final gammaLUT = lut.createGammaLUT();

    final pixels = <int>[];
    for (var i = 0; i < model.pixels.length; i++) {
      final pixel = model.pixels[i];
      final brightened = brightnessLUT[pixel];
      final contrasted = contrastLUT[brightened];
      final gammaAdjusted = gammaLUT[contrasted];
      final clamped = gammaAdjusted.clamp(0, 255);

      pixels.add(clamped);
    }

    return ImageModel(
      format: ImageFormat.ppm,
      width: model.width,
      height: model.height,
      maxValue: 255,
      pixels: Uint8List.fromList(pixels),
    );
  }
}
