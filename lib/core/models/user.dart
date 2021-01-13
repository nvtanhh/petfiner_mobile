import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/users_list.dart';

class User {
  String id, name, email, bio, phoneNumber, avatar;

  PetsList petList;
  User(this.id, this.name, this.bio, this.phoneNumber, this.avatar,
      this.petList);

  User.empty() {
    this.id = '';
    this.name = 'Empty User';
    this.email = '';
    this.bio = '';
    this.phoneNumber = '';
    this.avatar = 'assets/images/sample/avt.jpg';
    this.petList = new PetsList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'bio': bio,
        'phone_number': phoneNumber,
        'avatar': avatar,
        'pets': petList?.pets?.map((Pet pet) => pet.toJson())?.toList()
      };
}
