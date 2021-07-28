import 'package:drone_assist/src/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  AppUser _user = AppUser();

  AppUser get getUser {
    return _user;
  }

  set setUser(AppUser user) {
    _user = user;
    notifyListeners();
  }
}
