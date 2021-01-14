import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/pest_indate.dart';
import 'package:pet_finder/ui/widgets/pet_widget_small.dart';

class PetsManager extends StatefulWidget {
  List<Pet> pets;
  PetsManager(this.pets, {Key key}) : super(key: key);

  @override
  _PetsManagerState createState() => _PetsManagerState();
}

class _PetsManagerState extends State<PetsManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Pet Management',
        ),
      ),
      body: ListView(physics: BouncingScrollPhysics(), children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.pets.length,
          padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
            height: 130,
            margin: EdgeInsets.only(bottom: 15),
            child: PetWidget(
                key: ObjectKey(widget.pets[index]),
                pet: widget.pets[index],
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
            new MaterialPageRoute(builder: (context) => PetAddUpdate()));
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
