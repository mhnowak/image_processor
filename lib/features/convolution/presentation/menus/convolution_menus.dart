import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/convolution/data/transformations/blur_uniform_transformation.dart';
import 'package:image_processor/features/convolution/data/transformations/gauss_transformation.dart';
import 'package:image_processor/features/convolution/data/transformations/convolution_transformation.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

PlatformMenuItemGroup convolutionGroup(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  return PlatformMenuItemGroup(
    members: [
      PlatformMenuItem(
        label: 'Blur Uniform',
        onSelected: _onBlurUniform(context, model, onModelUpdate),
      ),
      PlatformMenuItem(
        label: 'Blur Gaussian',
        onSelected: _onBlurGaussian(context, model, onModelUpdate),
      ),
    ],
  );
}

VoidCallback? _onBlurUniform(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final pgmModel = BlurUniformTransformation().call(model, EdgeMode.cyclic);
      onModelUpdate(pgmModel);
    };
  }

  return null;
}

VoidCallback? _onBlurGaussian(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final pgmModel = GaussTransformation().call(model, EdgeMode.cyclic);
      onModelUpdate(pgmModel);
    };
  }

  return null;
}
