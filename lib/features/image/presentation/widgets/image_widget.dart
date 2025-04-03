import 'package:flutter/material.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.imageModel});

  final ImageModel imageModel;

  @override
  Widget build(BuildContext context) {
    return Image.memory(imageModel.toBytes());
  }
}
