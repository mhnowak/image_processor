import 'package:flutter/material.dart';

class IPScaffold extends StatelessWidget {
  const IPScaffold({super.key, required this.body, this.floatingActionButton});

  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body, floatingActionButton: floatingActionButton);
  }
}
