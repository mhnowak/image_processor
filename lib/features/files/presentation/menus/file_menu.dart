import 'dart:io';

import 'package:desktop/desktop.dart';
import 'package:image_processor/features/files/presentation/utils/pick_file.dart';

PlatformMenu fileMenu({
  required void Function(File) onFilePicked,
  required void Function() onExportImage,
}) {
  return PlatformMenu(
    label: 'File',
    menus: [
      PlatformMenuItem(
        label: 'Import Image',
        onSelected: () async {
          final file = await pickSingleFile();
          if (file != null) {
            onFilePicked(file);
          }
        },
      ),
      PlatformMenuItem(label: 'Export Image', onSelected: onExportImage),
    ],
  );
}
