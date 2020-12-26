import 'package:flutter/material.dart';
import 'package:pet_finder/ui/widgets/pet_widget.dart';

import '../data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pet> pets = getPetList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Icon(
            Icons.sort,
            color: Colors.grey[800],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.message_outlined,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // head line
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Hey Tanh!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Let us be a friend.",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                  ),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: pets.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  height: 300,
                  margin: EdgeInsets.only(bottom: 20),
                  child: PetWidget(
                    pet: pets[index],
                    index: index,
                    showAsColumn: true,
                  ),
                ),
                // itemBuilder: (BuildContext context, int index) =>
                //     Text('akjsdhsad index ' + index.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
