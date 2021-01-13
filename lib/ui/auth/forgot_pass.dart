import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/ui/auth/login.dart';
import 'package:pet_finder/ui/auth/signup.dart';
import 'package:pet_finder/ui/auth/widgets/already_have_an_account_acheck.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_button.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_input_field.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_password_field.dart';
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:http/http.dart' as http;
import 'package:pet_finder/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({
    Key key,
  }) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _email = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width * 0.8,
                  alignment: Alignment.center,
                  child: Text(
                    "FORGOT PASSWORD",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset(
                  "assets/images/logo.png",
                  height: size.height * 0.2,
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8,
                  padding: EdgeInsets.only(bottom: 15),
                  child: GestureDetector(
                      child: Text(
                    'Input your email to request a new password.',
                    style: Theme.of(context).textTheme.subtitle1,
                  )),
                ),
                RoundedInputField(
                  initValue: _email,
                  hintText: "Your Email",
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                RoundedButton(
                  text: "SUBMIT",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      // _login();
                      _requestNewPassword();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _login() async {
  //   EasyLoading.show(status: 'Loading...');
  //   print('login url :' + Apis.getLoginUrl);
  //   if (_email.isNotEmpty && _password.isNotEmpty) {
  //     try {
  //       http.Response response = await http
  //           .post(
  //             Apis.getLoginUrl,
  //             headers: <String, String>{
  //               'Content-Type': 'application/json; charset=UTF-8',
  //             },
  //             body: jsonEncode(<String, String>{
  //               'email': _email.trim(),
  //               'password': _password.trim()
  //             }),
  //           )
  //           .timeout(Duration(seconds: 10));
  //       if (response.statusCode == 200) {
  //         var token = jsonDecode(response.body)["token"];
  //         if (token != null) {
  //           print("TOKEN: " + token);
  //           await EasyLoading.dismiss();
  //           _saveToken(token);
  //           Navigator.pushReplacement(
  //               context,
  //               new MaterialPageRoute(
  //                 builder: (context) => MyNavigator(),
  //               ));
  //         }
  //       }
  //       if (response.statusCode == 404) {
  //         showToast("Login failed.");
  //       }
  //     } on TimeoutException catch (e) {
  //       showError(e.toString());
  //     } on SocketException catch (e) {
  //       showError(e.toString());
  //       print(e.toString());
  //     }
  //   } else {
  //     showToast("Please fill your email and password first.");
  //   }
  // }

  void _requestNewPassword() async {
    EasyLoading.show(status: 'Loading...');
    if (_email.isNotEmpty) {
      try {
        http.Response response = await http
            .post(Apis.forgotPassUrl,
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  'email': _email.trim(),
                }))
            .timeout(
              Duration(seconds: 10),
            );
        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                builder: (context) => LoginScreen(initEmail: _email),
              ));
        }
        if (response.statusCode == 404) {
          showToast("Email doesn't exist!");
        }
      } on TimeoutException catch (e) {
        showError(e.toString());
      } on SocketException catch (e) {
        showError(e.toString());
        print(e.toString());
      }
    } else {
      showToast("Please fill your email first.");
    }
  }
}

void navigateToHome(BuildContext context) {
  // Route route = MaterialPageRoute(builder: (context) => MainNavigator());
  // Navigator.pushReplacement(context, route);
}

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 0,
            // child: Image.asset(
            //   "assets/images/login_bottom.png",
            //   width: size.width * 0.4,
            // ),
            child: Container(),
          ),
          child,
        ],
      ),
    );
  }
}
