import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class EditProfile extends StatefulWidget {
  final String photoUrl, email, bio, name, phone;
  EditProfile(
      {this.photoUrl = '',
      this.email = '',
      this.bio = '',
      this.name = '',
      this.phone = ''});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final picker = ImagePicker();
  File imageFile;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.photoUrl.toString());

    _nameController.text = widget.name;
    _bioController.text = widget.bio;
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
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
            onTap: () {
              Navigator.pop(context);
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
                backgroundImage: widget.photoUrl.isEmpty
                    ? AssetImage('assets/images/sample/avt.jpg')
                    : NetworkImage(widget.photoUrl),
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
                  onChanged: ((value) {
                    setState(() {
                      _nameController.text = value;
                    });
                  }),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                  onChanged: ((value) {
                    setState(() {
                      _bioController.text = value;
                    });
                  }),
                ),
              ),
              SizedBox(
                height: 20,
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
                  onChanged: ((value) {
                    setState(() {
                      _emailController.text = value;
                    });
                  }),
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
                  onChanged: ((value) {
                    setState(() {
                      _phoneController.text = value;
                    });
                  }),
                ),
              )
            ],
          ),
          Container(
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
}
