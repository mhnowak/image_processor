import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:image_processor/features/files/presentation/utils/allowed_file_extensions.dart';

class EmptyFileWidget extends StatelessWidget {
  const EmptyFileWidget({super.key, required this.onFilePicked});

  final void Function(File) onFilePicked;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) {
        final files = details.files;

        if (files.length != 1) _showMultipleFilesError();

        final file = files.first.path;

        if (!isAllowedFileExtension(file)) _showInvalidFileError();

        onFilePicked(File(file));
      },
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No file selected'),
            Text('Drag and drop or select a file'),
          ],
        ),
      ),
    );
  }

  void _showMultipleFilesError() {
    print('Multiple files dropped');
  }

  void _showInvalidFileError() {
    print('Invalid file dropped');
  }
}
