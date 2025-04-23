import 'dart:typed_data';

import 'package:image_processor/features/histogram/domain/models/histogram_model.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';

class HistogramEqualizationTransformation {
  ImageModel call(ImageModel image) {
    assert(image.format == ImageFormat.ppm, 'Only PPM format is supported');

    final histogram = HistogramModel.fromImage(image);

    final redCDF = histogram.cdfRed;
    final greenCDF = histogram.cdfGreen;
    final blueCDF = histogram.cdfBlue;

    final pixels = Uint8List(image.pixels.length);
    for (int i = 0; i < image.pixels.length; i += 3) {
      pixels[i] = redCDF[image.pixels[i]];
      pixels[i + 1] = greenCDF[image.pixels[i + 1]];
      pixels[i + 2] = blueCDF[image.pixels[i + 2]];
    }

    return ImageModel(
      format: image.format,
      width: image.width,
      height: image.height,
      maxValue: 255,
      pixels: pixels,
    );
  }
}
