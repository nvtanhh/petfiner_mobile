import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/utils.dart';
import 'package:pet_finder/ui/pet_indate.dart';
import 'package:pet_finder/ui/widgets/pet_widget_small.dart';
import 'package:http/http.dart' as http;

class PetsManager extends StatefulWidget {
  final List<Pet> pets;

  Function updatedPet;
  PetsManager(this.pets, {Key key, this.updatedPet}) : super(key: key);

  @override
  _PetsManagerState createState() => _PetsManagerState();
}

class _PetsManagerState extends State<PetsManager> {
  List<Pet> myPets;
  @override
  void initState() {
    super.initState();
    myPets = widget.pets;
  }

  @override
  void dispose() {
    if (widget.updatedPet != null) widget.updatedPet();
    super.dispose();
  }

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
        if (widget.pets != null)
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
                  showAsColumn: true,
                  onDelete: () => _showDeleteDialog(context, index)),
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
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => PetAddUpdate(onCreated: (Pet pet) {
                      setState(() {
                        myPets.add(pet);
                      });
                      if (widget.updatedPet != null) widget.updatedPet();
                    })));
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

  _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text("Delete confirm."),
          content: Text(
            "Are you sure to delete your Pet?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black54),
          ),
          actions: <Widget>[
            ButtonTheme(
              //minWidth: double.infinity,
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
                color: Colors.grey[400],
                textColor: const Color(0xffffffff),
              ),
            ),
            ButtonTheme(
              child: RaisedButton(
                elevation: 3.0,
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (await _deletePet(widget.pets[index])) {
                    setState(() {
                      myPets.removeAt(index);
                    });
                    EasyLoading.showToast("Deleted!",
                        duration: new Duration(seconds: 1));
                  } else
                    showError("Delete pet failed. Please try again latter");
                },
                child: Text('Delete'),
                color: Theme.of(context).primaryColor,
                textColor: const Color(0xffffffff),
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool> _deletePet(Pet pet) async {
    String token = await getStringValue('token');
    final http.Response response = await http.delete(
      Apis.deletePet + pet.id.toString(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    print('_deletePost:  ' + response.statusCode.toString());

    return response.statusCode == 200;
  }
}
