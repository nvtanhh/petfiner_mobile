import 'package:flutter/material.dart';
import 'package:pet_finder/core/services/shared_preference_service.dart';
import 'package:pet_finder/ui/auth/login.dart';
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data ? MyNavigator() : LoginScreen();
        } else {
          return Container();
        }
      },
    );
  }
}

Future<bool> checkLogin() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String token = _prefs.getString('token') ?? '';
  return token.isNotEmpty;
}
