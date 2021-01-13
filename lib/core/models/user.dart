import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/core/models/posts_list.dart';
import 'package:pet_finder/core/models/pets_list.dart';

class User {
  String id, name, email, bio, phoneNumber, avatar;

  PetsList petList;

  PostsList postList;
  User(this.id, this.name, this.bio, this.phoneNumber, this.avatar,
      this.petList, this.postList);

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
        'pets': petList?.pets?.map((Pet pet) => pet.toJson())?.toList(),
        'posts': postList?.posts?.map((Post post) => post.toJson())?.toList()
      };

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        avatar = json['avatar'];
}
