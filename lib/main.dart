import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_processor/ip_app.dart';
import 'package:macos_ui/macos_ui.dart';

Future<void> main() async {
  if (!kIsWeb && Platform.isMacOS) {
    await _configureMacosWindowUtils();
  }

  runApp(const IPApp());
}

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();

  await config.apply();
}
