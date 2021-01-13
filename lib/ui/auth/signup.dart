import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/ui/auth/login.dart';
import 'package:pet_finder/ui/auth/widgets/already_have_an_account_acheck.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_button.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_input_field.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_password_field.dart';
import 'package:pet_finder/utils.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _name;
  String _password;
  String _rePassword;

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
                    "SIGNUP",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset(
                  "assets/images/logo.png",
                  // height: size.height * 0.3,
                  width: size.height * 0.25,
                ),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                  validator: (val) {
                    if (val.length == 0)
                      return "Please enter email";
                    else if (!isEmail(val))
                      return "Please enter valid email";
                    else
                      return null;
                  },
                  // autofocus: true,
                  hintText: "Your Email",
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                RoundedInputField(
                  validator: (val) {
                    if (val.length == 0) return "Please enter name";
                  },
                  // autofocus: true,
                  hintText: "Username",
                  onChanged: (value) {
                    _name = value;
                  },
                ),
                RoundedPasswordField(
                  validator: (val) {
                    if (val.length == 0) return "Please enter password";
                    if (val.length < 6)
                      return "Password must at least 6 characters";
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: "Retype password",
                  validator: (val) {
                    if (val.length == 0) return "Please enter password";
                    if (val != _rePassword) return "Password not match";
                  },
                  onChanged: (value) {
                    _rePassword = value;
                  },
                ),
                RoundedButton(
                  text: "SIGNUP",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      _signUp();
                    }
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signUp() async {
    EasyLoading.show(status: 'Loading...');

    if (_email.isNotEmpty && _password.isNotEmpty) {
      try {
        http.Response response = await http
            .post(
              Apis.getSignUpUrl,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'Email': _email,
                'UserName': _name,
                'Password': _password
              }),
            )
            .timeout(Duration(seconds: 10));
        print(response.body.toString());
        if (response.statusCode == 200) {
          var data = response.body;
          print(data);

          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => LoginScreen(initEmail: _email)));
        }
        if (response.statusCode == 409) {
          showToast("Email is already exists!");
        }
      } on TimeoutException catch (e) {
        showError(e.toString());
      } on SocketException catch (e) {
        showError(e.toString());
      }
    } else {
      showToast("Please fill your email and password first.");
    }
  }
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
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            // c
            child: Container(),
          ),
          child,
        ],
      ),
    );
  }
}
