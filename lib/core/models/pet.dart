import 'dart:convert';

import 'package:pet_finder/core/models/Address.dart';
import 'package:pet_finder/core/models/user.dart';

enum PetCategory { CAT, DOG, OTHER, HAMSTER }

class Pet {
  int id;
  String name;
  String bio;
  String gender;
  DateTime birhday;
  Address address;
  String distance;
  PetCategory category;
  String avatar;
  bool isFollowed;
  bool newest;
  String breed;
  String color;
  double weight;
  int age;
  User owner;

  Pet(
      {this.id,
      this.name,
      this.bio,
      this.breed,
      this.gender,
      this.birhday,
      this.address,
      this.distance,
      this.category,
      this.avatar,
      this.isFollowed,
      this.newest,
      this.color,
      this.weight});

  Pet.fromJson(Map<String, dynamic> json)
      : name = json['Name'],
        id = json['Id'],
        bio = json['Bio'],
        gender = json['Gender'] == 1 ? 'Male' : 'Female',
        address = Address.fromStringAddress(json['Address']),
        category = getPetCategory(json['Category']['Id'] as int),
        isFollowed = json['IsFollowed'],
        avatar = json['Avatar'],
        breed = json['Breed'],
        color = json['Color'],
        weight = json['Weight'] != null ? double.parse(json['Weight']) : null,
        age = json['Age'] + 1,
        owner = User.fromJson(json['Owner']);

  Map<String, dynamic> toJson() {
    return {
      'Id': id.toString(),
      'Name': name,
      'Bio': bio,
      'Gender': gender,
      'Birthday': birhday?.toIso8601String(),
      'Address': address.toJson(),
      'Category': {'Id': categoryToId(category)},
      'Avatar': avatar,
      'Breed': breed,
      'Color': color,
      'Weight': weight,
      'Owner': owner?.toJson()
    };
  }

  static PetCategory getPetCategory(int category) {
    switch (category) {
      case 1:
        return PetCategory.DOG;
        break;
      case 2:
        return PetCategory.CAT;
        break;
      case 3:
        return PetCategory.HAMSTER;
        break;
      case 4:
        return PetCategory.OTHER;
        break;
      default:
        return PetCategory.OTHER;
    }
  }

  int categoryToId(PetCategory category) {
    switch (category) {
      case PetCategory.DOG:
        return 1;
        break;
      case PetCategory.CAT:
        return 2;
        break;
      case PetCategory.OTHER:
        return 4;
        break;
      case PetCategory.HAMSTER:
        return 3;
        break;
    }
    return 4;
  }

  Map<String, dynamic> toIdJson() {
    return {'id': id.toString()};
  }
}

