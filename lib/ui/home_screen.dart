import 'package:flutter/material.dart';
import 'package:pet_finder/ui/widgets/pet_widget.dart';

import '../data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pet> pets = getPetList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // head line
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
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
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: pets.length,
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        height: 300,
                        margin: EdgeInsets.only(bottom: 20),
                        child: PetWidget(
                          key: ObjectKey(pets[index]),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 0, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.red,
            margin: EdgeInsets.only(left: 16),
            child: Image.asset('assets/images/text_art.png',
                height: 30, fit: BoxFit.fitHeight),
          ),
          Icon(
            Icons.message_outlined,
            color: Colors.grey[800],
          )
        ],
      ),
    );

    //         AppBar(
    //   brightness: Brightness.light,
    //   backgroundColor: Colors.transparent,
    //   elevation: 0,
    //   leading: Container(
    //     margin: EdgeInsets.only(left: 16),
    //     child: Image.asset('assets/images/text_art.png',
    //         height: 56, width: 200, fit: BoxFit.fill),
    //   ),
    //   actions: [
    //     Padding(
    //       padding: EdgeInsets.only(right: 16),
    //       child: Icon(
    //         Icons.message_outlined,
    //         color: Colors.grey[800],
    //       ),
    //     ),
    //   ],
    // )
  }
}
