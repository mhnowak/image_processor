import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_processor/core/presentation/widgets/ip_progress_indicator.dart';
import 'package:macos_ui/macos_ui.dart';

const _kDialogBorderRadius = BorderRadius.all(Radius.circular(12.0));
const _kDefaultDialogConstraints = BoxConstraints(minWidth: 260, maxWidth: 260);

class IPDialog extends StatelessWidget {
  final String titleText;
  final bool isLoading;
  final VoidCallback? onApply;

  final Widget child;

  const IPDialog({
    super.key,
    required this.titleText,
    this.isLoading = false,
    this.onApply,
    required this.child,
  });

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
                titleText,
                style: theme.typography.title1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              child,
              const SizedBox(height: 16),
              _IPDialogActionButtons(isLoading: isLoading, onApply: onApply),
            ],
          ),
        ),
      ),
    );
  }
}

class _IPDialogActionButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onApply;

  const _IPDialogActionButtons({required this.isLoading, this.onApply});

  @override
  Widget build(BuildContext context) {
    final cancelButton = PushButton(
      secondary: true,
      controlSize: ControlSize.large,
      onPressed: isLoading ? null : () => Navigator.of(context).pop(),
      child: isLoading ? const IPProgressIndicator() : const Text('Cancel'),
    );

    if (onApply == null) {
      return cancelButton;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        cancelButton,
        const SizedBox(width: 16),
        PushButton(
          controlSize: ControlSize.large,
          onPressed: isLoading ? null : onApply,
          child: isLoading ? const IPProgressIndicator() : const Text('Apply'),
        ),
      ],
    );
  }
}
