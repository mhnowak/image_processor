import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class IPScaffold extends StatelessWidget {
  const IPScaffold({super.key, required this.body, this.actions});

  final Widget body;
  final List<ToolbarItem>? actions;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(title: Text('Image Processor'), actions: actions),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return body;
          },
        ),
      ],
    );
  }
}
