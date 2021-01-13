import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/ui/post_detail.dart';

class PostMapWidget extends StatelessWidget {
  final Post post;
  final int index;

  PostMapWidget({@required this.post, @required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetail(post: post)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        margin: EdgeInsets.only(
            right: index != null ? 16 : 0,
            left: index == 0 ? 16 : 0,
            bottom: 16),
        width: size.width * 0.75,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Stack(
                children: [
                  Hero(
                    tag: post.imageUrls[0],
                    child: Container(
                      // height: 150,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(post.imageUrls[0]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: post.pet.favorite
                                ? Colors.red[400]
                                : Colors.white,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color: post.pet.favorite
                                ? Colors.white
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      height: 8,
                    ),
                    Text(
                      post.pet.name,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.grey[600],
                            size: 16,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Flexible(
                          child: Text(
                            post.pet.location,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      " (" + post.pet.distance + "km)",
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                      ),
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
}
