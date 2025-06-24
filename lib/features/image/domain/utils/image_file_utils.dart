import 'dart:io';

import 'package:image_processor/features/image/domain/models/image_format.dart';

extension ImageFileUtils on File {
  ImageFormat get imageFormat {
    final extension = path.substring(path.lastIndexOf('.')).toLowerCase();

    switch (extension) {
      case '.pbm':
        return ImageFormat.pbm;
      case '.pgm':
        return ImageFormat.pgm;
      case '.ppm':
        return ImageFormat.ppm;
      default:
        throw FormatException('Unsupported file format: $extension');
    }
  }

}
