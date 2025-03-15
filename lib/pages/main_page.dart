import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_processor/widgets/ip_picker_button.dart';
import 'package:image_processor/widgets/ip_scaffold.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return IPScaffold(
      floatingActionButton: IPPickerButton(
        onFilePicked: (file) {
          setState(() {
            _file = file;
          });
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_file != null) ...[
              Text(_file!.path),
              Expanded(child: Image.file(_file!)),
            ],
          ],
        ),
      ),
    );
  }
}
