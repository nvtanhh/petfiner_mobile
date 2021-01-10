import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/pet_detail.dart';
import 'package:pet_finder/ui/pets_manager.dart';

class MyPetsWrapper extends StatelessWidget {
  const MyPetsWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Pet> _myPets = getPetList().sublist(0, 3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            children: [
              Text(
                'Pets',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => PetsManager())));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 80,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _myPets.length,
            itemBuilder: (BuildContext context, int index) => _myPetWidget(
                context, _myPets[index],
                last: index == _myPets.length - 1),
          ),
        )
      ],
    );
  }

  _myPetWidget(BuildContext context, Pet pet, {bool last}) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetDetail(pet)),
        );
      },
      child: Container(
        width: size.width * 0.6,
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        margin: EdgeInsets.only(right: !last ? 16 : 0, top: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(pet.avatar),
              radius: 25,
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    pet.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  "Alaska",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
