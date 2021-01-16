import 'package:flutter/material.dart';

class JumpingWidget extends StatefulWidget {
  final Widget child;

  const JumpingWidget(this.child, {Key key}) : super(key: key);

  @override
  _JumpingWidgetState createState() => _JumpingWidgetState();
}

class _JumpingWidgetState extends State<JumpingWidget>
    with TickerProviderStateMixin {
  AnimationController _animationControllers;
  Animation<double> _animate;
  int animationDuration = 200;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    _animationControllers.dispose();
    super.dispose();
  }

  _initAnimation() {
    _animationControllers =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..repeat(reverse: true);

    _animate = Tween<double>(begin: 0, end: -15).animate(_animationControllers);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animate,
        child: widget.child,
        builder: (BuildContext context, Widget child) {
          return Transform.translate(
              offset: Offset(0, _animate.value), child: child);
        },
      ),
    );
  }
}
