import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/Address.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:image/image.dart' as Im;
import 'package:pet_finder/locationpiker/widgets/widgets.dart';
import 'package:pet_finder/ui/widgets/input_wrapper.dart';
import 'package:pet_finder/utils.dart';
import 'package:http/http.dart' as http;

class PetAddUpdate extends StatefulWidget {
  final Pet pet;

  final ValueChanged<Pet> onUpdated;

  ValueChanged<Pet> onCreated;

  PetAddUpdate({Key key, this.pet, this.onUpdated, this.onCreated})
      : super(key: key);

  @override
  _PetAddUpdateState createState() => _PetAddUpdateState();
}

class _PetAddUpdateState extends State<PetAddUpdate> {
  String token;

  Address petAddress;

  DateTime _petBrithday;

  _PetAddUpdateState();
  List<String> _genders = ['Male', 'Female'];

  PetCategory _petCategory;

  final picker = ImagePicker();
  File imageFile;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _colorController = TextEditingController();
  final _weightController = TextEditingController();
  final _breedController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressController = TextEditingController();
  Future _getAddressFuture;

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet.name;
      _bioController.text = widget.pet.bio;
      _selectedgender = widget.pet.gender.capitalize();
      _birthdayController.text = widget.pet.birhday != null
          ? DateFormat('yyyy-MM-dd').format(widget.pet.birhday)
          : '';
      _colorController.text = widget.pet.color;
      _weightController.text =
          widget.pet.weight == null ? '' : widget.pet.weight.toString();
      _breedController.text = widget.pet.breed;

      petAddress = widget.pet.address;

