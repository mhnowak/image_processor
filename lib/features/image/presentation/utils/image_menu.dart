import 'package:desktop/desktop.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_processor/features/image/data/repository/gray_scale_converter.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/image/presentation/widgets/lut_dialog.dart';

PlatformMenu imageMenu({
  required BuildContext context,
  required ImageModel? model,
  required void Function(ImageModel model) onModelUpdate,
}) {
  final allowConvertToPGM = model != null && model.format != ImageFormat.pgm;
  final allowCorrectImage = model != null && model.format == ImageFormat.ppm;

  return PlatformMenu(
    label: 'Image',
    menus: [
      PlatformMenuItem(
        label: 'Convert to PGM',
        onSelected:
            allowConvertToPGM
                ? () {
                  final pgmModel = GreyScaleConverter().call(model);
                  onModelUpdate(pgmModel);
                }
                : null,
      ),
      PlatformMenuItem(
        label: 'Correct Image',
        onSelected:
            allowCorrectImage
                ? () async {
                  final result = await LutDialog.show(context, model);
                  if (result != null) {
                    onModelUpdate(result);
                  }
                }
                : null,
      ),
    ],
  );
}
