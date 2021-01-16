class MyLocation {
  double lat, long;
  bool haveData = false;

  static MyLocation _instance;

  MyLocation._internal();

  factory MyLocation() {
    if (_instance == null) _instance = MyLocation._internal();
    return _instance;
  }

  resetLocation(double latitude, double longtitude) {
    haveData = true;
    lat = latitude;
    long = longtitude;
  }
}
