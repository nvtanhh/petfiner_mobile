import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/ui/post_detail.dart';
import 'package:pet_finder/ui/widgets/post_widget.dart';

class PostAndAblumWrapper extends StatefulWidget {
  PostAndAblumWrapper({Key key}) : super(key: key);

  @override
  _PostAndAblumWrapperState createState() => _PostAndAblumWrapperState();
}

class _PostAndAblumWrapperState extends State<PostAndAblumWrapper> {
  List<Post> posts = getPostList();
  Color _gridColor = Colors.blue;
  Color _listColor = Colors.grey;
  bool _isGridActive = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.grid_on,
                    color: _gridColor,
                    size: 22,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isGridActive = true;
                    _gridColor = Colors.blue;
                    _listColor = Colors.grey;
                  });
                },
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.stay_current_portrait,
                    color: _listColor,
                    size: 22,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isGridActive = false;
                    _listColor = Colors.blue;
                    _gridColor = Colors.grey;
                  });
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Divider(),
        ),
        postImagesWidget(),
      ],
    );
  }

  Widget postImagesWidget() {
    return _isGridActive == true ? _showAsGrid() : _showAsPost();
  }

  Widget _showAsPost() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, left: 16, right: 16),
      scrollDirection: Axis.vertical,
      itemCount: posts.length,
      itemBuilder: (context, index) => Container(
        height: 300,
        child: PostWidget(post: posts[index], showAsColumn: true),
      ),
    );
  }

  Widget _showAsGrid() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
      itemBuilder: (context, index) => GestureDetector(
        child: Hero(
          tag: posts[index].imageUrls[0],
          child: Image.asset(
            posts[index].imageUrls[0],
            width: 125.0,
            height: 125.0,
            fit: BoxFit.cover,
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PostDetail(post: posts[index]))));
        },
      ),
    );
  }
}

class PostView extends StatelessWidget {
  final Post post;
  final int index;
  final bool showAsColumn;

  const PostView({
    Key key,
    @required this.post,
    this.index = -1,
    this.showAsColumn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pet pet = post.pet;

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => PostDetail(post: post))));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
        ),
        margin: EdgeInsets.only(
            right: !showAsColumn && index != null ? 16 : 0,
            left: !showAsColumn && index == 0 ? 16 : 0,
            bottom: 16),
        // width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: post.imageUrls[0],
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(post.imageUrls[0]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: post.pet.favorite
                                ? Colors.red[400]
                                : Colors.white,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color:
                                pet.favorite ? Colors.white : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: post.postCategory == PostCategory.Adoption
                          ? Colors.orange[100]
                          : post.postCategory == PostCategory.Disappear
                              ? Colors.red[100]
                              : Colors.blue[100],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      post.conditionText(),
                      style: TextStyle(
                        color: post.postCategory == PostCategory.Adoption
                            ? Colors.orange
                            : post.postCategory == PostCategory.Disappear
                                ? Colors.red
                                : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: showAsColumn ? 12 : 8,
                  ),
                  Text(
                    pet.name,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: showAsColumn ? 12 : 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        pet.location,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          "(" + pet.distance + "km)",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
