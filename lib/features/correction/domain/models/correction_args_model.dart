import 'dart:math' as math;

class CorrectionArgsModel {
  final double brightness;
  final double contrast;
  final double gamma;

  const CorrectionArgsModel({
    required this.brightness,
    required this.contrast,
    required this.gamma,
  });

  List<int> createBrightnessLUT() {
    final table = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      table[i] = (i + brightness * 255).round().clamp(0, 255);
    }
    return table;
  }

  List<int> createContrastLUT() {
    final table = List<int>.filled(256, 0);
    final factor =
        (259 * (contrast * 100 + 255)) / (255 * (259 - contrast * 100));
    for (int i = 0; i < 256; i++) {
      table[i] = ((factor * (i - 128) + 128)).round().clamp(0, 255);
    }
    return table;
  }

  List<int> createGammaLUT() {
    final table = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      table[i] = (math.pow(i / 255, gamma) * 255).round().clamp(0, 255);
    }
    return table;
  }
}
