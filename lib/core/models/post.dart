import 'package:pet_finder/core/models/pet.dart';
import 'package:flutter/material.dart';

enum Condition { Adoption, Disappear, Mating }

class Post {
  int like, comment;
  Pet pet;
  Condition condition;
  List<String> imageUrls;
  Post(
      {@required this.pet,
      @required this.imageUrls,
      @required this.condition,
      this.like,
      this.comment});

  String conditionText() {
    switch (this.condition) {
      case Condition.Adoption:
        return "Adoption";
      case Condition.Mating:
        return "Mating";
      case Condition.Disappear:
        return "Disappear";
    }
    return "";
  }
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
      Category.CAT,
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
      Category.CAT,
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
      Category.CAT,
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
      Category.CAT,
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
      Category.CAT,
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
        condition: Condition.Adoption),
    Post(
        pet: p2,
        imageUrls: [
          'assets/images/cats/cat_7.jpg',
          'assets/images/cats/cat_8.jpg',
          'assets/images/cats/cat_9.jpg'
        ],
        condition: Condition.Disappear),
    Post(
        pet: p3,
        imageUrls: [
          'assets/images/hamsters/hamster_1.jpg',
          'assets/images/hamsters/hamster_2.jpg',
          'assets/images/hamsters/hamster_3.jpg'
        ],
        condition: Condition.Mating),
    Post(
        pet: p4,
        imageUrls: [
          'assets/images/bunnies/bunny_1.jpg',
          'assets/images/bunnies/bunny_2.jpg',
          'assets/images/bunnies/bunny_3.jpg'
        ],
        condition: Condition.Adoption),
    Post(
        pet: p5,
        imageUrls: [
          'assets/images/dogs/dog_1.jpg',
          'assets/images/cats/dog_1.jpg',
          'assets/images/cats/dog_1.jpg'
        ],
        condition: Condition.Disappear),
  ];
}
