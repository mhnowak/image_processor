import 'dart:typed_data';

/// Enum representing the different types of portable image formats
enum ImageFormat {
  /// Portable Bitmap (black and white)
  pbm,

  /// Portable Graymap (grayscale)
  pgm,

  /// Portable Pixmap (color)
  ppm,
}

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

  /// Creates a PBM (Portable Bitmap) image
  factory ImageModel.pbm({
    required int width,
    required int height,
    required Uint8List pixels,
  }) {
    return ImageModel(
      format: ImageFormat.pbm,
      width: width,
      height: height,
      maxValue: 1,
      pixels: pixels,
    );
  }

  /// Creates a PGM (Portable Graymap) image
  factory ImageModel.pgm({
    required int width,
    required int height,
    required int maxValue,
    required Uint8List pixels,
  }) {
    return ImageModel(
      format: ImageFormat.pgm,
      width: width,
      height: height,
      maxValue: maxValue,
      pixels: pixels,
    );
  }

  /// Creates a PPM (Portable Pixmap) image
  factory ImageModel.ppm({
    required int width,
    required int height,
    required int maxValue,
    required Uint8List pixels,
  }) {
    return ImageModel(
      format: ImageFormat.ppm,
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
          ..write('P${_getFormatNumber()}\n')
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

  int _getFormatNumber() {
    switch (format) {
      case ImageFormat.pbm:
        return 4; // P4 for binary PBM
      case ImageFormat.pgm:
        return 5; // P5 for binary PGM
      case ImageFormat.ppm:
        return 6; // P6 for binary PPM
    }
  }
}
