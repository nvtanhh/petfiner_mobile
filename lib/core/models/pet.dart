enum Category { CAT, DOG, OTHER, HAMSTER }

class Pet {
  String name;
  String location;
  String distance;
  Category category;
  String defaultImageUrl;
  bool favorite;
  bool newest;

  Pet(this.name, this.location, this.distance, this.category,
      this.defaultImageUrl, this.favorite, this.newest);
}

List<Pet> getPetList() {
  return <Pet>[
    Pet("Abyssinian Cats", "California", "2.5", Category.CAT,
        "assets/images/cats/cat_1.jpg", true, true),
    Pet("Scottish Fold", "New Jersey", "1.2", Category.CAT,
        "assets/images/cats/cat_2.jpg", false, true),
    Pet("Ragdoll", "Miami", "1.2", Category.CAT, "assets/images/cats/cat_3.jpg",
        false, true),
    Pet("Burmés", "Chicago", "1.2", Category.CAT,
        "assets/images/cats/cat_4.jpg", true, true),
    Pet("American Shorthair", "Washintong", "1.2", Category.CAT,
        "assets/images/cats/cat_5.jpg", false, true),
    Pet("British Shorthair", "New York", "1.9", Category.CAT,
        "assets/images/cats/cat_6.jpg", false, true),
    Pet("Abyssinian Cats", "California", "2.5", Category.CAT,
        "assets/images/cats/cat_7.jpg", false, true),
    Pet("Scottish Fold", "New Jersey", "1.2", Category.CAT,
        "assets/images/cats/cat_8.jpg", false, true),
    Pet("Ragdoll", "Miami", "1.2", Category.CAT, "assets/images/cats/cat_9.jpg",
        true, true),
    Pet("Roborowski", "California", "2.5", Category.HAMSTER,
        "assets/images/hamsters/hamster_1.jpg", true, true),
    Pet("Ruso", "New Jersey", "2.5", Category.HAMSTER,
        "assets/images/hamsters/hamster_2.jpg", false, true),
    Pet("Golden", "Miami", "2.5", Category.HAMSTER,
        "assets/images/hamsters/hamster_3.jpg", false, true),
    Pet("Chinese", "Chicago", "2.5", Category.HAMSTER,
        "assets/images/hamsters/hamster_4.jpg", true, true),
    Pet("Dwarf Campbell", "New York", "2.5", Category.HAMSTER,
        "assets/images/hamsters/hamster_5.jpg", false, true),
    Pet("Syrian", "California", "2.5", Category.HAMSTER,
        "assets/images/hamsters/hamster_6.jpg", false, true),
    Pet("Dwarf Winter", "Miami", "2.5", Category.HAMSTER,
        "assets/images/hamsters/hamster_7.jpg", false, true),
    Pet("American Rabbit", "California", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_1.jpg", true, true),
    Pet("Belgian Hare Rabbit", "New Jersey", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_2.jpg", false, true),
    Pet("Blanc de Hotot", "Miami", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_3.jpg", false, true),
    Pet("Californian Rabbits", "Chicago", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_4.jpg", true, true),
    Pet("Checkered Giant Rabbit", "New York", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_5.jpg", false, true),
    Pet("Dutch Rabbit", "California", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_6.jpg", false, true),
    Pet("English Lop", "Miami", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_7.jpg", false, true),
    Pet("English Spot", "California", "2.5", Category.OTHER,
        "assets/images/bunnies/bunny_8.jpg", true, true),
    Pet("Affenpinscher", "California", "2.5", Category.DOG,
        "assets/images/dogs/dog_1.jpg", true, true),
    Pet("Akita Shepherd", "New Jersey", "2.5", Category.DOG,
        "assets/images/dogs/dog_2.jpg", false, true),
    Pet("American Foxhound", "Miami", "2.5", Category.DOG,
        "assets/images/dogs/dog_3.jpg", false, true),
    Pet("Shepherd Dog", "Chicago", "2.5", Category.DOG,
        "assets/images/dogs/dog_4.jpg", true, true),
    Pet("Australian Terrier", "New York", "2.5", Category.DOG,
        "assets/images/dogs/dog_5.jpg", false, true),
    Pet("Bearded Collie", "California", "2.5", Category.DOG,
        "assets/images/dogs/dog_6.jpg", false, true),
    Pet("Belgian Sheepdog", "Miami", "2.5", Category.DOG,
        "assets/images/dogs/dog_7.jpg", false, true),
    Pet("Bloodhound", "California", "2.5", Category.DOG,
        "assets/images/dogs/dog_8.jpg", true, true),
    Pet("Boston Terrier", "California", "2.5", Category.DOG,
        "assets/images/dogs/dog_9.jpg", true, true),
    Pet("Chinese Shar-Pei", "New Jersey", "2.5", Category.DOG,
        "assets/images/dogs/dog_10.jpg", false, true),
    Pet("Border Collie", "Miami", "2.5", Category.DOG,
        "assets/images/dogs/dog_11.jpg", false, true),
    Pet("Chow Chow", "Chicago", "2.5", Category.DOG,
        "assets/images/dogs/dog_12.jpg", true, true),
  ];
}
