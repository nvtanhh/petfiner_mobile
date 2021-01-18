import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/ui/post_detail.dart';
import 'package:pet_finder/utils.dart';

class PostWidget extends StatelessWidget {
  final Post post;
  final int index;

  final bool showAsColumn;

  final String from;

  ValueChanged<Post> onDelete;

  PostWidget(
      {Key key,
      @required this.post,
      this.index,
      this.showAsColumn = false,
      this.from,
      this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Pet pet = post.pet;
    String tagPrefix = from ?? '';
    return GestureDetector(
      onTap: () async {
        String mess = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetail(post, from: from)),
        );

        if (mess != 'delete') {
          onDelete(post);
        }
      },
      child: Container(
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
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: post.imageUrls.isNotEmpty
                        ? tagPrefix + post.id.toString() + post.imageUrls[0]
                        : tagPrefix + 'iamgeUrl' + post.id.toString(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (post.imageUrls == null ||
                                  post.imageUrls.length == 0)
                              ? AssetImage('assets/images/sample/animal.png')
                              : CachedNetworkImageProvider(
                                  Apis.baseURL + post.imageUrls[0],
                                ),
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
                            color:
                                post.isLiked ? Colors.red[400] : Colors.white,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 16,
                            color:
                                post.isLiked ? Colors.white : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!showAsColumn)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: _buildPostCategory(),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(showAsColumn ? 16 : 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showAsColumn) _buildPostCategory(),
                  SizedBox(
                    height: showAsColumn ? 12 : 8,
                  ),
                  Text(
                    pet.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: showAsColumn ? 18 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(
                  //   height: showAsColumn ? 12 : 8,
                  // ),
                  if (showAsColumn)
                    Padding(
                      padding: EdgeInsets.only(top: showAsColumn ? 12 : 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          FutureBuilder(
                            future: getAdress(post.pet.address.address),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Flexible(
                                  child: Text(
                                    snapshot.data,
                                    // overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              } else
                                return Container();
                            },
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Flexible(
                            child: Text(
                              post.distance != null
                                  ? "(" +
                                      post.distance.toStringAsFixed(2) +
                                      " km)"
                                  : '',
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
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildPostCategory() {
    return Container(
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
    );
  }
}
