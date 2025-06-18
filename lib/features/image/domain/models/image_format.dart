enum ImageFormat {
  pbm,
  pgm,
  ppm;

  int get formatNumber {
    switch (this) {
      case pbm:
        return 4;
      case pgm:
        return 5;
      case ppm:
        return 6;
    }
  }

  bool isValid(String magicNumber) {
    switch (this) {
      case pbm:
        return magicNumber == 'P1' || magicNumber == 'P4';
      case pgm:
        return magicNumber == 'P2' || magicNumber == 'P5';
      case ppm:
        return magicNumber == 'P3' || magicNumber == 'P6';
    }
  }
}
