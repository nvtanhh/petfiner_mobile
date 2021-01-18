import 'package:pet_finder/utils.dart';

class Address {
  String address;
  double lat, long;

  Address(this.address, this.lat, this.long);

  Address.fromJSON(Map<String, dynamic> json) {
    address = json["Address"];
    lat = json['Lat'];
    long = json['Long'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Address': lat.toString() + ';' + long.toString() + ';' + address,
    };
  }
}
