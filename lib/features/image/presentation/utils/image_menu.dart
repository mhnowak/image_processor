import 'package:desktop/desktop.dart';
import 'package:image_processor/features/image/data/repository/gray_scale_converter.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

PlatformMenu imageMenu({
  required ImageModel? model,
  required void Function(ImageModel model) onModelUpdate,
}) {
  final allowConvertToPGM = model != null && model.format != ImageFormat.pgm;

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
    ],
  );
}
