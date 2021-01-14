import 'package:pet_finder/core/models/pet.dart';

class PetsList {
  List<Pet> pets;

  PetsList({this.pets});

  factory PetsList.fromJson(List<dynamic> parsedJson) {
    List<Pet> pets =
        parsedJson.map((circleJson) => Pet.fromJson(circleJson)).toList();

    return new PetsList(pets: pets);
  }
}
