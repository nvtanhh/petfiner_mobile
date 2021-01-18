import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/user.dart';
import 'package:pet_finder/utils.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final User user;

  final ValueChanged<User> onUpdated;

  EditProfile(this.user, {this.onUpdated});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final picker = ImagePicker();
  File imageFile;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String token;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user.name;
      _emailController.text = widget.user.email;
      _phoneController.text = widget.user.phone;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Edit Profile'),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.done),
            ),
            onTap: () async {
              await _onSubmit();
            },
          )
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: _showImageDialog,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 15,
                      child: Icon(
                        Icons.camera_alt,
                        size: 15.0,
                        color: Color(0xFF404040),
                      ),
                    ),
                  ),
                ),
                radius: 50,
                backgroundImage: imageFile != null
                    ? FileImage(imageFile)
                    : widget?.user?.avatar == null
                        ? AssetImage('assets/images/sample/avt.jpg')
                        : NetworkImage(Apis.avatarDirUrl + widget.user.avatar),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Name', labelStyle: TextStyle(fontSize: 14)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Private Information',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                  readOnly: true,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              await _onSubmit();
            },
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.center,
              child: Text(
                'Submit',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage().then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();

                    // _repository.uploadImageToStorage(imageFile).then((url) {
                    //   _repository.updatePhoto(url, currentUser.uid).then((v) {
                    //     Navigator.pop(context);
                    //   });
                    // });
                  });
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _takePhotoCamera().then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    // _repository.uploadImageToStorage(imageFile).then((url) {
                    //   _repository.updatePhoto(url, currentUser.uid).then((v) {
                    //     Navigator.pop(context);
                    //   });
                    // });
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

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  Future<User> _updateProfile() async {
    print('start posting...............');
    try {
      token = await getStringValue('token');
      print('start upload iamges...............');
      String uploadedImageUrl;
      if ((imageFile != null)) uploadedImageUrl = await uploadImages();
      print('End upload iamges...............');
      Response response;

      widget.user.avatar = uploadedImageUrl ?? widget.user.avatar;
      widget.user.name = _nameController.text;
      widget.user.phone = _phoneController.text;

      final data = widget.user.toJson();

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      response = await dio.put(Apis.editProfile, data: data);
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> uploadImages() async {
    if (imageFile != null) {
      var request =
          http.MultipartRequest("POST", Uri.parse(Apis.uploadAvatarUrl));
      request.headers['content-Type'] = 'application/json';
      request.headers["authorization"] = "Bearer $token";
      var pic = await http.MultipartFile.fromPath("Images", imageFile.path);
      request.files.add(pic);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      return responseString.toString().replaceAll('"', '');
    } else
      return '';
  }

  _onSubmit() async {
    EasyLoading.show(status: 'Updating...', dismissOnTap: true);
    User editedUser = await _updateProfile();
    if (editedUser != null) {
      showToast('Update successfully!');
      if (widget.onUpdated != null) widget.onUpdated(editedUser);
      Navigator.of(context).pop();
    } else
      showError('Update Failed! Please try again.');
  }
}
