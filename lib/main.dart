import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drone_assist/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setSystemChromeSettings();
  runApp(App());
}

void setSystemChromeSettings() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.dark,
      statusBarIconBrightness: Brightness.light));
}
