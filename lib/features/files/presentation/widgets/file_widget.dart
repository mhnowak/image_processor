import 'dart:io';

import 'package:flutter/material.dart';

class FileWidget extends StatelessWidget {
  const FileWidget({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Image.file(file));
  }
}
