import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/core/models/posts_list.dart';
import 'package:pet_finder/ui/post_detail.dart';
import 'package:pet_finder/ui/widgets/post_widget.dart';
import 'package:http/http.dart' as http;
import 'package:pet_finder/utils.dart';

class PostAndAblumWrapper extends StatefulWidget {
  List<Post> posts;
  bool postError;

  PostAndAblumWrapper({Key key, this.posts, this.postError}) : super(key: key);

  @override
  _PostAndAblumWrapperState createState() => _PostAndAblumWrapperState();
}

class _PostAndAblumWrapperState extends State<PostAndAblumWrapper> {
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;

  @override
  void initState() {
    super.initState();
    _loadMyPosts();
  }

  void _loadMyPosts() async {
    String token = await getStringValue('token');
    try {
      http.Response response = await http.get(
        Apis.getMyPosts,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      print('_loadMyPosts: ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        setState(() {
          widget.posts = PostsList.fromJson(parsedJson).posts;
        });
      } else if (response.statusCode == 500) {
        showError('Server error, please try again latter.');
        setState(() {
          widget.postError = true;
        });
      } else {
        setState(() {
          widget.postError = true;
        });
      }
    } on TimeoutException catch (e) {
      setState(() {
        widget.postError = true;
      });
      showError(e.toString());
    } on SocketException catch (e) {
      setState(() {
        widget.postError = true;
      });
      showError(e.toString());
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.grid_on,
                    color: _gridColor,
                    size: 22,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isGridActive = true;
                    _gridColor = Colors.blue;
                    _listColor = Colors.grey;
                  });
                },
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.stay_current_portrait,
                    color: _listColor,
                    size: 22,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isGridActive = false;
                    _listColor = Colors.blue;
                    _gridColor = Colors.grey;
                  });
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(),
        ),
        postImagesWidget(),
      ],
    );
  }

  Widget postImagesWidget() {
    return _isGridActive == true ? _showAsGrid() : _showAsPost();
  }

  Widget _showAsPost() {
    return widget.posts != null
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, left: 16, right: 16),
            scrollDirection: Axis.vertical,
            itemCount: widget.posts.length,
            itemBuilder: (context, index) => Container(
              height: 300,
              child: PostWidget(
                  post: widget.posts[index], showAsColumn: true, from: 'card_'),
            ),
          )
        : !widget.postError
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Text("Error!"),
              );
  }

  Widget _showAsGrid() {
    final String _defaultPostImage = 'assets/images/sample/post.jpg';
    return widget.posts != null
        ? GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.posts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
            itemBuilder: (context, index) => GestureDetector(
              child: Hero(
                tag: widget.posts[index].imageUrls.isNotEmpty
                    ? 'grib_' +
                        widget.posts[index].id.toString() +
                        widget.posts[index].imageUrls[0]
                    : 'grib_' + 'imageUrl' + widget.posts[index].id.toString(),
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                  // image: AssetImage(widget.posts[index].imageUrls.isNotEmpty
                  //     ? widget.posts[index].imageUrls[0]
                  //     : _defaultPostImage),
                  image: widget.posts[index].imageUrls.length == 0
                      ? AssetImage(_defaultPostImage)
                      : CachedNetworkImageProvider(
                          Apis.baseUrlOnline + widget.posts[index].imageUrls[0],
                        ),
                  fit: BoxFit.cover,
                ))),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            PostDetail(widget.posts[index], from: 'grid_'))));
              },
            ),
          )
        : !widget.postError
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Text("Error!"),
              );
  }
}
