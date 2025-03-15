import 'package:flutter/material.dart';
import 'package:image_processor/pages/main_page.dart';

class IPApp extends StatelessWidget {
  const IPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
