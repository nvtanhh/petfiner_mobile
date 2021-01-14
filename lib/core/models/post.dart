import 'package:pet_finder/core/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/images_list.dart';

import 'Address.dart';

enum PostCategory { Adoption, Disappear, Mating }

class Post {
  int id;
  String content;
  Pet pet;
  PostCategory postCategory;
  List<String> imageUrls;
  bool isFavorite;
  double distance;

  Post({
    this.id,
    @required this.pet,
    @required this.imageUrls,
    @required this.postCategory,
    @required this.content,
    @required this.isFavorite,
    this.distance = 0.0,
  });

  String conditionText() {
    switch (this.postCategory) {
      case PostCategory.Adoption:
        return "Adoption";
        break;
      case PostCategory.Mating:
        return "Mating";
        break;
      case PostCategory.Disappear:
        return "Disappear";
        break;
    }
    return "";
  }

  Post.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        pet = Pet.fromJson(json['Pet']),
        content = json['Content'],
        postCategory = getPostCategory(json['Category']['Id'] as int),
        imageUrls = ImagesList.fromJson(json['Images']).images,
        isFavorite = json['IsFavorite'],
        distance = json['DistanceFromUser'].toDouble();

  toJson() {}

  static PostCategory getPostCategory(int id) {
    switch (id) {
      case 1:
        return PostCategory.Adoption;
        break;
      case 2:
        return PostCategory.Mating;
        break;
      case 3:
        return PostCategory.Disappear;
        break;
      default:
        return PostCategory.Adoption;
    }
  }
}

List<Post> getPostList() {
  Address defaultAddress = new Address('California', 20.954992, 107.099514);

  Pet p1 = Pet(
      "Abyssinian Cats",
      "Just a pet's bio",
      "Alaska",
      "female",
      "2020-07-19",
      defaultAddress,
      "2.5",
      PetCategory.CAT,
      "assets/images/cats/cat_1.jpg",
      true,
      true);
  Pet p2 = Pet(
      "Scottish Fold",
      "Just a pet's bio",
      "Alaska",
      "male",
      "2020-07-19",
      defaultAddress,
      "1.2",
      PetCategory.CAT,
      "assets/images/cats/cat_2.jpg",
      false,
      true);
  Pet p3 = Pet(
      "Ragdoll",
      "Just a pet's bio",
      "Alaska",
      "male",
      "2020-07-19",
      defaultAddress,
      "1.2",
      PetCategory.CAT,
      "assets/images/cats/cat_3.jpg",
      false,
      true);
  Pet p4 = Pet(
      "Burmés",
      "Just a pet's bio",
      "Alaska",
      "male",
      "2020-07-19",
      defaultAddress,
      "1.2",
      PetCategory.CAT,
      "assets/images/cats/cat_4.jpg",
      true,
      true);
  Pet p5 = Pet(
      "American Shorthair",
      "Just a pet's bio",
      "Alaska",
      "male",
      "2020-07-19",
      defaultAddress,
      "1.2",
      PetCategory.CAT,
      "assets/images/cats/cat_5.jpg",
      false,
      true);

  return <Post>[
    Post(
        pet: p1,
        imageUrls: [
          'assets/images/cats/cat_1.jpg',
          'assets/images/cats/cat_2.jpg',
          'assets/images/cats/cat_3.jpg'
        ],
        postCategory: PostCategory.Adoption),
    Post(
        pet: p2,
        imageUrls: [
          'assets/images/cats/cat_7.jpg',
          'assets/images/cats/cat_8.jpg',
          'assets/images/cats/cat_9.jpg'
        ],
        postCategory: PostCategory.Disappear),
    Post(
        pet: p3,
        imageUrls: [
          'assets/images/hamsters/hamster_1.jpg',
          'assets/images/hamsters/hamster_2.jpg',
          'assets/images/hamsters/hamster_3.jpg'
        ],
        postCategory: PostCategory.Mating),
    Post(
        pet: p4,
        imageUrls: [
          'assets/images/bunnies/bunny_1.jpg',
          'assets/images/bunnies/bunny_2.jpg',
          'assets/images/bunnies/bunny_3.jpg'
        ],
        postCategory: PostCategory.Adoption),
    Post(
        pet: p5,
        imageUrls: [
          'assets/images/dogs/dog_1.jpg',
          'assets/images/cats/dog_1.jpg',
          'assets/images/cats/dog_1.jpg'
        ],
        postCategory: PostCategory.Disappear),
  ];
}
