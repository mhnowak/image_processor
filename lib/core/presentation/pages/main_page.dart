import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_processor/features/files/presentation/utils/file_menu.dart';
import 'package:image_processor/features/files/presentation/utils/save_file.dart';
import 'package:image_processor/features/files/presentation/widgets/empty_file_widget.dart';
import 'package:image_processor/core/presentation/widgets/ip_scaffold.dart';
import 'package:image_processor/features/image/data/repository/image_converter_repository.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/image/presentation/utils/image_menu.dart';
import 'package:image_processor/features/image/presentation/widgets/image_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ImageModel? _imageModel;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: _buildMenus(),
      child: IPScaffold(
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_imageModel != null) {
              return ImageWidget(imageModel: _imageModel!);
            }

            return EmptyFileWidget(onFilePicked: _onFilePicked);
          },
        ),
      ),
    );
  }

  Future<void> _onFilePicked(File file) async {
    setState(() {
      _isLoading = true;
    });

    _imageModel = await ImageConverterRepository().fromFile(file);

    setState(() {
      _isLoading = false;
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
          if (_imageModel != null) {
            await saveFile(_imageModel!.toBytes());
          }
        },
      ),
      imageMenu(
        model: _imageModel,
        onModelUpdate: (model) {
          setState(() {
            _imageModel = model;
          });
        },
      ),
    ];
  }
}
