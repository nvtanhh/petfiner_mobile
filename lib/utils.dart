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
