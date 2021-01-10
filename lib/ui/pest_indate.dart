import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:image/image.dart' as Im;
import 'package:pet_finder/ui/widgets/input_wrapper.dart';
import 'package:pet_finder/utils.dart';

class PetAddUpdate extends StatefulWidget {
  final Pet pet;

  PetAddUpdate({Key key, this.pet}) : super(key: key);

  @override
  _PetAddUpdateState createState() => _PetAddUpdateState(pet);
}

class _PetAddUpdateState extends State<PetAddUpdate> {
  final Pet pet;

  List<String> _genders = ['Male', 'Female'];
  _PetAddUpdateState(this.pet);

  Category petCategory;

  final picker = ImagePicker();
  File imageFile;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  final _breedController = TextEditingController();
  final _birthdayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (pet != null) {
      _nameController.text = pet.name;
      _bioController.text = pet.bio;
      _selectedgender = pet.gender.capitalize();
      _birthdayController.text = pet.birhday;
      _colorController.text = pet.color;
      _weightController.text = pet.weight == null ? '' : pet.weight.toString();
      _breedController.text = pet.breed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          pet != null ? pet.name : "Add your new pet",
          style: TextStyle(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.done,
                size: 20,
              ),
              onPressed: () {
                EasyLoading.showToast('Save successfully!');
                Navigator.pop(context);
              })
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        if (pet == null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (petCategory == null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
                  child: Text(
                    'Choose your pet category first, please: ',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              _buildChoosePetCategory(),
              SizedBox(height: 10),
            ],
          ),
        GestureDetector(
          onTap: () {
            if (pet == null && petCategory == null) {
              EasyLoading.showToast(
                  'Choose what kind of your pet first, please!');
            }
          },
          child: Opacity(
            opacity: (pet == null && petCategory == null) ? .4 : 1,
            child: AbsorbPointer(
              absorbing: (pet == null && petCategory == null),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          backgroundImage: pet == null
                              ? AssetImage('assets/images/sample/animal.png')
                              : AssetImage(pet.avatar),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    InputContainerWrapper(
                        controller: _nameController, title: 'Name'),
                    InputContainerWrapper(
                      controller: _bioController,
                      title: 'Bio',
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: _buildDropdownGender(),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InputContainerWrapper(
                            onTab: () => _selectDate(context),
                            controller: _birthdayController,
                            title: 'Birthday',
                            type: 2,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Optional',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InputContainerWrapper(
                            controller: _colorController,
                            title: 'Color',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InputContainerWrapper(
                            controller: _weightController,
                            title: 'Weight',
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: InputContainerWrapper(
                            controller: _breedController,
                            title: 'Breed',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
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
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      _birthdayController.text = DateFormat('yyyy-MM-dd').format(picked);
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
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
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

  _buildChoosePetCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPetCategory(Category.DOG, Colors.red[200]),
        _buildPetCategory(Category.CAT, Colors.blue[200]),
        _buildPetCategory(Category.HAMSTER, Colors.orange[200]),
        _buildPetCategory(Category.OTHER, Colors.green[200]),
      ],
    );
  }

  Widget _buildPetCategory(Category category, Color color) {
    return Expanded(
      child: Opacity(
        opacity: category == petCategory ? 1 : .3,
        child: GestureDetector(
          onTap: () {
            setState(() {
              petCategory = category;
            });
          },
          child: Container(
            height: 70,
            child: Column(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.5),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/" +
                          (category == Category.HAMSTER
                              ? "hamster"
                              : category == Category.CAT
                                  ? "cat"
                                  : category == Category.OTHER
                                      ? "bunny"
                                      : "dog") +
                          ".png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Text(
                    category == Category.HAMSTER
                        ? "Hamsters"
                        : category == Category.CAT
                            ? "Cats"
                            : category == Category.OTHER
                                ? "Others"
                                : "Dogs",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _selectedgender;

  _buildDropdownGender() {
    return Container(
      height: 57,
      child: InputDecorator(
        decoration: const InputDecoration(
          hintText: "Gender",
          // isDense: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            items: _genders.map((String category) {
              return new DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: <Widget>[
                      Text(category),
                    ],
                  ));
            }).toList(),
            onChanged: (newValue) {
              setState(() => _selectedgender = newValue);
            },
            value: _selectedgender,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 14, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
