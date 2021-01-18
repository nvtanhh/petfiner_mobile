import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';

import 'package:pet_finder/ui/pet_indate.dart';
import 'package:pet_finder/utils.dart';

class PetDetail extends StatefulWidget {
  final Pet pet;

  const PetDetail(this.pet, {Key key}) : super(key: key);

  @override
  _PetDetailState createState() => _PetDetailState();
}

class _PetDetailState extends State<PetDetail> {
  Pet pet;

  @override
  void initState() {
    super.initState();
    pet = widget.pet;
  }

  Future<bool> _checkIsMyPet() async {
    String storedUserId = await getStringValue('loggedUserId');
    bool rs =
        storedUserId != null && int.parse(storedUserId) == widget.pet.owner.id;
    return rs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            widget.pet.name,
            style: TextStyle(),
          ),
          centerTitle: true,
          actions: [
            FutureBuilder(
                future: _checkIsMyPet(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData && snapshot.data)
                    return IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PetAddUpdate(
                                    pet: widget.pet, onUpdated: onUpdate)),
                          );
                        });
                  else
                    return Container(width: 0, height: 0);
                })
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 25, 10),
              child: _buildPetInfo(),
            ),
            FutureBuilder(
              future: _checkIsMyPet(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData && !snapshot.data)
                  return GestureDetector(
                    onTap: () async {
                      if (await likePet(widget.pet.id)) {
                        setState(() {
                          pet.isFollowed = !pet.isFollowed;
                        });
                      } else {
                        showError('Error, Please try again!');
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            !pet.isFollowed ? Colors.blue : Colors.transparent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        border: Border.all(
                          width: 1,
                          color:
                              pet.isFollowed ? Colors.grey[300] : Colors.blue,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          !pet.isFollowed ? 'Follow' : 'Unfollow',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: !pet.isFollowed
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  );
                else
                  return Container(width: 0, height: 0);
              },
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  buildPetFeature(
                      widget.pet.age != null
                          ? widget.pet.age.toString()
                          : 'Uknow' + " months",
                      "Months"),
                  buildPetFeature(
                      widget.pet.color != null
                          ? widget.pet.color.toString()
                          : 'Uknow',
                      "Color"),
                  buildPetFeature(
                      widget.pet.weight != null
                          ? widget.pet.weight.toString() + ' Kg'
                          : 'Uknow',
                      "Weight"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("More infomation",
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 5),
                  Text(widget.pet.bio ?? 'Empty',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.grey[700])),
                ],
              ),
            )
          ],
        ));
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

  Widget _buildPetInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: widget.pet?.avatar == null
              ? AssetImage('assets/images/sample/animal.png')
              : CachedNetworkImageProvider(
                  Apis.avatarDirUrl + widget.pet.avatar,
                ),
          radius: 50,
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.pet.name ?? 'Unknow',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Container(
                    width: 18,
                    height: 18,
                    child: widget.pet.gender == 'Male'
                        ? Image.asset(
                            'assets/icons/male.png',
                            color: Colors.blue,
                          )
                        : Image.asset(
                            'assets/icons/female.png',
                            color: Colors.pink,
                          ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                widget.pet.breed ?? 'Uknow breed',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Icon(
                    Icons.timelapse_outlined,
                    size: 12,
                    color: Colors.grey[700],
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    widget.pet.age != null
                        ? widget.pet.age.toString() + " months"
                        : 'Uknow age',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onUpdate(Pet value) {
    setState(() {
      pet = value;
    });
  }
}
