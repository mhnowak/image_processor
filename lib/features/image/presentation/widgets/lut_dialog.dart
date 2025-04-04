import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_processor/features/image/data/repository/lut_image_converter.dart';
import 'package:image_processor/features/image/domain/models/image_model.dart';
import 'package:image_processor/features/image/domain/models/lut.dart';
import 'package:macos_ui/macos_ui.dart';

const _kDialogBorderRadius = BorderRadius.all(Radius.circular(12.0));
const _kDefaultDialogConstraints = BoxConstraints(minWidth: 260, maxWidth: 260);

class LutDialog {
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

    final brightness = MacosTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      Colors.black.withValues(alpha: 0.23),
      Colors.black.withValues(alpha: 0.76),
    );

    final innerBorderColor = brightness.resolve(
      Colors.white.withValues(alpha: 0.45),
      Colors.white.withValues(alpha: 0.15),
    );

    return Dialog(
      backgroundColor: brightness.resolve(
        CupertinoColors.systemGrey6.color,
        MacosColors.controlBackgroundColor.darkColor,
      ),
      shape: const RoundedRectangleBorder(borderRadius: _kDialogBorderRadius),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: innerBorderColor),
          borderRadius: _kDialogBorderRadius,
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.all(width: 1, color: outerBorderColor),
          borderRadius: _kDialogBorderRadius,
        ),
        child: ConstrainedBox(
          constraints: _kDefaultDialogConstraints,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Image Adjustments',
                style: theme.typography.title1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  PushButton(
                    secondary: true,
                    controlSize: ControlSize.large,
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              Navigator.of(context).pop();
                            },
                    child:
                        _isLoading
                            ? const ProgressCircle()
                            : const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  PushButton(
                    controlSize: ControlSize.large,
                    onPressed:
                        _isLoading
                            ? null
                            : () {
                              setState(() {
                                _isLoading = true;
                              });

                              final convertedImaged = LutImageConverter().call(
                                widget.image,
                                LutModel(
                                  brightness: _brightness,
                                  contrast: _contrast,
                                  gamma: _gamma,
                                ),
                              );

                              Navigator.of(context).pop(convertedImaged);
                            },
                    child:
                        _isLoading
                            ? const ProgressCircle()
                            : const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 56, child: Text(value.toStringAsFixed(2))),
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
