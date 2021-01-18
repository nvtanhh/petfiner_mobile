class Address {
  String addressName;
  double lat, long;

  Address(this.addressName, this.lat, this.long);

  Address.fromJSON(Map<String, dynamic> json) {
    addressName = json["Address"];
    lat = json['Lat'];
    long = json['Long'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Address': lat.toString() + ';' + long.toString() + ';' + addressName,
    };
  }

  static Address fromStringAddress(Map<String, dynamic> address) {
    List<String> spliter = address['Address'].split(';');
    double lat = double.parse(spliter[0]);
    double long = double.parse(spliter[1]);
    String addressName;
    if (spliter.length == 3) {
      addressName = spliter[2];
    }
    return Address(addressName ?? address['Address'], lat, long);
  }
}
