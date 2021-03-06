import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_finder/core/models/pet.dart';
import 'package:pet_finder/core/services/my_location.dart';
import 'package:pet_finder/ui/choose_pet_create_post.dart';
import 'package:pet_finder/ui/home_screen.dart';
import 'package:pet_finder/ui/notify_screen.dart';
import 'package:pet_finder/ui/profile_screen.dart';
import 'package:pet_finder/ui/search_screen.dart';
import 'package:pet_finder/ui/widgets/jumping_widget.dart';

class MyNavigator extends StatefulWidget {
  @override
  _MyNavigatorState createState() => _MyNavigatorState();
}

class _MyNavigatorState extends State<MyNavigator>
    with SingleTickerProviderStateMixin {
  // List<Pet> pets = getPetList();
  List<Widget> bodies;

  // final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0,
        1,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );

    final tab1 = HomeScreen(key: Key('tab1'));
    final tab2 = SearchScreen(key: Key('tab2'));
    final tab3 = NotifyScreen(key: Key('tab3'));
    final tab4 = ProfileScreen(key: Key('tab4'));
    bodies = [tab1, tab2, tab3, tab4];
  }

  Future<bool> checkPermision() async {
    if (!await Permission.location.status.isGranted) {
      PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        return await checkPermision();
      } else
        return false;
    } else {
      if (!MyLocation().haveData) await _getCurrentLocation();
      return true;
    }
  }

  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    Position _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    MyLocation()
        .resetLocation(_currentPosition.latitude, _currentPosition.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkPermision(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              resizeToAvoidBottomPadding: true,
              backgroundColor: Colors.white,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: ScaleTransition(
                scale: animation,
                child: FloatingActionButton(
                  elevation: 8,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _animationController.reset();
                    _animationController.forward();

                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => ChoosePet())));
                  },
                ),
              ),
              bottomNavigationBar: AnimatedBottomNavigationBar(
                icons: iconList,
                iconSize: 28,
                inactiveColor: Colors.grey[500],
                activeColor: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).primaryColor,
                activeIndex: _bottomNavIndex,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.defaultEdge,
                onTap: (index) => setState(() => _bottomNavIndex = index),
                //other params
              ),
              body: IndexedStack(
                index: _bottomNavIndex,
                children: bodies,
              ));
        } else
          return _placeHoderWidget();
      },
    );
  }

  Widget _placeHoderWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          JumpingWidget(Icon(
            Icons.location_on,
            size: 30,
            color: Colors.blue,
          )),
          Text('Loading your location...')
        ],
      ),
    );
  }
}
