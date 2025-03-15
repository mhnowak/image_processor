import 'package:flutter/material.dart';
import 'package:image_processor/core/presentation/pages/main_page.dart';
import 'package:macos_ui/macos_ui.dart';

class IPApp extends StatelessWidget {
  const IPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      debugShowCheckedModeBanner: false,
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}
