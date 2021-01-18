import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/images_list.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:image/image.dart' as Im;
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:pet_finder/ui/pet_detail.dart';
import 'package:pet_finder/utils.dart';

// import 'package:http/http.dart' as http;

class CreatePost extends StatefulWidget {
  final Pet pet;
  final Post post;

  CreatePost({this.pet, this.post, Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController _contentController = TextEditingController();

  final picker = ImagePicker();
  List<File> _uploadedImages = [];

  KeyboardVisibilityController keyboardVisibilityController;
  bool isKeyboardShowing = false;

  String token;

  PostCategory _choosedPostCategory;
  Pet pet;

  Future _future;
  @override
  void initState() {
    super.initState();

    _future = loadImage();
    initEditPost();

    keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (this.mounted)
        setState(() {
          isKeyboardShowing = visible;
          print(visible.toString());
        });
    });
  }

  Future<bool> initEditPost() async {
    if (widget.post != null) {
      pet = widget.post.pet;
      _contentController.text = widget.post.content;
      _choosedPostCategory = widget.post.postCategory;
      return true;
    } else
      pet = widget.pet;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          widget.post == null ? "Create Post" : 'Edit Post',
          style: TextStyle(),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 16),
              child: Text(
                widget.post == null ? 'Post' : 'Update',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white),
              ),
            ),
            onTap: () async {
              if (widget.post != null) {
                EasyLoading.show(status: 'Updating...', dismissOnTap: true);
                Post newPost = await _indate(isUpdate: true);
                if (newPost != null) {
                  showToast('Update successfully!');
                  Navigator.of(context).pop('edited');
                } else
                  showError('Post Failed! Please try again.');
              } else {
                if (_choosedPostCategory == null) {
                  showError('Please choose your post category first.');
                  return;
                }
                EasyLoading.show(status: 'Uploading...', dismissOnTap: true);
                if (await _indate() != null) {
                  showToast('Post successfully!');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MyNavigator()));
                } else {
                  showError('Post Failed! Please try again.');
                }
              }
            },
          )
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildUserAvtar(), _chooseCategoryWrapper()],
                ),
                Expanded(
                  child: TextField(
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
              FutureBuilder(
                future: _future,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData)
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _uploadedImages.length,
                      itemBuilder: (context, index) =>
                          _imageItem(file: _uploadedImages[index]),
                    );
                  else {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget?.post?.imageUrls?.length ?? 0,
                        itemBuilder: (context, index) =>
                            _imageItem(isWaiting: true));
                  }
                },
              ),
              _imageItem(),
            ],
          )),
    );
  }

  Widget _imageItem({File file, bool isWaiting = false}) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              if (file == null && !isWaiting) _showImageDialog();
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
                  ? !isWaiting
                      ? Container(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.grey)))
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
            new MaterialPageRoute(builder: (context) => PetDetail(pet)));
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 5),
              alignment: Alignment.topCenter,
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: pet?.avatar == null
                      ? AssetImage('assets/images/sample/animal.png')
                      : CachedNetworkImageProvider(
                          Apis.avatarDirUrl + pet.avatar,
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

  // Future<Post> _update() async {
  //   token = await getStringValue('token');
  //   print('start upload iamges...............');
  //   List<String> uploadedImageUrls = await uploadImages();
  //   Post post = new Post(
  //       id: widget.post.id,
  //       pet: pet,
  //       imageUrls: uploadedImageUrls,
  //       postCategory: _choosedPostCategory,
  //       content: _contentController.text);
  //   final data = post.toUploadJson();

  //   final http.Response response = await http.put(
  //     Apis.editPost + post.id.toString(),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $token'
  //     },
  //   );

  //   print('_deletePost:  ' + response.statusCode.toString());
  // }

  Future<Post> _indate({bool isUpdate = false}) async {
    print('start posting...............');
    try {
      token = await getStringValue('token');
      print('start upload images...............');
      List<String> uploadedImageUrls = await uploadImages();
      print('End upload iamges...............');
      Response response;

      Post newPost;
      if (isUpdate) {
        widget.post.imageUrls = uploadedImageUrls;
        widget.post.content = _contentController.text;
        widget.post.postCategory = _choosedPostCategory;
        newPost = widget.post;
      } else
        newPost = new Post(
            pet: pet,
            imageUrls: uploadedImageUrls,
            postCategory: _choosedPostCategory,
            content: _contentController.text,
            createdAt: isUpdate ? null : new DateTime.now());

      final data = newPost.toUploadJson();
      print('ToJSON: ' + data.toString());

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      if (isUpdate)
        response = await dio.put(Apis.editPost, data: data);
      else
        response = await dio.post(Apis.uploadPost, data: data);
      if (response.statusCode == 200 && isUpdate) {
        print("kkkk");
        return Post.fromJson(response.data);
      } else if (!isUpdate)
        return newPost;
      else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String>> uploadImages() async {
    if (_uploadedImages.length != 0) {
      var request =
          http.MultipartRequest("POST", Uri.parse(Apis.uploadImageUrl));
      request.headers['content-Type'] = 'application/json';
      request.headers["authorization"] = "Bearer $token";
      for (File file in _uploadedImages) {
        var pic = await http.MultipartFile.fromPath("Images", file.path);
        request.files.add(pic);
      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return ImagesList.fromJson(jsonDecode(responseString), post: true).images;
    } else
      return [];
  }

  _chooseCategoryWrapper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostCategory(PostCategory.Adoption),
        _buildPostCategory(PostCategory.Mating),
        _buildPostCategory(PostCategory.Disappear),
      ],
    );
  }

  _buildPostCategory(PostCategory postCategory) {
    return Opacity(
      opacity: _choosedPostCategory == null
          ? .6
          : _choosedPostCategory == postCategory
              ? 1
              : .2,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _choosedPostCategory = postCategory;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: postCategory == PostCategory.Adoption
                ? Colors.orange[100]
                : postCategory == PostCategory.Disappear
                    ? Colors.red[100]
                    : Colors.blue[100],
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            conditionText(postCategory),
            style: TextStyle(
              color: postCategory == PostCategory.Adoption
                  ? Colors.orange
                  : postCategory == PostCategory.Disappear
                      ? Colors.red
                      : Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  String conditionText(PostCategory postCategory) {
    switch (postCategory) {
      case PostCategory.Adoption:
        return "Adoption";
        break;
      case PostCategory.Mating:
        return "Mating";
        break;
      case PostCategory.Disappear:
        return "Disappear";
        break;
    }
    return "";
  }

  Future<bool> loadImage() async {
    if (widget.post != null) {
      print('start loadImage.......');
      for (String url in widget.post.imageUrls) {
        _uploadedImages
            .add(await DefaultCacheManager().getSingleFile(Apis.baseURL + url));
      }
      print('end loadImage.......');
      return true;
    } else {
      return false;
    }
  }
}
