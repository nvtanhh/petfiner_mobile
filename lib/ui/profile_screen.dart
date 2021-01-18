import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/pets_list.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/core/models/posts_list.dart';
import 'package:pet_finder/core/services/my_location.dart';
import 'package:pet_finder/core/models/user.dart';
import 'package:pet_finder/ui/edit_profile.dart';
import 'package:pet_finder/ui/pets_manager.dart';
import 'package:pet_finder/ui/widgets/drawer.dart';
import 'package:pet_finder/ui/widgets/pet_widget_small.dart';
import 'package:pet_finder/ui/widgets/post_and_album_tabs.dart';
import 'package:pet_finder/utils.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({this.user, Key key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User user;
  String token;
  List<Pet> _myPets;
  List<Post> _myPosts;
  bool petError = false;
  bool postError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        endDrawer: widget.user == null ? MyDrawer() : null,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          automaticallyImplyLeading: true,
          title: Text(
            user != null ? user.name : 'Username',
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            if (widget.user == null)
              IconButton(
                  icon: Icon(Icons.settings_outlined),
                  onPressed: _openEndDrawer)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            // physics: BouncingScrollPhysics(),
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
              PostAndAblumWrapper(
                posts: _myPosts,
                postError: postError,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState.openEndDrawer();
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
                backgroundImage: user?.avatar == null
                    ? AssetImage('assets/images/user_avatar.jpg')
                    : CachedNetworkImageProvider(
                        Apis.avatarDirUrl + user.avatar),
              ),
              SizedBox(
                width: 40,
              ),
              Expanded(
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Column(
                    //       children: [
                    //         Text(
                    //           "2",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         Text('Post'),
                    //       ],
                    //     ),
                    //     Column(
                    //       children: [
                    //         Text(
                    //           "100",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         Text('Followers'),
                    //       ],
                    //     ),
                    //     Column(
                    //       children: [
                    //         Text(
                    //           "10",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //         Text('Following'),
                    //       ],
                    //     ),
                    //   ],
                    // ),
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
                user != null ? user.name : 'Username',
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
                    if (widget.user != null) {
                    } else
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => EditProfile(user)));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.user != null ? Colors.blue : Colors.white,
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
                        widget.user != null ? 'Contact' : 'Edit your profile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.user != null
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyPetsWrapper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => PetsManager(_myPets))));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.pets,
                  size: 16,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pets',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        _myPets != null
            ? Container(
                height: 80,
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _myPets.length,
                    itemBuilder: (BuildContext context, int index) => PetWidget(
                        pet: _myPets[index],
                        last: index == _myPets.length - 1)),
              )
            : Container(
                alignment: Alignment.center,
                child: !petError
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: Text("Error!"),
                      ),
              )
      ],
    );
  }

  void _loadLoggedUser() async {
    try {
      http.Response response = await http.get(
        Apis.getUserInfo,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      print('_loadLoggedUser: ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        setState(() {
          user = User.fromJson(parsedJson);
        });
        setStringValue('loggedUserId', user.id.toString());
      } else if (response.statusCode == 500) {
        showError('Server error, please try again latter.');
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
  }

  void _loadMyPets() async {
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
        setState(() {
          _myPets = PetsList.fromJson(parsedJson).pets;
        });
      } else if (response.statusCode == 500) {
        showError('Server error, please try again latter.');
        setState(() {
          petError = true;
        });
      } else {
        setState(() {
          petError = true;
        });
      }
    } on TimeoutException catch (e) {
      setState(() {
        petError = true;
      });
      showError(e.toString());
    } on SocketException catch (e) {
      setState(() {
        petError = true;
      });
      showError(e.toString());
    }
  }

  void _loadMyPosts() async {
    String token = await getStringValue('token');
    Map<String, String> queryParams;
    if (MyLocation().haveData)
      queryParams = {
        'Lat': MyLocation().lat?.toString() ?? '',
        'Lon': MyLocation().long?.toString() ?? '',
      };

    String queryString = (queryParams != null)
        ? '?' + Uri(queryParameters: queryParams).query
        : '';
    try {
      http.Response response = await http.get(
        Apis.getMyPosts + queryString,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      print('_loadMyPosts: ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        setState(() {
          _myPosts = PostsList.fromJson(parsedJson).posts;
        });
      } else if (response.statusCode == 500) {
        showError('Server error, please try again latter.');
        setState(() {
          postError = true;
        });
      } else {
        setState(() {
          postError = true;
        });
      }
    } on TimeoutException catch (e) {
      setState(() {
        postError = true;
      });
      showError(e.toString());
    } on SocketException catch (e) {
      setState(() {
        postError = true;
      });
      showError(e.toString());
      print(e.toString());
    }
  }

  Future<void> _loadData() async {
    token = await getStringValue('token');
    if (widget.user == null)
      _loadLoggedUser();
    else
      user = widget.user;
    _loadMyPets();
    _loadMyPosts();
  }

  Future<void> _refresh() async {
    _myPets = null;
    _loadData();
  }
}
