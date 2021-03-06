import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/vet.dart';
import 'package:pet_finder/ui/search_map_screen.dart';
import 'package:pet_finder/ui/search_result.dart';

import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/utils.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // List<Post> posts = getPostList();

  List<Vet> vets = [
    new Vet(
        img: "assets/images/vets/nonglam.png",
        name: "Nong Lam University Vet",
        phone: "028 3896 7596"),
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
      child: SingleChildScrollView(
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
                        isDense: true, // Added this
                        contentPadding:
                            EdgeInsets.fromLTRB(8, 8, 30, 8), // Added this
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
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(right: 16.0, left: 16),
                          child: Icon(
                            Icons.search,
                            color: Colors.black54,
                            size: 24,
                          ),
                        ),
                      ),
                      onSubmitted: _onSearchSubmit,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => MapSearcher()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue[700],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Pet Category",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _countPost(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData)
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildPetCategory(PetCategory.DOG,
                                snapshot.data[0].toString(), Colors.red[200]),
                            buildPetCategory(PetCategory.CAT,
                                snapshot.data[1].toString(), Colors.blue[200]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildPetCategory(
                                PetCategory.HAMSTER,
                                snapshot.data[2].toString(),
                                Colors.orange[200]),
                            buildPetCategory(PetCategory.OTHER,
                                snapshot.data[3].toString(), Colors.green[200]),
                          ],
                        ),
                      ],
                    ),
                  );
                else
                  return Container(width: 0, height: 0);
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, left: 16, bottom: 8, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Vets Near You",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 16),
              height: 130,
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) => buildVet(vets[index].img,
                    vets[index].name, vets[index].phone, index),
                scrollDirection: Axis.horizontal,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPetCategory(PetCategory category, String total, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchResult(category: category)),
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
                        (category == PetCategory.HAMSTER
                            ? "hamster"
                            : category == PetCategory.CAT
                                ? "cat"
                                : category == PetCategory.OTHER
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
                        category == PetCategory.HAMSTER
                            ? "Hamsters"
                            : category == PetCategory.CAT
                                ? "Cats"
                                : category == PetCategory.OTHER
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

  // List<Widget> buildNewestPet() {
  //   List<Widget> list = [];
  //   for (var i = 0; i < posts.length; i++) {
  //     if (posts[i].pet.newest) {
  //       list.add(PostWidget(
  //         post: posts[i],
  //         index: i,
  //         from: 'search2',
  //       ));
  //     }
  //   }
  //   return list;
  // }

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

  _onSearchSubmit(String value) {
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => SearchResult(query: value),
        ));
  }

  Future<List<int>> _countPost() async {
    String token = await getStringValue('token');
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer $token";
    Response response = await dio.get(Apis.countPost);
    if (response.statusCode == 200)
      return response.data.cast<int>();
    else
      return null;
  }
}
