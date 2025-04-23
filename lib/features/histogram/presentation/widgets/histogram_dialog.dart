import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_processor/core/presentation/widgets/ip_dialog.dart';
import 'package:image_processor/features/histogram/domain/models/histogram_model.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/histogram/presentation/widgets/histogram_plot.dart';
import 'package:macos_ui/macos_ui.dart';

class HistogramDialog {
  static Future<ImageModel?> show(
    BuildContext context,
    ImageModel image,
  ) async {
    return showMacosAlertDialog(
      context: context,
      builder: (_) => _HistogramDialogWidget(image: image),
    );
  }
}

class _HistogramDialogWidget extends StatefulWidget {
  final ImageModel image;

  const _HistogramDialogWidget({required this.image});

  @override
  State<_HistogramDialogWidget> createState() => _HistogramDialogWidgetState();
}

class _HistogramDialogWidgetState extends State<_HistogramDialogWidget> {
  late final HistogramModel _histogram;
  bool _showRed = true;
  bool _showGreen = true;
  bool _showBlue = true;
  bool _showGrayscale = true;

  @override
  void initState() {
    super.initState();
    _histogram = HistogramModel.fromImage(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return IPDialog(
      titleText: 'Histogram',
      child: Column(
        children: [
          HistogramPlot(
            histogram: _histogram,
            showRed: _showRed,
            showGreen: _showGreen,
            showBlue: _showBlue,
            showGrayscale: _showGrayscale,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _ShowChannelButton(
                enabled: _showRed,
                onPressed: () {
                  setState(() {
                    _showRed = !_showRed;
                  });
                },
                color: Colors.red,
              ),
              _ShowChannelButton(
                enabled: _showGreen,
                onPressed: () {
                  setState(() {
                    _showGreen = !_showGreen;
                  });
                },
                color: Colors.green,
              ),
              _ShowChannelButton(
                enabled: _showBlue,
                onPressed: () {
                  setState(() {
                    _showBlue = !_showBlue;
                  });
                },
                color: Colors.blue,
              ),
              _ShowChannelButton(
                enabled: _showGrayscale,
                onPressed: () {
                  setState(() {
                    _showGrayscale = !_showGrayscale;
                  });
                },
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShowChannelButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  final Color color;

  const _ShowChannelButton({
    required this.enabled,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return MacosIconButton(
      onPressed: onPressed,
      icon: Icon(
        enabled ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
        color: enabled ? color : color.withAlpha(128),
      ),
    );
  }
}
