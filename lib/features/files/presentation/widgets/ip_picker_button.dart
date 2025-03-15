import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_processor/features/files/presentation/utils/pick_file.dart';

class IPPickerButton extends StatelessWidget {
  const IPPickerButton({super.key, required this.onFilePicked});

  final void Function(File file) onFilePicked;

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: _pickFile, icon: const Icon(Icons.file_open));
  }

  Future<void> _pickFile() async {
    final file = await pickSingleFile();
    if (file != null) {
      onFilePicked(file);
    }
  }
}
