import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/edit_profile.dart';
import 'package:pet_finder/ui/pets_manager.dart';
import 'package:pet_finder/ui/widgets/pet_widget_small.dart';
import 'package:pet_finder/ui/widgets/post_and_album_tabs.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Catlover_2549",
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: _buildProfileInfo(),
            ),
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: _buildMyPetsWrapper(),
            ),
            SizedBox(height: 5),
            PostAndAblumWrapper(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage('assets/images/user_avatar.jpg'),
              ),
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text('Post'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "100",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text('Followers'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "10",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text('Following'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Catlover_2549',
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => EditProfile()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Edit your profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: Container(
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.all(
              //           Radius.circular(5),
              //         ),
              //         // border: Border.all(width: 1, color: Colors.grey),
              //         color: Theme.of(context).primaryColor),
              //     child: Padding(
              //       padding: const EdgeInsets.all(8),
              //       child: Text(
              //         'Follow',
              //         style: TextStyle(
              //             color: Colors.white, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              // Expanded(
              //   child: Container(
              //     alignment: Alignment.center,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(5),
              //       ),
              //       border: Border.all(
              //         width: 1.5,
              //         color: Colors.grey[400],
              //       ),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
              //       child: Text('Contact'),
              //     ),
              //   ),
              // )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyPetsWrapper() {
    List<Pet> _myPets = getPetList().sublist(0, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => PetsManager())));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Text(
                  'Pets',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          height: 80,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _myPets.length,
            itemBuilder: (BuildContext context, int index) => PetWidget(
                pet: _myPets[index], last: index == _myPets.length - 1),
          ),
        )
      ],
    );
  }
}
