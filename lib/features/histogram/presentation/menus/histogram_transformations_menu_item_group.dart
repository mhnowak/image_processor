import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/histogram/data/transformations/histogram_equalizer_transformation.dart';
import 'package:image_processor/features/histogram/data/transformations/histogram_stretching_transformation.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

PlatformMenuItemGroup histogramTransformationsGroup(
  BuildContext context,
  ImageModel? image,
  void Function(ImageModel image) onImageUpdate,
) {
  return PlatformMenuItemGroup(
    members: [
      PlatformMenuItem(
        label: 'Stretch Histogram',
        onSelected: _onStretchHistogram(image, onImageUpdate),
      ),
      PlatformMenuItem(
        label: 'Equalize Histogram',
        onSelected: _onEqualizeHistogram(image, onImageUpdate),
      ),
    ],
  );
}

VoidCallback? _onStretchHistogram(
  ImageModel? image,
  void Function(ImageModel image) onImageUpdate,
) {
  final isEnabled = image != null && image.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final stretchedImage = HistogramStretchingTransformation().call(image);
      onImageUpdate(stretchedImage);
    };
  }

  return null;
}

VoidCallback? _onEqualizeHistogram(
  ImageModel? image,
  void Function(ImageModel image) onImageUpdate,
) {
  final isEnabled = image != null && image.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final equalizedImage = HistogramEqualizationTransformation().call(image);
      onImageUpdate(equalizedImage);
    };
  }

  return null;
}
