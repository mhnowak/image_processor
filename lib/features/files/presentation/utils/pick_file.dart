import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File?> pickSingleFile() async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: false);

  if (result == null) return null;

  final filePath = result.files.first.path!;
  return File(filePath);
}
