import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/user.dart';
import 'package:pet_finder/ui/profile_screen.dart';

class UserAvatar extends StatelessWidget {
  final String avatar;

  UserAvatar(this.avatar);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          width: 3,
          color: Colors.white,
        ),
        image: DecorationImage(
          image: this.avatar.isEmpty
              ? AssetImage('assets/images/sample/avt.jpg')
              : CachedNetworkImageProvider(
                  Apis.avatarDirUrl + this.avatar,
                ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
