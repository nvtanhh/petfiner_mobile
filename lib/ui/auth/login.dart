import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/ui/auth/signup.dart';
import 'package:pet_finder/ui/auth/widgets/already_have_an_account_acheck.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_button.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_input_field.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_password_field.dart';
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  final String initEmail;

  const LoginScreen({
    Key key,
    this.initEmail = '',
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _email = widget.initEmail;
    _password = '';
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
                    "LOGIN",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset(
                  "assets/images/logo.png",
                  // height: size.height * 0.3,
                  height: size.height * 0.25,
                ),
                SizedBox(height: size.height * 0.05),
                RoundedInputField(
                  initValue: _email,
                  hintText: "Your Email",
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                RoundedPasswordField(
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  press: () async {
                    if (_formKey.currentState.validate()) {
                      _login();
                    }
                  },
                ),
                // OrDivider(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     SocalIcon(
                //       iconSrc: "assets/images/ic_facebook.svg",
                //       bgColor: Color(0xFF4267B2),
                //       press: _loginFacebook,
                //     ),
                //     SocalIcon(
                //       iconSrc: "assets/images/ic_google_plus.svg",
                //       press: _loginGoogle,
                //       bgColor: Color(0xFFDB4A39),
                //     ),
                //   ],
                // ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    EasyLoading.show(status: 'Loading...');

    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await http.post(
        Apis.getLoginUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'email': _email, 'password': _password}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var token = response.body;
        if (token != null) {
          await EasyLoading.dismiss();
          print("TOKEN: " + token);
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                builder: (context) => MyNavigator(),
              ));
        } else {
          await EasyLoading.dismiss();
          EasyLoading.showToast("Login failed.");
        }
      } else if (response.statusCode == 200) {
        await EasyLoading.dismiss();
        EasyLoading.showError('Error');
      } else {}
    } else {
      await EasyLoading.dismiss();
      EasyLoading.showToast("Please fill your email and password first.");
    }

    //   dynamic result = await Apis.login(_email, _password);
    //   if (result != null) {
    //     await EasyLoading.dismiss();
    //     print("user token " + result);
    //     // navigateToHome(context);
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => MyNavigator()));
    //   } else {
    //     await EasyLoading.dismiss();
    //     EasyLoading.showToast(result);
    //   }
    // } else {
    //   EasyLoading.showToast("Email hoặc mật khẩu trống");
    // }
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
