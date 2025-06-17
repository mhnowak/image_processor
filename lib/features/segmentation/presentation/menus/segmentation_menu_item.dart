import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/segmentation/data/transformations/watershed_segmenetation_transformation.dart';

PlatformMenuItem segmentationMenuItem(
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  return PlatformMenuItem(
    label: 'Watershed Segmentation',
    onSelected: _onWatershedSegmentation(model, onModelUpdate),
  );
}

VoidCallback? _onWatershedSegmentation(
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null;

  if (isEnabled) {
    return () {
      final segmentedModel = WatershedSegmentationTransformation().call(model);
      onModelUpdate(segmentedModel);
    };
  }

  return null;
}
