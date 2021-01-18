import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getDaysAgo(String birhdayStr) {
  //the birthday's date
  final birthday = DateTime.parse(birhdayStr);
  final date2 = DateTime.now();
  return date2.difference(birthday).inDays.toString();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

showError(String s) {
  EasyLoading.dismiss();
  EasyLoading.showError(s, duration: Duration(milliseconds: 750));
}

showToast(String s) {
  EasyLoading.dismiss();
  EasyLoading.showToast(s);
}

showSuccess(String s) {
  EasyLoading.dismiss();
  EasyLoading.showSuccess(s);
}

bool isEmail(String email) {
  RegExp regExp = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return regExp.hasMatch(email);
}

Future<String> getStringValue(String key) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString(key);
}

Future<void> setStringValue(String key, String value) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(key, value);
}

Future<String> getAddressFromLatLng(double latitude, double longitude) async {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  try {
    List<Placemark> p =
        await geolocator.placemarkFromCoordinates(latitude, longitude);

    Placemark place = p[0];
    String subLocality =
        place.subLocality.isNotEmpty ? place.subLocality + ', ' : '';
    String locality = place.locality.isNotEmpty ? place.locality + ', ' : '';
    String administrativeArea = place.administrativeArea.isNotEmpty
        ? place.administrativeArea + ', '
        : '';
    // String country = place.country.isNotEmpty ? place.country + ', ' : '';

    String _currentAddress = subLocality + locality + administrativeArea;
    return _currentAddress.substring(0, _currentAddress.lastIndexOf(','));
  } catch (e) {
    print(e);
    return '';
  }
}

Future<String> getAdress(String position) async {
  if (position == null) return '';
  List<String> spliter = position.split(';');
  double lat = double.parse(spliter[0]);
  double long = double.parse(spliter[1]);
  String address;
  if (spliter.length == 3) {
    address = spliter[2];
  }
  if (address == null) {
    address = await getAddressFromLatLng(lat, long);
  }
  return address;
}
