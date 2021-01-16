import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:image/image.dart' as Im;
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:pet_finder/ui/pet_detail.dart';
import 'package:http/http.dart' as http;
import 'package:pet_finder/utils.dart';

class CreatePost extends StatefulWidget {
  final Pet pet;

  CreatePost(this.pet, {Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  var _contentController;

  final picker = ImagePicker();
  List<File> _uploadedImages = [];

  KeyboardVisibilityController keyboardVisibilityController;
  bool isKeyboardShowing = false;

  @override
  void initState() {
    super.initState();

    keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (this.mounted)
        setState(() {
          isKeyboardShowing = visible;
          print(visible.toString());
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Create Post",
          style: TextStyle(),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 16),
                child: Text(
                  'Post',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ),
              onTap: () {
                _post();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyNavigator()));
                EasyLoading.showToast('Post successfully!');
              })
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserAvtar(),
                Expanded(
                  child: ListView(
                    children: [
                      TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 75),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Add your content',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ),
          ),
          _addImageWrapper(),
          if (!isKeyboardShowing)
            SizedBox(
              height: 265,
            )
        ],
      ),
    );
  }

  Widget _addImageWrapper() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ListView.builder(
                // padding: EdgeInsets.only(left: 16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _uploadedImages.length,
                itemBuilder: (context, index) =>
                    _imageItem(file: _uploadedImages[index]),
              ),
              _imageItem(),
            ],
          )),
    );
  }

  Widget _imageItem({File file}) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              if (file == null) _showImageDialog();
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10),
                image: file != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(file),
                      )
                    : null,
              ),
              child: file == null
                  ? Container(
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                        size: 30,
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 10,
          child: file != null
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _uploadedImages.remove(file);
                    });
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black,
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(),
        )
      ],
    );
  }

  Future<File> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<File> _takePhotoCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        // barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage().then((selectedImage) {
                    if (selectedImage != null)
                      setState(() {
                        // imageFile = selectedImage;
                        _uploadedImages.add(selectedImage);
                      });
                    Navigator.pop(context);
                    // compressImage(selectedImage);
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _takePhotoCamera().then((selectedImage) {
                    if (selectedImage != null)
                      setState(() {
                        // imageFile = selectedImage;
                        _uploadedImages.add(selectedImage);
                      });
                    // compressImage(selectedImage);
                  });
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  void compressImage(File selectedImage) async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(selectedImage.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    if (newim2 != null)
      setState(() {
        // imageFile = newim2;
        _uploadedImages.add(newim2);
      });
    print('done');
  }

  _buildUserAvtar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => PetDetail(widget.pet)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              alignment: Alignment.topCenter,
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: widget.pet?.avatar == null
                      ? AssetImage('assets/sample/animal.jpg')
                      : CachedNetworkImageProvider(
                          Apis.avatarDirUrl + widget.pet.avatar,
                        ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _post() async {
    String token = await getStringValue('token');
    http.post(
      'https://jsonplaceholder.typicode.com/albums',
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'Content': _contentController.text,
        'PetId': widget.pet.id.toString(),
      }),
    );
  }
}
