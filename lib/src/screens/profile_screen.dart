import 'package:drone_assist/src/models/user_model.dart';
import 'package:drone_assist/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUser appUser = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(appUser.name),
        ),
      ),
    );
  }
}
