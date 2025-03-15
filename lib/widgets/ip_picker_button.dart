import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class IPPickerButton extends StatelessWidget {
  const IPPickerButton({super.key, required this.onFilePicked});

  final void Function(File file) onFilePicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _readFile, icon: const Icon(Icons.file_open));
  }

  Future<void> _readFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.isSinglePick) {
      final filePath = result.files.first.path!;
      final file = File(filePath);

      onFilePicked(file);
    }
  }
}
