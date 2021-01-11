import 'package:flutter_easyloading/flutter_easyloading.dart';

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
  EasyLoading.showError(s);
}

showToast(String s) {
  EasyLoading.dismiss();
  EasyLoading.showToast(s);
}

bool isEmail(String email) {
  RegExp regExp = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return regExp.hasMatch(email);
}
