import 'package:pet_finder/core/models/posts_list.dart';
import 'package:pet_finder/core/models/pets_list.dart';

class User {
  int id;
  String name, email, bio, phone, avatar;

  PetsList petList;

  PostsList postList;
  User(this.id, this.name, this.bio, this.phone, this.avatar, this.petList,
      this.postList);

  @override
  String toString() {
    return 'name: $name, avatar: $avatar';
  }

  User.empty() {
    this.id = -1;
    this.name = 'Empty User';
    this.email = '';
    this.bio = '';
    this.phone = '';
    this.avatar = 'assets/images/sample/avt.jpg';
    this.petList = new PetsList();
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'UserName': name,
      'Avatar': avatar,
      'Bio': bio,
      'Phone': phone,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        email = json['Email'],
        bio = json['Bio'],
        name = json['UserName'],
        phone = json['Phone'],
        avatar = json['Avatar'];
}
