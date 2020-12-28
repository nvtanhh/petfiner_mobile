import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocalIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  final Color bgColor;

  const SocalIcon({
    Key key,
    this.iconSrc,
    this.press,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          boxShadow: [
            new BoxShadow(
              color: bgColor.withOpacity(.3),
              blurRadius: 2, // soften the shadow
              spreadRadius: 1,
              offset: new Offset(1, 1),
            )
          ],
        ),
        child: SvgPicture.asset(
          iconSrc,
          color: Colors.white,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
