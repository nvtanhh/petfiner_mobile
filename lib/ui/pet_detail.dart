import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';

import 'package:pet_finder/ui/pest_indate.dart';

class PetDetail extends StatelessWidget {
  final Pet pet;

  const PetDetail(this.pet, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            pet.name,
            style: TextStyle(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PetAddUpdate(pet: pet)),
                  );
                })
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 25, 10),
              child: _buildPetInfo(),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("More infomation",
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 5),
                  Text(pet.bio ?? 'Empty',
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

  Widget _buildPetInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: pet?.avatar == null
              ? AssetImage('assets/images/sample/animal.png')
              : CachedNetworkImageProvider(
                  Apis.avatarDirUrl + pet.avatar,
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
                      pet.name ?? 'Uknow',
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
                    child: pet.gender == 'Male'
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
                pet.breed ?? 'Uknow breed',
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
                    pet.age != null
                        ? pet.age.toString() + " months"
                        : 'Uknow age',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
