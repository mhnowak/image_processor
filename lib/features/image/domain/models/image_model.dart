import 'dart:io';
import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/utils/image_file_utils.dart';
import 'package:image_processor/features/image/domain/utils/image_list_string_utils.dart';
import 'package:image_processor/features/image/domain/utils/read_pixel_data.dart';

/// Represents a portable image format (PBM, PGM, or PPM)
class ImageModel {
  /// The type of image format (PBM, PGM, or PPM)
  final ImageFormat format;

  /// The width of the image in pixels
  final int width;

  /// The height of the image in pixels
  final int height;

  /// The maximum pixel value (1 for PBM, typically 255 for PGM/PPM)
  final int maxValue;

  /// The raw pixel data
  final Uint8List pixels;

  /// Creates a new image model
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

    // Read magic number and validate
    final magicNumber = lines.readNextNonCommentLine();
    if (!format.isValid(magicNumber)) {
      throw FormatException('Invalid magic number for $format format');
    }

    // Read dimensions
    final dimensions = lines.readNextNonCommentLine();
    final parts = dimensions.split(RegExp(r'\s+'));
    if (parts.length != 2) {
      throw FormatException('Invalid dimensions format');
    }

    final width = int.parse(parts[0]);
    final height = int.parse(parts[1]);

    // Read max value (except for PBM)
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

  /// Returns the number of bytes per pixel based on the image format
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

  /// Returns the total number of pixels in the image
  int get totalPixels => width * height;

  /// Returns the total number of bytes in the pixel data
  int get totalBytes => totalPixels * bytesPerPixel;

  Uint8List toBytes() {
    // Create header string with format, dimensions, and max value
    final header =
        StringBuffer()
          ..write('P${format.formatNumber}\n')
          ..write('$width $height\n')
          // Only include maxValue for PGM and PPM formats
          ..write(format != ImageFormat.pbm ? '$maxValue\n' : '');

    // Convert header to bytes
    final headerBytes = Uint8List.fromList(header.toString().codeUnits);

    // Create final byte array combining header and pixel data
    final result = Uint8List(headerBytes.length + pixels.length);
    result.setAll(0, headerBytes);
    result.setAll(headerBytes.length, pixels);

    return result;
  }
}