      // _getAddressFuture = getAdress(widget?.pet?.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          widget.pet != null ? widget.pet.name : "Add your new pet",
          style: TextStyle(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.done,
                size: 20,
              ),
              onPressed: () async {
                await _onSubmit();
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
        if (widget.pet == null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_petCategory == null)
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
            if (widget.pet == null && _petCategory == null) {
              EasyLoading.showToast(
                  'Choose what kind of your pet first, please!');
            }
          },
          child: Opacity(
            opacity: (widget.pet == null && _petCategory == null) ? .4 : 1,
            child: AbsorbPointer(
              absorbing: (widget.pet == null && _petCategory == null),
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
                          backgroundImage: imageFile != null
                              ? FileImage(imageFile)
                              : widget.pet == null
                                  ? AssetImage(
                                      'assets/images/sample/animal.png')
                                  : NetworkImage(
                                      Apis.avatarDirUrl + widget.pet.avatar),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    InputContainerWrapper(
                        controller: _nameController, title: 'Name'),
                    InputContainerWrapper(
                      controller: _bioController,
                      title: 'Bio',
                      maxLines: 3,
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
                            isReadOnly: true,
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future: getAdress(widget?.pet?.address),
                        builder: (context, snapshot) {
                          // if (snapshot.hasData) {

                          // } else
                          //   return Container();

                          if (snapshot.hasData &&
                              _addressController.text.isEmpty)
                            _addressController.text = '  ' + snapshot.data;
                          return InputContainerWrapper(
                            controller: _addressController,
                            title: 'Address',
                            prefix: Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 16,
                            ),
                            isReadOnly: true,
                            onTab: () async {
                              String data = await DefaultAssetBundle.of(context)
                                  .loadString(".env.json");

                              String apiKey = jsonDecode(data)["MAP_API_KEY"];
                              LatLng latLng = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          PlacePicker(apiKey))));
                              if (latLng != null) {
                                String address = await getAddressFromLatLng(
                                    latLng.latitude, latLng.longitude);
                                print("ADDRESS: " + address);
                                petAddress = new Address(
                                    address, latLng.latitude, latLng.longitude);
                                setState(() {
                                  _addressController.text =
                                      '   ' + address.trim();
                                });
                              }
                            },
                          );
                        }),
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
                              keyboardType: TextInputType.number),
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
                    GestureDetector(
                      onTap: () async {
                        await _onSubmit();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        alignment: Alignment.center,
                        child: Text(
                          'Submit',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ),
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
    if (picked != null && picked != selectedDate) _petBrithday = picked;
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
        _buildPetCategory(PetCategory.DOG, Colors.red[200]),
        _buildPetCategory(PetCategory.CAT, Colors.blue[200]),
        _buildPetCategory(PetCategory.HAMSTER, Colors.orange[200]),
        _buildPetCategory(PetCategory.OTHER, Colors.green[200]),
      ],
    );
  }

  Widget _buildPetCategory(PetCategory category, Color color) {
    return Expanded(
      child: Opacity(
        opacity: category == _petCategory ? 1 : .3,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _petCategory = category;
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
                          (category == PetCategory.HAMSTER
                              ? "hamster"
                              : category == PetCategory.CAT
                                  ? "cat"
                                  : category == PetCategory.OTHER
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
                    category == PetCategory.HAMSTER
                        ? "Hamsters"
                        : category == PetCategory.CAT
                            ? "Cats"
                            : category == PetCategory.OTHER
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
      height: 49,
      child: InputDecorator(
        decoration: const InputDecoration(
            hintText: "Gender",
            isDense: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
            ),
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            labelText: 'Gender'),
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

  Future<Pet> _indatePet({bool isUpdate = false}) async {
    print('start posting...............');
    try {
      token = await getStringValue('token');
      print('start upload iamges...............');
      String uploadedImageUrl;
      if (!isUpdate || imageFile != null)
        uploadedImageUrl = await uploadImages();
      print('End upload iamges...............');
      Response response;
      Pet newPet;
      if (isUpdate) {
        widget.pet.name = _nameController.text;
        widget.pet.bio = _bioController.text;
        widget.pet.gender = _selectedgender;
        widget.pet.birhday = _petBrithday;
        widget.pet.address = petAddress;
        widget.pet.color = _colorController.text;
        widget.pet.avatar = uploadedImageUrl ?? widget.pet.avatar;
        widget.pet.weight = _weightController.text.isNotEmpty
            ? double.parse(_weightController.text)
            : null;
        widget.pet.breed = _breedController.text;
        newPet = widget.pet;
      } else
        newPet = new Pet(
            id: widget.pet != null ? widget.pet.id : null,
            category: _petCategory,
            avatar: uploadedImageUrl,
            name: _nameController.text,
            bio: _bioController.text,
            gender: _selectedgender,
            birhday: _petBrithday,
            address: petAddress,
            color:
                _colorController.text.isNotEmpty ? _colorController.text : null,
            weight: _weightController.text.isNotEmpty
                ? double.parse(_weightController.text)
                : null,
            breed: _breedController.text.isNotEmpty
                ? _breedController.text
                : null);
      final data = newPet.toJson();

      print("DATA: " + data.toString());

      Dio dio = new Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Bearer $token";
      if (isUpdate)
        response = await dio.put(Apis.editPet, data: data);
      else
        response = await dio.post(Apis.createPet, data: data);
      if (response.statusCode == 200 && isUpdate) {
        return Pet.fromJson(response.data);
      } else if (!isUpdate)
        return newPet;
      else
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
      return responseString.replaceAll('"', '');
    } else
      return '';
  }

  bool validateForm() {
    return (_nameController.text.isNotEmpty &&
        _petCategory != null &&
        _bioController.text.isNotEmpty &&
        _selectedgender != null &&
        _birthdayController.text.isNotEmpty &&
        petAddress != null &&
        imageFile != null);
  }

  _onSubmit() async {
    if (widget.pet != null) {
      EasyLoading.show(status: 'Updating...', dismissOnTap: true);
      Pet newPet = await _indatePet(isUpdate: true);
      if (newPet != null) {
        showToast('Update successfully!');
        if (widget.onUpdated != null) widget.onUpdated(newPet);
        Navigator.of(context).pop('edited');
      } else
        showError('Update Failed! Please try again.');
    } else {
      if (validateForm()) {
        EasyLoading.show(status: 'Loading...', dismissOnTap: true);
        Pet newPet = await _indatePet();
        if (newPet != null) {
          showToast('Your pet is create successfully!');
          if (widget.onCreated != null) widget.onCreated(newPet);
          Navigator.of(context).pop();
        } else
          showError('Create Failed! Please try again.');
      } else {
        showError(
            'Some field is required. Please fill all of them before submit!');
      }
    }
  }
}