// List<Pet> getPetList() {
//   Address defaultAddress = new Address('California', 20.954992, 107.099514);
//   return <Pet>[
//     Pet(
//         "Abyssinian Cats",
//         "Just a pet's bio",
//         "Alaska",
//         "female",
//         "2020-07-19",
//         defaultAddress,
//         "2.5",
//         PetCategory.CAT,
//         "assets/images/cats/cat_1.jpg",
//         true,
//         true),
//     Pet(
//         "Scottish Fold",
//         "Just a pet's bio",
//         "Alaska",
//         "male",
//         "2020-07-19",
//         defaultAddress,
//         "1.2",
//         PetCategory.CAT,
//         "assets/images/cats/cat_2.jpg",
//         false,
//         true),
//     Pet(
//         "Ragdoll",
//         "Just a pet's bio",
//         "Alaska",
//         "male",
//         "2020-07-19",
//         defaultAddress,
//         "1.2",
//         PetCategory.CAT,
//         "assets/images/cats/cat_3.jpg",
//         false,
//         true),
//     Pet(
//         "Burmés",
//         "Just a pet's bio",
//         "Alaska",
//         "male",
//         "2020-07-19",
//         defaultAddress,
//         "1.2",
//         PetCategory.CAT,
//         "assets/images/cats/cat_4.jpg",
//         true,
//         true),
//     Pet(
//         "American Shorthair",
//         "Just a pet's bio",
//         "Alaska",
//         "male",
//         "2020-07-19",
//         defaultAddress,
//         "1.2",
//         PetCategory.CAT,
//         "assets/images/cats/cat_5.jpg",
//         false,
//         true),
//     Pet(
//         "British Shorthair",
//         "Just a pet's bio",
//         "Alaska",
//         "male",
//         "2020-07-19",
//         defaultAddress,
//         "1.9",
//         PetCategory.CAT,
//         "assets/images/cats/cat_6.jpg",
//         false,
//         true),
//     Pet(
//         "Abyssinian Cats",
//         "Just a pet's bio",
//         "Alaska",
//         "male",
//         "2020-07-19",
//         defaultAddress,
//         "2.5",
//         PetCategory.CAT,
//         "assets/images/cats/cat_7.jpg",
//         false,
//         true),
//     Pet(
//         "Scottish Fold",
//         "Just a pet's bio",
//         "Alaska",
//         "male",
//         "2020-07-19",
//         defaultAddress,
//         "1.2",
//         PetCategory.CAT,
//         "assets/images/cats/cat_8.jpg",
//         false,
//         true),
// Pet("Ragdoll", "Alaska", "male", "2020-07-19", "Miami", "1.2", Category.CAT,
//     "assets/images/cats/cat_9.jpg", true, true),
// Pet("Roborowski", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.HAMSTER, "assets/images/hamsters/hamster_1.jpg", true, true),
// Pet("Ruso", "Alaska", "male", "2020-07-19", "New Jersey", "2.5",
//     Category.HAMSTER, "assets/images/hamsters/hamster_2.jpg", false, true),
// Pet("Golden", "Alaska", "male", "2020-07-19", "Miami", "2.5",
//     Category.HAMSTER, "assets/images/hamsters/hamster_3.jpg", false, true),
// Pet("Chinese", "Alaska", "male", "2020-07-19", "Chicago", "2.5",
//     Category.HAMSTER, "assets/images/hamsters/hamster_4.jpg", true, true),
// Pet("Dwarf Campbell", "Alaska", "male", "2020-07-19", "New York", "2.5",
//     Category.HAMSTER, "assets/images/hamsters/hamster_5.jpg", false, true),
// Pet("Syrian", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.HAMSTER, "assets/images/hamsters/hamster_6.jpg", false, true),
// Pet("Dwarf Winter", "Alaska", "male", "2020-07-19", "Miami", "2.5",
//     Category.HAMSTER, "assets/images/hamsters/hamster_7.jpg", false, true),
// Pet("American Rabbit", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.OTHER, "assets/images/bunnies/bunny_1.jpg", true, true),
// Pet(
//     "Belgian Hare Rabbit",
//     "Alaska",
//     "male",
//     "2020-07-19",
//     "New Jersey",
//     "2.5",
//     Category.OTHER,
//     "assets/images/bunnies/bunny_2.jpg",
//     false,
//     true),
// Pet("Blanc de Hotot", "Alaska", "male", "2020-07-19", "Miami", "2.5",
//     Category.OTHER, "assets/images/bunnies/bunny_3.jpg", false, true),
// Pet("Californian Rabbits", "Alaska", "male", "2020-07-19", "Chicago", "2.5",
//     Category.OTHER, "assets/images/bunnies/bunny_4.jpg", true, true),
// Pet(
//     "Checkered Giant Rabbit",
//     "Alaska",
//     "male",
//     "2020-07-19",
//     "New York",
//     "2.5",
//     Category.OTHER,
//     "assets/images/bunnies/bunny_5.jpg",
//     false,
//     true),
// Pet("Dutch Rabbit", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.OTHER, "assets/images/bunnies/bunny_6.jpg", false, true),
// Pet("English Lop", "Alaska", "male", "2020-07-19", "Miami", "2.5",
//     Category.OTHER, "assets/images/bunnies/bunny_7.jpg", false, true),
// Pet("English Spot", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.OTHER, "assets/images/bunnies/bunny_8.jpg", true, true),
// Pet("Affenpinscher", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.DOG, "assets/images/dogs/dog_1.jpg", true, true),
// Pet("Akita Shepherd", "Alaska", "male", "2020-07-19", "New Jersey", "2.5",
//     Category.DOG, "assets/images/dogs/dog_2.jpg", false, true),
// Pet("American Foxhound", "Alaska", "male", "2020-07-19", "Miami", "2.5",
//     Category.DOG, "assets/images/dogs/dog_3.jpg", false, true),
// Pet("Shepherd Dog", "Alaska", "male", "2020-07-19", "Chicago", "2.5",
//     Category.DOG, "assets/images/dogs/dog_4.jpg", true, true),
// Pet("Australian Terrier", "Alaska", "male", "2020-07-19", "New York", "2.5",
//     Category.DOG, "assets/images/dogs/dog_5.jpg", false, true),
// Pet("Bearded Collie", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.DOG, "assets/images/dogs/dog_6.jpg", false, true),
// Pet("Belgian Sheepdog", "Alaska", "male", "2020-07-19", "Miami", "2.5",
//     Category.DOG, "assets/images/dogs/dog_7.jpg", false, true),
// Pet("Bloodhound", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.DOG, "assets/images/dogs/dog_8.jpg", true, true),
// Pet("Boston Terrier", "Alaska", "male", "2020-07-19", "California", "2.5",
//     Category.DOG, "assets/images/dogs/dog_9.jpg", true, true),
// Pet("Chinese Shar-Pei", "Alaska", "male", "2020-07-19", "New Jersey", "2.5",
//     Category.DOG, "assets/images/dogs/dog_10.jpg", false, true),
// Pet("Border Collie", "Alaska", "male", "2020-07-19", "Miami", "2.5",
//     Category.DOG, "assets/images/dogs/dog_11.jpg", false, true),
// Pet("Chow Chow", "Alaska", "male", "2020-07-19", "Chicago", "2.5",
//     Category.DOG, "assets/images/dogs/dog_12.jpg", true, true),
//   ];
// }
