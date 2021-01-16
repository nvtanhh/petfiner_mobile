import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/ui/profile_screen.dart';
import 'package:pet_finder/ui/pet_detail.dart';
import 'package:pet_finder/utils.dart';

class PostDetail extends StatefulWidget {
  final Post post;

  final String from;

  PostDetail(this.post, {this.from});

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  int currentTabImage = 1;
  final String _defaultPostImage = 'assets/images/sample/post.jpg';

  @override
  Widget build(BuildContext context) {
    Pet pet = widget.post.pet;
    String tagPrefix = widget.from ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.more_horiz,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                widget.post.imageUrls.isNotEmpty
                    ? PageView.builder(
                        onPageChanged: onPageChanged,
                        itemCount: widget.post.imageUrls.length,
                        itemBuilder: (context, index) => index == 0
                            ? Hero(
                                tag: tagPrefix +
                                    widget.post.id.toString() +
                                    widget.post.imageUrls[index],
                                child: _buildImage(index: index),
                              )
                            : _buildImage(index: index),
                      )
                    : Hero(
                        tag: tagPrefix + 'iamgeUrl' + widget.post.id.toString(),
                        child: _buildImage(),
                      ),
                if (widget.post.imageUrls.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15, right: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[300].withOpacity(.6),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        currentTabImage.toString() +
                            " / " +
                            widget.post.imageUrls.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15, left: 15),
                    decoration: BoxDecoration(
                      color: widget.post.conditionText() == "Adoption"
                          ? Colors.orange[100]
                          : widget.post.conditionText() == "Disappear"
                              ? Colors.red[100]
                              : Colors.blue[100],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      widget.post.conditionText(),
                      style: TextStyle(
                        color: widget.post.conditionText() == "Adoption"
                            ? Colors.orange
                            : widget.post.conditionText() == "Disappear"
                                ? Colors.red
                                : Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (_) => PetDetail(pet))),
                            child: Text(
                              pet.name,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              FutureBuilder(
                                future: getAdress(pet.address.address),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data,
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  } else
                                    return Container();
                                },
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                widget?.post?.distance != null
                                    ? "(" +
                                        widget.post.distance
                                            .toStringAsFixed(2) +
                                        " km)"
                                    : '',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.post.isFavorite
                              ? Colors.red[400]
                              : Colors.white,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 24,
                          color: widget.post.isFavorite
                              ? Colors.white
                              : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      buildPetFeature(
                          pet.age != null
                              ? pet.age.toString()
                              : 'Uknow' + " months",
                          "Months"),
                      buildPetFeature(
                          pet.color != null ? pet.color.toString() : 'Uknow',
                          "Color"),
                      buildPetFeature(
                          pet.weight != null
                              ? pet.weight.toString() + ' Kg'
                              : 'Uknow',
                          "Weight"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Content",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: !widget.post.content.contains('<')
                      ? Text(
                          widget.post.content ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        )
                      : Html(
                          data: widget.post.content ?? '',
                        ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileScreen(user: pet?.owner)));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            children: [
                              // UserAvatar(pet?.owner?.avatar ?? ''),
                              CircleAvatar(
                                backgroundColor: Colors.blue[200],
                                radius: 30,
                                backgroundImage: pet.owner.avatar == null
                                    ? AssetImage(
                                        'assets/images/user_avatar.jpg')
                                    : CachedNetworkImageProvider(
                                        Apis.avatarDirUrl + pet.owner.avatar),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Posted by",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      pet?.owner?.name ?? 'Unknow',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue[300].withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                          color: Colors.blue[300],
                        ),
                        child: Text(
                          "Contact Me",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
    );
  }

  buildPetFeature(String value, String feature) {
    return Expanded(
      child: Container(
        height: 70,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[200],
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              feature,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage({int index}) {
    String imageUrl = index == null
        ? _defaultPostImage
        : Apis.baseUrlOnline + widget.post.imageUrls[index];
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (widget.post.imageUrls == null &&
                  widget.post.imageUrls.length == 0)
              ? AssetImage(_defaultPostImage)
              : CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      currentTabImage = value + 1;
    });
  }
}
