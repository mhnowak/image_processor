import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/convolution/data/transformations/convolution_transformation.dart';
import 'package:image_processor/features/edges/data/transformations/prewitt_transformation.dart';
import 'package:image_processor/features/edges/data/transformations/roberts_transformation.dart';
import 'package:image_processor/features/edges/data/transformations/sobel_transformation.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

PlatformMenuItemGroup edgesGroup(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  return PlatformMenuItemGroup(
    members: [
      PlatformMenuItem(
        label: 'Edge Roberts',
        onSelected: _onEdgeRoberts(context, model, onModelUpdate),
      ),
      PlatformMenuItem(
        label: 'Edge Prewitt',
        onSelected: _onEdgePrewitt(context, model, onModelUpdate),
      ),
      PlatformMenuItem(
        label: 'Edge Sobel',
        onSelected: _onEdgeSobel(context, model, onModelUpdate),
      ),
    ],
  );
}

VoidCallback? _onEdgeRoberts(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final pgmModel = RobertsTransformation().call(model, EdgeMode.cyclic);
      onModelUpdate(pgmModel);
    };
  }

  return null;
}

VoidCallback? _onEdgePrewitt(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final pgmModel = PrewittTransformation().call(model, EdgeMode.cyclic);
      onModelUpdate(pgmModel);
    };
  }

  return null;
}

VoidCallback? _onEdgeSobel(
  BuildContext context,
  ImageModel? model,
  void Function(ImageModel model) onModelUpdate,
) {
  final isEnabled = model != null && model.format == ImageFormat.ppm;

  if (isEnabled) {
    return () {
      final pgmModel = SobelTransformation().call(model, EdgeMode.cyclic);
      onModelUpdate(pgmModel);
    };
  }

  return null;
}
