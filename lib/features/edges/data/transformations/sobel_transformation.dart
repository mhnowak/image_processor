import 'package:image_processor/features/convolution/data/transformations/convolution_transformation.dart';
import 'package:image_processor/features/edges/data/transformations/edge_transformation.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

class SobelTransformation extends EdgeTransformation {
  @override
  List<List<double>> getHorizontalMask() {
    return [
      [-1, 0, 1],
      [-2, 0, 2],
      [-1, 0, 1],
    ];
  }

  @override
  List<List<double>> getVerticalMask() {
    return [
      [-1, -2, -1],
      [0, 0, 0],
      [1, 2, 1],
    ];
  }

  @override
  ImageModel call(
    ImageModel image,
    EdgeMode edgeMode, {
    List<List<double>>? mask,
  }) {
    return transform(image, edgeMode);
  }
}
