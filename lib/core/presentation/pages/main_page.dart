import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_processor/core/presentation/widgets/ip_progress_indicator.dart';
import 'package:image_processor/features/convolution/presentation/menus/convolution_menus.dart';
import 'package:image_processor/features/correction/presentation/menus/correction_menu_item.dart';
import 'package:image_processor/features/files/presentation/menus/file_menu.dart';
import 'package:image_processor/features/files/presentation/utils/save_file.dart';
import 'package:image_processor/features/files/presentation/widgets/empty_file_widget.dart';
import 'package:image_processor/core/presentation/widgets/ip_scaffold.dart';
import 'package:image_processor/features/grayscale/presentation/menus/gray_scale_menu_item.dart';
import 'package:image_processor/features/histogram/presentation/menus/histogram_transformations_menu_item_group.dart';
import 'package:image_processor/features/histogram/presentation/menus/show_histogram_menu_item.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
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
      menus: _buildMenus(context),
      child: IPScaffold(
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return const IPProgressIndicator();
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

  void _onFilePicked(File file) {
    setState(() {
      _isLoading = true;
    });

    _imageModel = ImageModel.fromFile(file);

    setState(() {
      _isLoading = false;
    });
  }

  List<PlatformMenuItem> _buildMenus(BuildContext context) {
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
      PlatformMenu(
        label: 'Edit',
        menus: [
          grayScaleMenuItem(_imageModel, _onImageUpdate),
          correctionMenuItem(context, _imageModel, _onImageUpdate),
          histogramTransformationsGroup(context, _imageModel, _onImageUpdate),
          ...convolutionMenuItems(context, _imageModel, _onImageUpdate),
        ],
      ),
      PlatformMenu(
        label: 'View',
        menus: [showHistogramMenuItem(context, _imageModel, _onImageUpdate)],
      ),
    ];
  }

  void _onImageUpdate(ImageModel image) {
    setState(() {
      _imageModel = image;
    });
  }
}
