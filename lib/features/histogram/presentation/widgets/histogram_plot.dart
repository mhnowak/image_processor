import 'package:flutter/material.dart';
import '../../domain/models/histogram_model.dart';

class HistogramPlot extends StatelessWidget {
  final HistogramModel histogram;
  final double width;
  final double height;
  final bool showGrayscale;
  final bool showRed;
  final bool showGreen;
  final bool showBlue;
  final Color redColor;
  final Color greenColor;
  final Color blueColor;
  final Color grayscaleColor;

  const HistogramPlot({
    super.key,
    required this.histogram,
    this.width = 256,
    this.height = 100,
    this.showGrayscale = true,
    this.showRed = true,
    this.showGreen = true,
    this.showBlue = true,
    this.redColor = Colors.red,
    this.greenColor = Colors.green,
    this.blueColor = Colors.blue,
    this.grayscaleColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _HistogramPainter(
          histogram: histogram,
          showGrayscale: showGrayscale,
          showRed: showRed,
          showGreen: showGreen,
          showBlue: showBlue,
          redColor: redColor,
          greenColor: greenColor,
          blueColor: blueColor,
          grayscaleColor: grayscaleColor,
        ),
      ),
    );
  }
}

class _HistogramPainter extends CustomPainter {
  final HistogramModel histogram;
  final bool showGrayscale;
  final bool showRed;
  final bool showGreen;
  final bool showBlue;
  final Color redColor;
  final Color greenColor;
  final Color blueColor;
  final Color grayscaleColor;

  _HistogramPainter({
    required this.histogram,
    required this.showGrayscale,
    required this.showRed,
    required this.showGreen,
    required this.showBlue,
    required this.redColor,
    required this.greenColor,
    required this.blueColor,
    required this.grayscaleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = histogram.maxValue.toDouble();
    final width = size.width;
    final height = size.height;
    final barWidth = width / 256;

    if (showGrayscale) {
      final grayscalePaint =
          Paint()
            ..color = grayscaleColor
            ..strokeWidth = barWidth
            ..style = PaintingStyle.stroke;

      for (int i = 0; i < 256; i++) {
        final x = i * barWidth;
        final barHeight = (histogram.grayscale[i] / maxValue) * height;
        final y = height - barHeight;
        canvas.drawLine(Offset(x, height), Offset(x, y), grayscalePaint);
      }
    }

    final redPaint =
        Paint()
          ..color = redColor.withAlpha(128)
          ..strokeWidth = barWidth
          ..style = PaintingStyle.stroke;

    final greenPaint =
        Paint()
          ..color = greenColor.withAlpha(128)
          ..strokeWidth = barWidth
          ..style = PaintingStyle.stroke;

    final bluePaint =
        Paint()
          ..color = blueColor.withAlpha(128)
          ..strokeWidth = barWidth
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < 256; i++) {
      final x = i * barWidth;

      if (showRed) {
        final redHeight = (histogram.red[i] / maxValue) * height;
        final redY = height - redHeight;
        canvas.drawLine(Offset(x, height), Offset(x, redY), redPaint);
      }

      if (showGreen) {
        final greenHeight = (histogram.green[i] / maxValue) * height;
        final greenY = height - greenHeight;
        canvas.drawLine(Offset(x, height), Offset(x, greenY), greenPaint);
      }

      if (showBlue) {
        final blueHeight = (histogram.blue[i] / maxValue) * height;
        final blueY = height - blueHeight;
        canvas.drawLine(Offset(x, height), Offset(x, blueY), bluePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HistogramPainter oldDelegate) =>
      histogram != oldDelegate.histogram ||
      showGrayscale != oldDelegate.showGrayscale ||
      showRed != oldDelegate.showRed ||
      showGreen != oldDelegate.showGreen ||
      showBlue != oldDelegate.showBlue;
}
