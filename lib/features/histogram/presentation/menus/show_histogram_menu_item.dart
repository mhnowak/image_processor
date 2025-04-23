import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/histogram/presentation/widgets/histogram_dialog.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

PlatformMenuItem showHistogramMenuItem(
  BuildContext context,
  ImageModel? image,
  void Function(ImageModel image) onImageUpdate,
) {
  return PlatformMenuItem(
    label: 'Show Histogram',
    onSelected: _onHistogram(context, image, onImageUpdate),
  );
}

VoidCallback? _onHistogram(
  BuildContext context,
  ImageModel? image,
  void Function(ImageModel image) onImageUpdate,
) {
  final isEnabled = image != null && image.format == ImageFormat.ppm;

  if (isEnabled) {
    return () async {
      final result = await HistogramDialog.show(context, image);
      if (result != null) {
        onImageUpdate(result);
      }
    };
  }

  return null;
}
