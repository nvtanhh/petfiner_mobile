import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/ui/create_post.dart';
import 'package:pet_finder/ui/profile_screen.dart';
import 'package:pet_finder/ui/pet_detail.dart';
import 'package:pet_finder/utils.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

class PostDetail extends StatefulWidget {
  final Post post;

  final String from;
  ValueChanged<Post> onUpdate;

  Function() onDelete;
  PostDetail(this.post, {this.from, this.onUpdate, this.onDelete});

  @override
  _PostDetailState createState() => _PostDetailState(post);
}

class _PostDetailState extends State<PostDetail> {
  int currentTabImage = 1;
  final String _defaultPostImage = 'assets/images/sample/post.jpg';
  ScreenshotController screenshotController = ScreenshotController();

  Post post;

  Future _isMyPostFuture;

  bool isEdited = false;

  _PostDetailState(this.post);

  @override
  void initState() {
    super.initState();
    _isMyPostFuture = _checkIsMyPost();
  }

  @override
  Widget build(BuildContext context) {
    Pet pet = post.pet;
    String tagPrefix = widget.from ?? '';

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: _sharePost,
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
            ),
            FutureBuilder(
              future: _isMyPostFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data)
                  return PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert),
                    onSelected: showMenuSelection,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                          value: 'Edit', child: Text('Edit post')),
                      const PopupMenuItem<String>(
                          value: 'Delete', child: Text('Delete post'))
                    ],
                  );
                else
                  return Container(width: 0.0, height: 0.0);
              },
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  post.imageUrls != null
                      ? PageView.builder(
                          onPageChanged: onPageChanged,
                          itemCount: post.imageUrls.length,
                          itemBuilder: (context, index) => index == 0
                              ? Hero(
                                  tag: tagPrefix +
                                      post.id.toString() +
                                      post.imageUrls[index],
                                  child: _buildImage(index: index),
                                )
                              : _buildImage(index: index),
                        )
                      : Hero(
                          tag: tagPrefix + 'iamgeUrl' + post.id.toString(),
                          child: _buildImage(),
                        ),
                  if (post.imageUrls.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15, right: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[300].withOpacity(.6),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          currentTabImage.toString() +
                              " / " +
                              post.imageUrls.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15, left: 15),
                      decoration: BoxDecoration(
                        color: post.conditionText() == "Adoption"
                            ? Colors.orange[100]
                            : post.conditionText() == "Disappear"
                                ? Colors.red[100]
                                : Colors.blue[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        post.conditionText(),
                        style: TextStyle(
                          color: post.conditionText() == "Adoption"
                              ? Colors.orange
                              : post.conditionText() == "Disappear"
                                  ? Colors.red
                                  : Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (_) => PetDetail(pet))),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: pet?.avatar == null
                                          ? AssetImage(
                                              'assets/images/sample/animal.png')
                                          : CachedNetworkImageProvider(
                                              Apis.avatarDirUrl + pet.avatar,
                                            ),
                                      radius: 20,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Flexible(
                                      child: Text(
                                        pet.name,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  FutureBuilder(
                                    future: getAdress(pet.address.address),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data,
                                          // overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      } else
                                        return Container();
                                    },
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    widget?.post?.distance != null
                                        ? "(" +
                                            post.distance.toStringAsFixed(2) +
                                            " km)"
                                        : '',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                post.isLiked ? Colors.red[400] : Colors.white,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 24,
                            color:
                                post.isLiked ? Colors.white : Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        buildPetFeature(
                            pet.age != null
                                ? pet.age.toString()
                                : 'Uknow' + " months",
                            "Months"),
                        buildPetFeature(
                            pet.color != null ? pet.color.toString() : 'Uknow',
                            "Color"),
                        buildPetFeature(
                            pet.weight != null
                                ? pet.weight.toString() + ' Kg'
                                : 'Uknow',
                            "Weight"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Content",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: !post.content.contains('<')
                        ? Text(
                            post.content ?? '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          )
                        : Html(
                            data: post.content ?? '',
                          ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: 16, left: 16, top: 16, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(user: pet?.owner)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Row(
                              children: [
                                // UserAvatar(pet?.owner?.avatar ?? ''),
                                CircleAvatar(
                                  backgroundColor: Colors.blue[200],
                                  radius: 30,
                                  backgroundImage: pet.owner.avatar == null
                                      ? AssetImage(
                                          'assets/images/user_avatar.jpg')
                                      : CachedNetworkImageProvider(
                                          Apis.avatarDirUrl + pet.owner.avatar),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Posted by",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        pet?.owner?.name ?? 'Unknow',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue[300].withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 0),
                              ),
                            ],
                            color: Colors.blue[300],
                          ),
                          child: Text(
                            "Contact Me",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildPetFeature(String value, String feature) {
    return Expanded(
      child: Container(
        height: 70,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              feature,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage({int index}) {
    String imageUrl = index == null
        ? _defaultPostImage
        : Apis.baseURL + post.imageUrls[index];
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (post.imageUrls == null && post.imageUrls.length == 0)
              ? AssetImage(_defaultPostImage)
              : CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      currentTabImage = value + 1;
    });
  }

  void _sharePost() {
    screenshotController.capture().then((File image) {
      Share.shareFiles([image.path],
          subject: 'Shared from MeoWoof\'s screenshot.',
          text: 'Check our post on MeoWoof.');
    }).catchError((onError) {
      print(onError);
    });
  }

  void showMenuSelection(String value) {
    switch (value) {
      case 'Delete':
        _showDeleteDialog(context);
        break;
      case 'Edit':
        _editPost();
        break;
      default:
    }
  }

  void _editPost() async {
    String mess = await Navigator.push(
        context, MaterialPageRoute(builder: (_) => CreatePost(post: post)));
    if (mess != null && mess == 'edited') {
      // isEdited = true;
      setState(() {});
      widget.onUpdate(post);
    }
  }

  _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("Delete confirm."),
          content: Text(
            "Are you sure to delete this Post?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black54),
          ),
          actions: <Widget>[
            ButtonTheme(
              //minWidth: double.infinity,
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                color: Colors.grey[400],
                textColor: const Color(0xffffffff),
              ),
            ),
            ButtonTheme(
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (await _deletePost()) {
                    Navigator.of(context).pop('deleted');
                    if (widget.onDelete != null) widget.onDelete();
                    EasyLoading.showToast("Deleted!",
                        duration: new Duration(seconds: 1));
                  } else
                    showError("Delete post failed. Please try again latter");
                },
                child: Text('Delete'),
                color: Theme.of(context).primaryColor,
                textColor: const Color(0xffffffff),
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool> _deletePost() async {
    String token = await getStringValue('token');
    final http.Response response = await http.delete(
      Apis.deletePost + post.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    print('_deletePost:  ' + response.statusCode.toString());

    return response.statusCode == 200;
  }

  Future<bool> _checkIsMyPost() async {
    String storedUserId = await getStringValue('loggedUserId');
    bool rs =
        storedUserId != null && int.parse(storedUserId) == post.pet.owner.id;
    return rs;
  }
}
