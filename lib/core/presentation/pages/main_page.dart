import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_processor/features/files/presentation/utils/file_menu.dart';
import 'package:image_processor/features/files/presentation/utils/save_file.dart';
import 'package:image_processor/features/files/presentation/widgets/empty_file_widget.dart';
import 'package:image_processor/features/files/presentation/widgets/file_widget.dart';
import 'package:image_processor/core/presentation/widgets/ip_scaffold.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? _file;

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: _buildMenus(),
      child: IPScaffold(
        body:
            _file != null
                ? FileWidget(file: _file!)
                : EmptyFileWidget(onFilePicked: _onFilePicked),
      ),
    );
  }

  void _onFilePicked(File file) {
    setState(() {
      _file = file;
    });
  }

  List<PlatformMenuItem> _buildMenus() {
    return [
      PlatformMenu(
        label: 'Image Processor',
        menus: [
          PlatformMenuItem(
            label: 'About Image Processor',
            onSelected: () {
              print("TODO About Image Processor");
            },
          ),
        ],
      ),
      fileMenu(
        onFilePicked: _onFilePicked,
        onExportImage: () async {
          if (_file != null) {
            await saveFile(_file!);
          }
        },
      ),
    ];
  }
}
