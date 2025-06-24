import 'dart:io';
import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_type.dart';
import 'package:image_processor/features/image/domain/utils/image_file_utils.dart';
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

    final bytes = file.readAsBytesSync();

    String? magicNumber;
    int? width;
    int? height;
    int? maxValue;

    StringBuffer currentLine = StringBuffer();
    int i = 0;
    while (magicNumber == null ||
        width == null ||
        height == null ||
        maxValue == null) {
      if (bytes[i] == 10) {
        final line = currentLine.toString().trim();
        if (line.startsWith('#')) {
          // Skip comment
        } else if (line.startsWith('P')) {
          magicNumber = line;
          maxValue = getMaxValueFromMagicNumber(magicNumber);
        } else if (width == null && height == null) {
          final parts = line.split(RegExp(r'\s+'));

          if (parts.length != 2) {
            throw FormatException('Invalid dimensions format');
          }

          width = int.parse(parts[0]);
          height = int.parse(parts[1]);
        } else {
          maxValue ??= int.parse(line);
        }

        currentLine.clear();
      }

      final char = String.fromCharCode(bytes[i]);
      currentLine.write(char);
      i++;
    }

    currentLine.clear();
    List<String> lines = [];
    while (i < bytes.length) {
      final char = String.fromCharCode(bytes[i]);
      currentLine.write(char);
      if (char == '\n') {
        lines.add(currentLine.toString().trim());
        currentLine.clear();
      }
      i++;
    }

    final type = ImageType.fromString(magicNumber);

    late Uint8List pixels;
    if (type == ImageType.ascii) {
      pixels = readPixelDataFromString(
        lines: lines,
        format: format,
        width: width,
        height: height,
      );
    } else {
      pixels = readPixelDataFromBytes(
        bytes: bytes,
        format: format,
        width: width,
        height: height,
      );
    }

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

int? getMaxValueFromMagicNumber(String magicNumber) {
  if (magicNumber == 'P1' || magicNumber == 'P4') {
    return 1;
  }
  return null;
}
