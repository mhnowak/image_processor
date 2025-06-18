import 'dart:io';
import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/utils/image_file_utils.dart';
import 'package:image_processor/features/image/domain/utils/image_list_string_utils.dart';
import 'package:image_processor/features/image/domain/utils/read_pixel_data.dart';

class ImageModel {
    final ImageFormat format;

    final int width;

    final int height;

    final int maxValue;

    final Uint8List pixels;

    const ImageModel({
    required this.format,
    required this.width,
    required this.height,
    required this.maxValue,
    required this.pixels,
  });

  factory ImageModel.fromFile(File file) {
    final format = file.imageFormat;

    final contents = file.readAsStringSync();
    final lines = contents.split('\n');

        final magicNumber = lines.readNextNonCommentLine();
    if (!format.isValid(magicNumber)) {
      throw FormatException('Invalid magic number for $format format');
    }

        final dimensions = lines.readNextNonCommentLine();
    final parts = dimensions.split(RegExp(r'\s+'));
    if (parts.length != 2) {
      throw FormatException('Invalid dimensions format');
    }

    final width = int.parse(parts[0]);
    final height = int.parse(parts[1]);

        int maxValue = 1;
    if (format != ImageFormat.pbm) {
      final maxValueLine = lines.readNextNonCommentLine();
      maxValue = int.parse(maxValueLine);
    }

    final pixels = readPixelData(lines, format, width, height);

    return ImageModel(
      format: format,
      width: width,
      height: height,
      maxValue: maxValue,
      pixels: pixels,
    );
  }

    int get bytesPerPixel {
    switch (format) {
      case ImageFormat.pbm:
        return 1;
      case ImageFormat.pgm:
        return 1;
      case ImageFormat.ppm:
        return 3;
    }
  }

    int get totalPixels => width * height;

    int get totalBytes => totalPixels * bytesPerPixel;

  Uint8List toBytes() {
        final header =
        StringBuffer()
          ..write('P${format.formatNumber}\n')
          ..write('$width $height\n')
                    ..write(format != ImageFormat.pbm ? '$maxValue\n' : '');

        final headerBytes = Uint8List.fromList(header.toString().codeUnits);

        final result = Uint8List(headerBytes.length + pixels.length);
    result.setAll(0, headerBytes);
    result.setAll(headerBytes.length, pixels);

    return result;
  }
}
