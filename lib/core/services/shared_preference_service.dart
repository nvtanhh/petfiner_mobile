import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferences _prefs;

  static Future<bool> getSharedPreferencesInstance() async {
    _prefs = await SharedPreferences.getInstance().catchError((e) {
      print("shared prefrences error : $e");
      return false;
    });
    return true;
  }

  static Future setToken(String token) async {
    await _prefs.setString('token', token);
  }

  static Future clearToken() async {
    await _prefs.remove('token');
  }

  static Future<String> get token async => _prefs.getString('token');
}
