enum PetCategory { CAT, DOG, OTHER, HAMSTER }

class Pet {
  String id;
  String name;
  String bio;
  String gender;
  String birhday;
  String location;
  String distance;
  PetCategory category;
  String avatar;
  bool favorite;
  bool newest;
  String breed;
  String color;
  double weight;

  Pet(this.name, this.bio, this.breed, this.gender, this.birhday, this.location,
      this.distance, this.category, this.avatar, this.favorite, this.newest,
      {this.color, this.weight});

  Pet.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        bio = json['bio'],
        gender = json['gender'],
        birhday = json['birhday'],
        location = json['location'],
        category = getPetCategory(json['category'] as String),
        avatar = json['avatar'],
        breed = json['breed'],
        color = json['color'],
        weight = json['weight'];

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'name': name,
      'bio': bio,
      'gender': gender,
      'birhday': birhday,
      'location': location,
      'category': categoryToString(category),
      'avatar': avatar,
      'breed': breed,
      'color': color,
      'weight': weight,
    };
  }

  static PetCategory getPetCategory(String category) {
    switch (category.toLowerCase()) {
      case 'dog':
        return PetCategory.DOG;
        break;
      case 'cat':
        return PetCategory.CAT;
        break;
      case 'hamster':
        return PetCategory.HAMSTER;
        break;
      case 'other':
        return PetCategory.OTHER;
        break;
      default:
        return PetCategory.OTHER;
    }
  }

  String categoryToString(PetCategory category) {
    switch (category) {
      case PetCategory.DOG:
        return 'Dog';
        break;
      case PetCategory.CAT:
        return 'Cat';
        break;
      case PetCategory.OTHER:
        return 'Other';
        break;
      case PetCategory.HAMSTER:
        return 'Hamster';
        break;
    }
    return null;
  }
}

List<Pet> getPetList() {
  return <Pet>[
    Pet(
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
        true),
    Pet(
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
        true),
    Pet("Ragdoll", "Just a pet's bio", "Alaska", "male", "2020-07-19", "Miami",
        "1.2", PetCategory.CAT, "assets/images/cats/cat_3.jpg", false, true),
    Pet("Burmés", "Just a pet's bio", "Alaska", "male", "2020-07-19", "Chicago",
        "1.2", PetCategory.CAT, "assets/images/cats/cat_4.jpg", true, true),
    Pet(
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
        true),
    Pet(
        "British Shorthair",
        "Just a pet's bio",
        "Alaska",
        "male",
        "2020-07-19",
        "New York",
        "1.9",
        PetCategory.CAT,
        "assets/images/cats/cat_6.jpg",
        false,
        true),
    Pet(
        "Abyssinian Cats",
        "Just a pet's bio",
        "Alaska",
        "male",
        "2020-07-19",
        "California",
        "2.5",
        PetCategory.CAT,
        "assets/images/cats/cat_7.jpg",
        false,
        true),
    Pet(
        "Scottish Fold",
        "Just a pet's bio",
        "Alaska",
        "male",
        "2020-07-19",
        "New Jersey",
        "1.2",
        PetCategory.CAT,
        "assets/images/cats/cat_8.jpg",
        false,
        true),
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
  ];
}
