import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_button.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_password_field.dart';

import 'package:http/http.dart' as http;
import 'package:pet_finder/utils.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _password;
  String _newPassword;
  String _rePassword;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        automaticallyImplyLeading: true,
        title: Text(
          "Change password",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
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
                    "CHANGE PASSWORD",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                RoundedPasswordField(
                  hintText: 'Current password',
                  validator: (val) {
                    if (val.length == 0) return "Please enter password";
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: "Retype password",
                  validator: (val) {
                    if (val.length == 0) return "Please enter password";
                    if (val.length < 6)
                      return "Password must at least 6 characters";
                  },
                  onChanged: (value) {
                    _newPassword = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: "Retype password",
                  validator: (val) {
                    if (val.length == 0) return "Please enter password";
                    if (val != _newPassword) return "Password not match";
                  },
                  onChanged: (value) {
                    _rePassword = value;
                  },
                ),
                RoundedButton(
                  text: "UPDATE",
                  press: () {
                    if (_formKey.currentState.validate()) {
                      // _signUp();
                      _changePass();
                    }
                  },
                ),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changePass() async {
    EasyLoading.show(status: 'Loading...');

    try {
      http.Response response = await http
          .post(Apis.getSignUpUrl,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'oldPassword': _password,
                'newPassword': _newPassword,
              }))
          .timeout(Duration(seconds: 10));
      print(response.body.toString());
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        showSuccess('Change password successfully!');
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        showToast("Wrong password!");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
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
