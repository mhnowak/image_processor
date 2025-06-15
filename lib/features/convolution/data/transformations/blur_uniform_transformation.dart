import 'package:image_processor/features/convolution/data/transformations/convolution_transformation.dart';

class BlurUniformTransformation extends ConvolutionTransformation {
  @override
  List<List<double>> getMask(int size) {
    final mask = List.generate(size, (i) => List.generate(size, (j) => 1.0));

    return mask;
  }
}
