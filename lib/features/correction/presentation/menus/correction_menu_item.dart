import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/correction/presentation/widgets/correction_dialog.dart';

PlatformMenuItem correctionMenuItem(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  return PlatformMenuItem(
    label: 'Correct Image',
    onSelected: _onCorrectImage(context, model, onModelUpdate),
  );
}

VoidCallback? _onCorrectImage(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format == ImageFormat.ppm;

  if (isEnabled) {
    return () async {
      final result = await CorrectionDialog.show(context, model);
      if (result != null) {
        onModelUpdate(result);
      }
    };
  }

  return null;
}
