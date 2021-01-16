class Address {
  String address;
  double lat, long;

  Address(this.address, this.lat, this.long);

  Address.fromJSON(Map<String, dynamic> json) {
    address = json["Address"];
    lat = json['Lat'];
    long = json['Long'];
  }
}
