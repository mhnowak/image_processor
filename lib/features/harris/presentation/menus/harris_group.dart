import 'package:flutter/material.dart';
import 'package:image_processor/features/harris/data/transformations/harris_transformations.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

PlatformMenuItemGroup harrisGroup(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  return PlatformMenuItemGroup(
    members: [
      PlatformMenuItem(
        label: 'Harris Corner Detection',
        onSelected: _onHarrisCornerDetection(context, model, onModelUpdate),
      ),
    ],
  );
}

VoidCallback? _onHarrisCornerDetection(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final harrisTransformations = HarrisTransformations();
      final result = harrisTransformations(model);
      onModelUpdate(result);
    };
  }

  return null;
}
