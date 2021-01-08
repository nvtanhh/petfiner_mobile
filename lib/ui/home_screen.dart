import 'package:flutter/material.dart';
import 'package:pet_finder/ui/widgets/post_widget.dart';

import '../core/models/post.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> pets = getPostList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                        child: PostWidget(
                          key: ObjectKey(pets[index]),
                          post: pets[index],
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
  }
}
