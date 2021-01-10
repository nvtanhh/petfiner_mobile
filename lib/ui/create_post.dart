import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:image/image.dart' as Im;
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:pet_finder/ui/home_screen.dart';

class CreatePost extends StatefulWidget {
  final Pet pet;

  CreatePost(this.pet, {Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  var _contentController;

  final picker = ImagePicker();
  // File imageFile;

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
                EasyLoading.showToast('Post successfully!');
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MyNavigator()));
              })
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(widget.pet.avatar),
                radius: 30,
              ),
              SizedBox(height: 5),
              Text(widget.pet.name)
            ],
          ),
        ),
        SizedBox(height: 30),
        Container(
          height: MediaQuery.of(context).size.height * .25,
          child: TextField(
            controller: _contentController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
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
            expands: true,
            keyboardType: TextInputType.multiline,
          ),
        ),
        _addImageWrapper(),
        // TextField()
        // SizedBox(
        //   height: MediaQuery.of(context).viewInsets.bottom,
        // ),
      ],
      // ),
    );
  }

  List<File> _uploadedImages = [];

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
                padding: EdgeInsets.only(left: 16),
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
}
