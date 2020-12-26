import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/vet.dart';
import 'package:pet_finder/ui/category_list.dart';
import 'package:pet_finder/ui/search_map_page.dart';
import 'package:pet_finder/ui/widgets/pet_widget.dart';

import '../data.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Pet> pets = getPetList();

  List<Vet> vets = [
    new Vet(
        img: "assets/images/vets/vet_0.png",
        name: "Animal Emergency Hospital",
        phone: "(369) 133-8956"),
    new Vet(
        img: "assets/images/vets/vet_1.png",
        name: "Artemis Veterinary Center",
        phone: "(598) 4986-9532"),
    new Vet(
        img: "assets/images/vets/vet_2.png",
        name: "Big Lake Vet Hospital",
        phone: "(369) 133-8956"),
    new Vet(
        img: "assets/images/vets/vet_3.png",
        name: "Veterinary Medical Center",
        phone: "(33) 8974-559-555"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.only(
                        right: 30,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 16.0, left: 16),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute<void>(builder: (_) => MapSearcher()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green[700],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pet Category",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey[800],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildPetCategory(Category.DOG, "340", Colors.red[200]),
                    buildPetCategory(Category.CAT, "210", Colors.blue[200]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildPetCategory(
                        Category.HAMSTER, "56", Colors.orange[200]),
                    buildPetCategory(Category.OTHER, "90", Colors.green[200]),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vets Near You",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey[800],
                ),
              ],
            ),
          ),
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 16),
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) => buildVet(
                  vets[index].img, vets[index].name, vets[index].phone, index),
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }

  Widget buildPetCategory(Category category, String total, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryList(category: category)),
          );
        },
        child: Container(
          height: 80,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[200],
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.5),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/" +
                        (category == Category.HAMSTER
                            ? "hamster"
                            : category == Category.CAT
                                ? "cat"
                                : category == Category.OTHER
                                    ? "bunny"
                                    : "dog") +
                        ".png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        category == Category.HAMSTER
                            ? "Hamsters"
                            : category == Category.CAT
                                ? "Cats"
                                : category == Category.OTHER
                                    ? "Others"
                                    : "Dogs",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Total: " + total,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildNewestPet() {
    List<Widget> list = [];
    for (var i = 0; i < pets.length; i++) {
      if (pets[i].newest) {
        list.add(PetWidget(pet: pets[i], index: i));
      }
    }
    return list;
  }

  Widget buildVet(String imageUrl, String name, String phone, int index) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.75,
      margin: EdgeInsets.only(right: 16, left: index == 0 ? 16 : 0),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        border: Border.all(
          width: 1,
          color: Colors.grey[300],
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.grey[800],
                        size: 18,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          phone,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "OPEN - 24/7",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
