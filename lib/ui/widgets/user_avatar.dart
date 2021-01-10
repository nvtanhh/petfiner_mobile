import 'package:flutter/material.dart';
import 'package:pet_finder/core/models/user.dart';
import 'package:pet_finder/ui/profile_screen.dart';

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        var profileScreen = ProfileScreen(user: User.empty());
        return profileScreen;
      })),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            width: 3,
            color: Colors.white,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/user_avatar.jpg"),
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
      ),
    );
  }
}
