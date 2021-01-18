import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/pets_list.dart';
import 'package:pet_finder/ui/create_post.dart';
import 'package:http/http.dart' as http;
import 'package:pet_finder/utils.dart';

class ChoosePet extends StatefulWidget {
  const ChoosePet({Key key}) : super(key: key);

  @override
  _ChoosePetState createState() => _ChoosePetState();
}

class _ChoosePetState extends State<ChoosePet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Choose Your pet",
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Text(
              'Which Pet you create a new post for?',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          FutureBuilder(
            future: _loadMyPet(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12),
                    padding: EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return _petItem(snapshot.data[index], context);
                    },
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _petItem(Pet pet, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePost(pet: pet)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: pet?.avatar == null
                  ? AssetImage('assets/images/sample/animal.png')
                  : CachedNetworkImageProvider(
                      Apis.avatarDirUrl + pet.avatar,
                    ),
              radius: 40,
            ),
            SizedBox(
              height: 12,
            ),
            Flexible(
              child: Text(
                pet.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  child: pet.gender == 'male'
                      ? Image.asset(
                          'assets/icons/male.png',
                          color: Colors.blue,
                        )
                      : Image.asset(
                          'assets/icons/female.png',
                          color: Colors.pink,
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Alaska",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Pet>> _loadMyPet() async {
    String token = await getStringValue('token');
    try {
      http.Response response = await http.get(
        Apis.getMyPets,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      print('_loadMyPets:   ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson);
        return PetsList.fromJson(parsedJson).pets;
      } else if (response.statusCode == 500) {
        showError('Server error, please try again latter.');
        return null;
      } else {
        return null;
      }
    } on TimeoutException catch (e) {
      return null;
    } on SocketException catch (e) {
      return null;
    }
  }
}
