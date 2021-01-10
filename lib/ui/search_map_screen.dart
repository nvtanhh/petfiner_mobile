import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_finder/ui/widgets/post_map_widget.dart';
import 'package:pet_finder/core/models/post.dart';

class MapSearcher extends StatefulWidget {
  MapSearcher({Key key}) : super(key: key);

  @override
  _MapSearcherState createState() => _MapSearcherState();
}

class _MapSearcherState extends State<MapSearcher> {
  Set<Marker> _allMarkers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  GoogleMapController _mapController;
  String _currentRadius;
  List<String> _radiuses = [
    '1 kilometer',
    '2 kilometer',
    '3 kilometer',
    '4 kilometer',
    '5 kilometer',
    '10 kilometer',
  ];

  static LatLng _initialPosition = LatLng(10.873286, 106.7914436);

  List<Post> posts = getPostList();

  double _radius = 1000;

  @override
  void initState() {
    super.initState();
    _currentRadius = _radiuses[0];
    checkPermision();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });

    _moveCameraToUserLocation();
    _setCircles();
  }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }
  void _moveCameraToUserLocation({double zoom}) {
    if (_mapController != null) {
      if (zoom == null)
        _mapController.animateCamera(CameraUpdate.newLatLng(_initialPosition));
      else
        _mapController
            .animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, zoom));
    }
  }

  void checkPermision() async {
    if (!await Permission.location.status.isGranted) {
      await Permission.location.request();
    }
  }

  void _setCircles() {
    _circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: _radius,
          center: _initialPosition,
          strokeWidth: 1,
          strokeColor: Colors.blue[200],
          fillColor: Colors.blue[100].withOpacity(.4),
          onTap: () {
            print('circle pressed');
          })
    ]);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.moveCamera(CameraUpdate.newLatLng(_initialPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: <Widget>[
                _googleMap(context),
                _buildSearchBar(),
                _buildContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: getZoomLevel(_radius),
        ),
        markers: _allMarkers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
        padding: EdgeInsets.only(top: 100),
        circles: _circles,
        scrollGesturesEnabled: true,
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: true,
      ),
    );
  }

  double getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    zoomLevel = num.parse(zoomLevel.toStringAsFixed(2));
    _moveCameraToUserLocation(zoom: zoomLevel);
    return zoomLevel;
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) =>
              PostMapWidget(post: posts[index], index: index),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          SizedBox(width: 20),
          Expanded(
            child: Row(
              children: [
                Text(
                  'Radius: ',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 38,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.white,
                        isExpanded: true,
                        // hint: Text("Please choose a radius"),
                        value: _currentRadius,
                        selectedItemBuilder: (_) {
                          return _radiuses
                              .map((String value) =>
                                  new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 15),
                                    ),
                                  ))
                              .toList();
                        },
                        items: _radiuses
                            .map((String value) => new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value,
                                      style: TextStyle(color: Colors.black87)),
                                ))
                            .toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _currentRadius = newVal;
                            _radius = double.parse(_currentRadius.substring(
                                  0,
                                  _currentRadius.indexOf(' '),
                                ) +
                                '000');
                            print("NEW RADIUS: " + _radius.toString());
                            _setCircles();
                          });
                        },
                      ),
                    ),
                    // child: TextField(
                    //   decoration: InputDecoration(
                    //     isDense: true, // Added this
                    //     hintText: 'Search',

                    //     hintStyle: TextStyle(fontSize: 18, color: Colors.white54),
                    //     // border: InputBorder.none,
                    //     border: new UnderlineInputBorder(
                    //         borderSide: new BorderSide(color: Colors.white54)),
                    //     enabledBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.white54),
                    //     ),
                    //     focusedBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.white54),
                    //     ),
                    //     filled: true,
                    //     fillColor: Colors.transparent,
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
