import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<void> saveFile(File sourceFile) async {
  final String? outputPath = await FilePicker.platform.saveFile();

  if (outputPath == null) return;

  await sourceFile.copy(outputPath);
}
