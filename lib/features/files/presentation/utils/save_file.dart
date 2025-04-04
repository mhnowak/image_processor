import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<void> saveFile(Uint8List data) async {
  final String? outputPath = await FilePicker.platform.saveFile();

  if (outputPath == null) return;

  await File(outputPath).writeAsBytes(data);
}
