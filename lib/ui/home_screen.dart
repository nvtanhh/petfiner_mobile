import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/posts_list.dart';
import 'package:pet_finder/ui/widgets/post_widget.dart';

import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/utils.dart';

import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _loadNewPosts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
                child: RefreshIndicator(
                    onRefresh: _loadNewPosts,
                    child: posts != null
                        ? posts.isNotEmpty
                            ? SingleChildScrollView(
                                physics: ClampingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // head line
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 10, 16, 0),
                                      child: Text(
                                        "Hey Tanh!",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(16, 0, 16, 0),
                                      child: Text(
                                        "Let us be a friend.",
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),

                                    ListView.builder(
                                      shrinkWrap: true,
                                      padding:
                                          EdgeInsets.fromLTRB(16, 20, 16, 0),
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: posts.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Container(
                                        height: 300,
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: PostWidget(
                                          key: ObjectKey(posts[index]),
                                          post: posts[index],
                                          showAsColumn: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _error
                                ? Center(
                                    child: MaterialButton(
                                    onPressed: _loadNewPosts,
                                    color: Colors.blue,
                                    child: Text(
                                      'NO DATA. Click to try again.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                                : Center(child: CircularProgressIndicator())
                        : _error
                            ? Center(
                                child: MaterialButton(
                                onPressed: _loadNewPosts,
                                color: Colors.blue,
                                child: Text(
                                  'ERROR. Click to try again.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                            : Center(child: CircularProgressIndicator()))),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 0, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.red,
            margin: EdgeInsets.only(left: 16),
            child: Image.asset('assets/images/text_art.png',
                height: 30, fit: BoxFit.fitHeight),
          ),
          Icon(
            Icons.message_outlined,
            color: Colors.grey[800],
          )
        ],
      ),
    );
  }

  Future<void> _loadNewPosts() async {
    _removeError();
    String token = await getStringValue('token');
    try {
      http.Response response = await http.get(
        Apis.getPostUrl,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        PostsList postsList = PostsList.fromJson(parsedJson);
        setState(() {
          posts = postsList.posts;
        });
      } else if (response.statusCode == 500) {
        _onError();
        showError('Server error, please try again latter.');
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
      _onError();
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
      _onError();
    }
  }

  void _onError() {
    setState(() {
      _error = true;
    });
  }

  void _removeError() {
    setState(() {
      _error = false;
    });
  }
}
