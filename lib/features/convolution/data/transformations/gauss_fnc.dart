import 'dart:math';

double getGauss(int x, int y, double sigma) {
  final coefficient = 1.0 / (2 * pi * sigma * sigma);
  final exponent = -((x * x + y * y) / (2 * sigma * sigma));
  return coefficient * exp(exponent);
}
