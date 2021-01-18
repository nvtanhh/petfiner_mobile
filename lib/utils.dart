import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/Address.dart';
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
    return _currentAddress
        .substring(0, _currentAddress.lastIndexOf(','))
        .trim();
  } catch (e) {
    print(e);
    return '';
  }
}

Future<String> getAdress(Address address) async {
  if (address == null) return '';

  List<String> spliter = address.addressName.split(';');
  if (spliter.length == 1) return spliter[0];
  double lat = double.parse(spliter[0]);
  double long = double.parse(spliter[1]);
  String addressName;
  if (spliter.length == 3) {
    addressName = spliter[2];
  } else
    addressName = await getAddressFromLatLng(lat, long);

  address.lat = lat;
  address.long = long;
  address.addressName = addressName;

  return addressName;
}

Future<bool> likePost(int postId) async {
  String token = await getStringValue('token');
  Dio dio = new Dio();
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers["authorization"] = "Bearer $token";
  Response response =
      await dio.post(Apis.likePost.replaceAll('{id}', postId.toString()));
  print('likePost' + response.statusCode.toString());
  return response.statusCode == 200;
}

Future<bool> likePet(int petId) async {
  String token = await getStringValue('token');
  Dio dio = new Dio();
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers["authorization"] = "Bearer $token";
  Response response =
      await dio.post(Apis.likePet.replaceAll('{id}', petId.toString()));
  return response.statusCode == 200;
}
