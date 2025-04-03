import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

class ImageConverterRepository {
  Future<ImageModel> fromFile(File file) async {
    final extension = _extension(file.path).toLowerCase();
    final format = _getFormatFromExtension(extension);

    final contents = await file.readAsString();
    final lines = contents.split('\n');

    // Skip comments
    while (lines.isNotEmpty && lines.first.startsWith('#')) {
      lines.removeAt(0);
    }

    // Read magic number and validate
    final magicNumber = lines.removeAt(0).trim();
    if (!_isValidMagicNumber(magicNumber, format)) {
      throw FormatException('Invalid magic number for $format format');
    }

    // Read dimensions
    final dimensions = _readNextNonCommentLine(lines);
    final parts = dimensions.split(RegExp(r'\s+'));
    if (parts.length != 2) {
      throw FormatException('Invalid dimensions format');
    }

    final width = int.parse(parts[0]);
    final height = int.parse(parts[1]);

    // Read max value (except for PBM)
    int maxValue = 1;
    if (format != ImageFormat.pbm) {
      final maxValueLine = _readNextNonCommentLine(lines);
      maxValue = int.parse(maxValueLine);
    }

    final pixels = _readPixelData(lines, format, width, height);

    return ImageModel(
      format: format,
      width: width,
      height: height,
      maxValue: maxValue,
      pixels: pixels,
    );
  }

  String _extension(String filePath) =>
      filePath.substring(filePath.lastIndexOf('.'));

  ImageFormat _getFormatFromExtension(String extension) {
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

  /// Validates the magic number for the given format
  bool _isValidMagicNumber(String magicNumber, ImageFormat format) {
    switch (format) {
      case ImageFormat.pbm:
        return magicNumber == 'P1' || magicNumber == 'P4';
      case ImageFormat.pgm:
        return magicNumber == 'P2' || magicNumber == 'P5';
      case ImageFormat.ppm:
        return magicNumber == 'P3' || magicNumber == 'P6';
    }
  }

  String _readNextNonCommentLine(List<String> lines) {
    while (lines.isNotEmpty && lines.first.startsWith('#')) {
      lines.removeAt(0);
    }
    return lines.removeAt(0).trim();
  }

  Uint8List _readPixelData(
    List<String> lines,
    ImageFormat format,
    int width,
    int height,
  ) {
    switch (format) {
      case ImageFormat.pbm:
        return _readPbmData(lines, width, height);
      case ImageFormat.pgm:
        return _readPgmData(lines, width, height);
      case ImageFormat.ppm:
        return _readPpmData(lines, width, height);
    }
  }

  /// Reads PBM (binary) data
  Uint8List _readPbmData(List<String> lines, int width, int height) {
    final data = lines.join().trim();
    final pixels = <int>[];

    // Handle both space-separated and continuous string formats
    for (final char in data.split(RegExp(r'\s+'))) {
      if (char.isEmpty) continue;
      // For continuous string format, process each character
      for (final bit in char.split('')) {
        if (bit == '1' || bit == '0') {
          pixels.add(int.parse(bit));
        }
      }
    }

    if (pixels.length != width * height) {
      throw FormatException('Invalid number of pixels for PBM format');
    }

    return Uint8List.fromList(pixels);
  }

  /// Reads PGM (grayscale) data
  Uint8List _readPgmData(List<String> lines, int width, int height) {
    final data = lines.join(' ').trim();
    final pixels = <int>[];

    for (final value in data.split(' ')) {
      if (value.isNotEmpty) {
        pixels.add(int.parse(value));
      }
    }

    if (pixels.length != width * height) {
      throw FormatException('Invalid number of pixels for PGM format');
    }

    return Uint8List.fromList(pixels);
  }

  /// Reads PPM (color) data
  Uint8List _readPpmData(List<String> lines, int width, int height) {
    final data = lines.join(' ').trim();
    final pixels = <int>[];

    for (final value in data.split(' ')) {
      if (value.isNotEmpty) {
        pixels.add(int.parse(value));
      }
    }

    if (pixels.length != width * height * 3) {
      throw FormatException('Invalid number of pixels for PPM format');
    }

    return Uint8List.fromList(pixels);
  }
}
