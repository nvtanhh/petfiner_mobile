import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/ui/auth/forgot_pass.dart';
import 'package:pet_finder/ui/auth/signup.dart';
import 'package:pet_finder/ui/auth/widgets/already_have_an_account_acheck.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_button.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_input_field.dart';
import 'package:pet_finder/ui/auth/widgets/rounded_password_field.dart';
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:http/http.dart' as http;
import 'package:pet_finder/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imei_plugin/imei_plugin.dart';

class LoginScreen extends StatefulWidget {
  final String initEmail;

  final String mess;

  const LoginScreen({
    Key key,
    this.initEmail,
    this.mess,
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
    if (widget.mess != null) showToast(widget.mess);
    _email = widget.initEmail ?? '';
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
                  validator: (val) {
                    if (val.length == 0) return "Please enter password";
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                Container(
                  width: size.width * 0.8,
                  padding: EdgeInsets.only(top: 10, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassScreen())),
                          child: Text('Forgot password?')),
                    ],
                  ),
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
      try {
        http.Response response = await http
            .post(
              Apis.getLoginUrl,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'email': _email.trim(),
                'password': _password.trim()
              }),
            )
            .timeout(Duration(seconds: 10));
        if (response.statusCode == 200) {
          var token = jsonDecode(response.body)["token"];
          if (token != null) {
            print("TOKEN: " + token);
            await EasyLoading.dismiss();
            await _saveToken(token);
            await _saveFirebaseMassagingToken();

            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => MyNavigator()));
          }
        }
        if (response.statusCode == 404) {
          showToast("Login failed.");
        }
      } on TimeoutException catch (e) {
        showError(e.toString());
      } on SocketException catch (e) {
        showError(e.toString());
        print(e.toString());
      }
    } else {
      showToast("Please fill your email and password first.");
    }
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
  }

  _saveFirebaseMassagingToken() async {
    String imei = await ImeiPlugin.getImei();
    String token = await getStringValue('token');
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer $token";
    String messagingToken = await getStringValue('firebase_messaging_token');
    final data = {'serial': imei, 'newToken': messagingToken};
    print(data);
    Response response =
        await dio.post(Apis.saveFirebaseMassagingToken, data: data);
    print('_saveFirebaseMassagingToken' + response.statusCode.toString());
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
