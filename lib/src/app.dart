import 'package:drone_assist/src/helper/themeData.dart';
import 'package:drone_assist/src/providers/checklist_provider.dart';
import 'package:drone_assist/src/providers/user_provider.dart';
import 'package:drone_assist/src/screens/auth_screen.dart';
import 'package:drone_assist/src/screens/home_screen.dart';
import 'package:drone_assist/src/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => ChecklistProvider()),
      ],
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: appName,
            theme: theme,
            home: homeScreen(context, snapshot),
          );
        },
        // routes: {
        //   '/': (BuildContext context) => HomeScreen(),
        //   '/auth': (BuildContext context) => AuthScreen(),
        //   '/tts': (BuildContext context) => TTSScreen(),
        //   '/new': (BuildContext context) => NewPage(),
        // },
        // initialRoute: '/auth',
      ),
    );
  }

  Widget homeScreen(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    if (snapshot.connectionState != ConnectionState.active) {
      return Center(child: CircularProgressIndicator());
    }
    final user = snapshot.data;
    if (user != null &&
        FirebaseAuth.instance.currentUser!.emailVerified == true) {
      print("user is logged in");
      return HomeScreen();
    } else {
      print("user is not logged in");
      return AuthScreen();
    }
  }
}
