import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/correction/domain/models/correction_args_model.dart';

class CorrectionTransformation {
  ImageModel call(ImageModel image, CorrectionArgsModel args) {
    assert(image.format == ImageFormat.ppm, 'Only PPM format is supported');

    final brightnessLUT = args.createBrightnessLUT();
    final contrastLUT = args.createContrastLUT();
    final gammaLUT = args.createGammaLUT();

    final pixels = <int>[];
    for (var i = 0; i < image.pixels.length; i++) {
      final pixel = image.pixels[i];
      final brightened = brightnessLUT[pixel];
      final contrasted = contrastLUT[brightened];
      final gammaAdjusted = gammaLUT[contrasted];
      final clamped = gammaAdjusted.clamp(0, 255);

      pixels.add(clamped);
    }

    return ImageModel(
      format: ImageFormat.ppm,
      width: image.width,
      height: image.height,
      maxValue: 255,
      pixels: Uint8List.fromList(pixels),
    );
  }
}
