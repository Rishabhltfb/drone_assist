import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  appBarTheme: AppBarTheme(brightness: Brightness.dark),
  scaffoldBackgroundColor: Color(0xffe2e7ea),
  primaryColor: Colors.black,
  accentColor: Colors.black,
  splashColor: Colors.white,
  buttonColor: Colors.black,
  fontFamily: "Nuntino Sans",
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(Colors.grey),
  ),
  textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.grey),
);
