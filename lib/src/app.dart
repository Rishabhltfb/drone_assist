import 'package:drone_assist/src/helper/themeData.dart';
import 'package:drone_assist/src/screens/home_screen.dart';
import 'package:drone_assist/src/screens/tts_screen.dart';
import 'package:drone_assist/src/screens/new_screen.dart';
import 'package:drone_assist/src/utils/app_utils.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: theme,
      routes: {
        '/': (BuildContext context) => HomeScreen(),
        '/tts': (BuildContext context) => TTSScreen(),
        '/new': (BuildContext context) => NewPage(),
      },
      initialRoute: '/',
    );
  }
}
