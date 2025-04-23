import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/grayscale/data/transformations/gray_scale_transformation.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

PlatformMenuItem grayScaleMenuItem(
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  return PlatformMenuItem(
    label: 'Convert to PGM',
    onSelected: _onConvertToPGM(model, onModelUpdate),
  );
}

VoidCallback? _onConvertToPGM(
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format != ImageFormat.pgm;

  if (isEnabled) {
    return () {
      final pgmModel = GrayScaleTransformation().call(model);
      onModelUpdate(pgmModel);
    };
  }

  return null;
}
