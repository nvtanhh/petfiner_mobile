import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/create_new_pet.dart';
import 'package:pet_finder/ui/widgets/pet_widget_small.dart';

class PetsManager extends StatefulWidget {
  PetsManager({Key key}) : super(key: key);

  @override
  _PetsManagerState createState() => _PetsManagerState();
}

class _PetsManagerState extends State<PetsManager> {
  List<Pet> _myPets = getPetList().sublist(0, 3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //   color: Colors.black, //change your color here
        // ),
        automaticallyImplyLeading: true,
        title: Text(
          'Pet Management',
          // style: const TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.white,
      ),
      body: ListView(physics: BouncingScrollPhysics(), children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _myPets.length,
          padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
            height: 120,
            margin: EdgeInsets.only(bottom: 15),
            child: PetWidget(
                key: ObjectKey(_myPets[index]),
                pet: _myPets[index],
                showAsColumn: true),
          ),
        ),
        SizedBox(height: 10),
        _buidAddNewButton()
      ]),
    );
  }

  Widget _buidAddNewButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => CreateNewPet()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Add new pet.",
            style: TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }
}
