import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class IPProgressIndicator extends StatelessWidget {
  const IPProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: ProgressCircle());
  }
}
