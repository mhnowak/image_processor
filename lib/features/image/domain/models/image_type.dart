enum ImageType {
  binary,
  ascii;

  static ImageType fromString(String value) {
    switch (value) {
      case 'P1' || 'P2' || 'P3':
        return ImageType.ascii;
      case 'P4' || 'P5' || 'P6':
        return ImageType.binary;
      default:
        throw FormatException('Invalid image type: $value');
    }
  }
}
