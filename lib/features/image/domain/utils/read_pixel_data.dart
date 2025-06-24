import 'dart:typed_data';

import 'package:image_processor/features/image/domain/models/image_format.dart';

Uint8List readPixelDataFromBytes({
  required Uint8List bytes,
  required ImageFormat format,
  required int width,
  required int height,
}) {
  final bytesLength = _getBytesLength(format, width, height);

  return bytes.sublist(bytes.length - bytesLength);
}

Uint8List readPixelDataFromString({
  required List<String> lines,
  required ImageFormat format,
  required int width,
  required int height,
}) {
  switch (format) {
    case ImageFormat.pbm:
      return _readPbmData(lines, width, height);
    case ImageFormat.pgm:
      return _readPgmData(lines, width, height);
    case ImageFormat.ppm:
      return _readPpmData(lines, width, height);
  }
}

int _getBytesLength(ImageFormat format, int width, int height) {
  switch (format) {
    case ImageFormat.pbm:
      return width * height;
    case ImageFormat.pgm:
      return width * height;
    case ImageFormat.ppm:
      return width * height * 3;
  }
}

Uint8List _readPbmData(List<String> lines, int width, int height) {
  final data = lines.join().trim();
  final pixels = <int>[];

  for (final char in data.split(RegExp(r'\s+'))) {
    if (char.isEmpty) continue;

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
