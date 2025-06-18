import 'dart:typed_data';

import 'package:image_processor/features/convolution/data/transformations/gauss_fnc.dart';
import 'package:image_processor/features/image/domain/models/image_format.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/grayscale/data/transformations/gray_scale_transformation.dart';
import 'package:image_processor/features/convolution/data/transformations/gauss_transformation.dart';
import 'package:image_processor/features/convolution/data/transformations/convolution_transformation.dart';
import 'package:image_processor/features/edges/data/transformations/sobel_transformation.dart';

class HarrisTransformations {
  final double threshold;
  final double sigma;
  final double sigmaWeight;
  final double kParam;

  HarrisTransformations({
    this.threshold = 30000000.0,
    this.sigma = 1.0,
    this.sigmaWeight = 0.76,
    this.kParam = 0.05,
  });

  ImageModel call(ImageModel image) {
    return transform(image);
  }

  ImageModel transform(ImageModel image) {
    final grayImage = _ensureGrayscale(image);

    final gaussTransform = GaussTransformation(sigma: sigma);
    final blurredImage = gaussTransform.call(grayImage, EdgeMode.repeat);

    final (gx, gy) = _computeSobelGradients(blurredImage);

    final width = image.width;
    final height = image.height;
    final ixx = List.generate(height, (i) => List.filled(width, 0.0));
    final iyy = List.generate(height, (i) => List.filled(width, 0.0));
    final ixy = List.generate(height, (i) => List.filled(width, 0.0));
    final cornerCandidates = List.generate(
      height,
      (i) => List.filled(width, 0.0),
    );

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        final gxVal = gx[i][j];
        final gyVal = gy[i][j];
        ixx[i][j] = gxVal * gxVal;
        iyy[i][j] = gyVal * gyVal;
        ixy[i][j] = gxVal * gyVal;
      }
    }

    for (int i = 1; i < height - 1; i++) {
      for (int j = 1; j < width - 1; j++) {
        double sxx = 0.0, syy = 0.0, sxy = 0.0;

        for (int k = -1; k <= 1; k++) {
          for (int l = -1; l <= 1; l++) {
            final gaussWeight = getGauss(k, l, sigma) * sigmaWeight;
            sxx += ixx[i + k][j + l] * gaussWeight;
            syy += iyy[i + k][j + l] * gaussWeight;
            sxy += ixy[i + k][j + l] * gaussWeight;
          }
        }

        final det = sxx * syy - sxy * sxy;
        final trace = sxx + syy;
        final r = det - kParam * trace * trace;

        if (r > threshold) {
          cornerCandidates[i][j] = r;
        }
      }
    }

    final cornerNonmaxSuppress = List.generate(
      height,
      (i) => List.filled(width, 0.0),
    );

    bool search = true;
    while (search) {
      search = false;

      for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
          cornerNonmaxSuppress[i][j] = 0.0;
        }
      }

      for (int i = 1; i < height - 1; i++) {
        for (int j = 1; j < width - 1; j++) {
          if (cornerCandidates[i][j] > 0) {
            bool isMaximum = true;
            final currentValue = cornerCandidates[i][j];

            for (int k = -1; k <= 1 && isMaximum; k++) {
              for (int l = -1; l <= 1 && isMaximum; l++) {
                if (k == 0 && l == 0) continue;
                if (cornerCandidates[i + k][j + l] > currentValue) {
                  isMaximum = false;
                }
              }
            }

            if (isMaximum) {
              cornerNonmaxSuppress[i][j] = currentValue;
            } else {
              search = true;
            }
          }
        }
      }

      for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
          cornerCandidates[i][j] = cornerNonmaxSuppress[i][j];
        }
      }
    }

    final pixels = Uint8List(width * height);
    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        final index = i * width + j;
        pixels[index] = cornerCandidates[i][j] == 0.0 ? 0 : 255;
      }
    }

    return ImageModel(
      format: ImageFormat.pgm,
      width: width,
      height: height,
      maxValue: 255,
      pixels: pixels,
    );
  }

  ImageModel _ensureGrayscale(ImageModel image) {
    if (image.format == ImageFormat.pgm) {
      return image;
    }

    final grayScaleTransformation = GrayScaleTransformation();
    return grayScaleTransformation.call(image);
  }

  (List<List<double>>, List<List<double>>) _computeSobelGradients(
    ImageModel image,
  ) {
    final sobelTransform = SobelTransformation();
    final width = image.width;
    final height = image.height;

    final gx = List.generate(height, (i) => List.filled(width, 0.0));
    final gy = List.generate(height, (i) => List.filled(width, 0.0));

    final horizontalMask = sobelTransform.getHorizontalMask();
    final verticalMask = sobelTransform.getVerticalMask();

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final horizontalWindow = sobelTransform.getWindow(
          image,
          x,
          y,
          horizontalMask.length,
          0,
          EdgeMode.repeat,
        );
        final horizontalResult = sobelTransform.join(
          horizontalWindow,
          horizontalMask,
        );
        gx[y][x] = sobelTransform.sum(horizontalResult);

        final verticalWindow = sobelTransform.getWindow(
          image,
          x,
          y,
          verticalMask.length,
          0,
          EdgeMode.repeat,
        );
        final verticalResult = sobelTransform.join(
          verticalWindow,
          verticalMask,
        );
        gy[y][x] = sobelTransform.sum(verticalResult);
      }
    }

    return (gx, gy);
  }
}
