import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payflow/modules/home/home_page.dart';
import 'package:payflow/modules/login/login_page.dart';
import 'package:payflow/shared/models/home_params.dart';
import 'package:payflow/shared/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  UserModel? _user;

  get user => _user;

  void setUser(BuildContext context, UserModel? user) {
    if (user != null) {
      saveUser(user);
      _user = user;
      Navigator.pushReplacementNamed(
        context,
        HomePage.routeName,
        arguments: HomeParams(user: user, authController: this),
      );
    } else {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
  }

  Future<void> saveUser(UserModel user) async {
    final instance = await SharedPreferences.getInstance();

    await instance.setString("user", user.toJson());
  }

  Future<void> currentUser(BuildContext context) async {
    final instance = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 3));
    if (instance.containsKey("user")) {
      final userJson = instance.get("user") as String;
      setUser(context, UserModel.fromJson(userJson));
    } else {
      setUser(context, null);
    }
  }

  void logout(BuildContext context) {
    setUser(context, null);
  }
}
