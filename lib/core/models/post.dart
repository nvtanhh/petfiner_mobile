import 'package:pet_finder/core/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/user.dart';

enum PostCategory { Adoption, Disappear, Mating }

class Post {
  String id;
  String content;
  Pet pet;
  PostCategory postCategory;
  List<String> imageUrls;
  bool isFavorite;
  User creator;

  Post(
      {this.id,
      @required this.pet,
      @required this.imageUrls,
      @required this.postCategory,
      @required this.content,
      @required this.isFavorite,
      this.creator});

  String conditionText() {
    switch (this.postCategory) {
      case PostCategory.Adoption:
        return "Adoption";
      case PostCategory.Mating:
        return "Mating";
      case PostCategory.Disappear:
        return "Disappear";
    }
    return "";
  }

  Post.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        postCategory = getPostCategory(json['post_category'] as String),
        imageUrls = (json['id'] as List),
        isFavorite = json['is_favorite'] == 'true' ? true : false,
        creator = User.fromJson(json['creator']);

  toJson() {}

  static getPostCategory(String json) {}
}

List<Post> getPostList() {
  Pet p1 = Pet(
      "Abyssinian Cats",
      "Just a pet's bio",
      "Alaska",
      "female",
      "2020-07-19",
      "California",
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
      "New Jersey",
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
      "Miami",
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
      "Chicago",
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
      "Washintong",
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
