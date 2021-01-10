import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/create_post.dart';
import 'package:pet_finder/ui/widgets/pet_widget_small.dart';

class ChoosePet extends StatelessWidget {
  const ChoosePet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Choose Your pet",
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    List<Pet> _myPets = getPetList().sublist(0, 3);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Text(
              'Which Pet your create a new post for?',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: _myPets.length,
              itemBuilder: (context, index) {
                return _petItem(_myPets[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _petItem(Pet pet, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreatePost(pet)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(pet.avatar),
              radius: 40,
            ),
            SizedBox(
              height: 12,
            ),
            Flexible(
              child: Text(
                pet.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  child: pet.gender == 'male'
                      ? Image.asset(
                          'assets/icons/male.png',
                          color: Colors.blue,
                        )
                      : Image.asset(
                          'assets/icons/female.png',
                          color: Colors.pink,
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Alaska",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
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
