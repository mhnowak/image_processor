import 'package:image_processor/features/convolution/data/transformations/convolution_transformation.dart';
import 'package:image_processor/features/convolution/data/transformations/gauss_fnc.dart';

const double defaultSigma = 1.6;

class GaussTransformation extends ConvolutionTransformation {
  GaussTransformation({double sigma = defaultSigma}) : _sigma = sigma;

  final double _sigma;

  @override
  List<List<double>> getMask(int size) {
    return _getMaskWithSigma(size, _sigma);
  }

  List<List<double>> _getMaskWithSigma(int size, double sigma) {
    final mask = List.generate(size, (i) => List.generate(size, (j) => 0.0));
    final center = size ~/ 2;

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        final x = j - center;
        final y = i - center;
        mask[i][j] = getGauss(x, y, sigma);
      }
    }

    return mask;
  }
}
