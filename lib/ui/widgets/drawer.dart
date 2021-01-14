import 'package:flutter/material.dart';
import 'package:pet_finder/ui/auth/change_pass.dart';
import 'package:pet_finder/ui/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.75,
      child: Drawer(
          child: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 5),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => _closeEndDrawer(context),
                padding: EdgeInsets.only(right: 5),
              ),
              Text(
                'Setting',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Change password'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChangePassword()));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            _showLogoutDialog(context);
          },
        ),
      ])),
    );
  }

  void _closeEndDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }

  _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: Text(
            "Are you sure to logout?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black54),
          ),
          actions: <Widget>[
            ButtonTheme(
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                color: Colors.grey[400],
                textColor: const Color(0xffffffff),
              ),
            ),
            ButtonTheme(
              //minWidth: double.infinity,
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout(context);
                },
                child: Text('Logout'),
                color: Theme.of(context).primaryColor,
                textColor: const Color(0xffffffff),
              ),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    _removeToken();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }

  void _removeToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('token');
  }
}
