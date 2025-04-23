import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_processor/core/presentation/widgets/ip_dialog.dart';
import 'package:image_processor/features/correction/data/transformations/correction_transformation.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/correction/domain/models/correction_args_model.dart';
import 'package:macos_ui/macos_ui.dart';

class CorrectionDialog {
  static Future<ImageModel?> show(
    BuildContext context,
    ImageModel image,
  ) async {
    return showMacosAlertDialog(
      context: context,
      builder: (_) => _LutDialogWidget(image: image),
    );
  }
}

class _LutDialogWidget extends StatefulWidget {
  final ImageModel image;

  const _LutDialogWidget({required this.image});

  @override
  State<_LutDialogWidget> createState() => _LutDialogWidgetState();
}

class _LutDialogWidgetState extends State<_LutDialogWidget> {
  double _brightness = 0.0;
  double _contrast = 0.0;
  double _gamma = 1.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = MacosTheme.of(context);

    return IPDialog(
      titleText: 'Image Adjustments',
      isLoading: _isLoading,
      onApply: () {
        setState(() {
          _isLoading = true;
        });

        final convertedImaged = CorrectionTransformation().call(
          widget.image,
          CorrectionArgsModel(brightness: _brightness, contrast: _contrast, gamma: _gamma),
        );

        Navigator.of(context).pop(convertedImaged);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Brightness',
            style: theme.typography.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _LutSlider(
            value: _brightness,
            min: -1.0,
            max: 1.0,
            onChanged: (value) {
              if (_isLoading) return;

              setState(() {
                _brightness = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Contrast',
            style: theme.typography.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _LutSlider(
            value: _contrast,
            min: -1.0,
            max: 1.0,
            onChanged: (value) {
              if (_isLoading) return;

              setState(() {
                _contrast = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Gamma',
            style: theme.typography.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _LutSlider(
            value: _gamma,
            min: 0.01,
            max: 5.0,
            onChanged: (value) {
              if (_isLoading) return;

              setState(() {
                _gamma = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _LutSlider extends StatelessWidget {
  final double value;
  final void Function(double value) onChanged;
  final double min;
  final double max;

  const _LutSlider({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MacosTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 56,
          child: Text(
            value.toStringAsFixed(2),
            style: theme.typography.headline,
          ),
        ),
        // const SizedBox(width: 16),
        SizedBox(
          width: 200,
          child: MacosSlider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
          ),
        ),
      ],
    );
  }
}
