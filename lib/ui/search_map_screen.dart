import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_finder/ui/widgets/pet_map_widget.dart';
import '../data.dart';

class MapSearcher extends StatefulWidget {
  MapSearcher({Key key}) : super(key: key);

  @override
  _MapSearcherState createState() => _MapSearcherState();
}

class _MapSearcherState extends State<MapSearcher> {
  Set<Marker> _markers = HashSet<Marker>();
  Set<Circle> _circles = HashSet<Circle>();
  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  static LatLng _initialPosition = LatLng(10.873286, 106.7914436);

  List<Pet> pets = getPetList();

  double _radius = 5000;

  @override
  void initState() {
    super.initState();
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

    _setCircles();
  }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  void checkPermision() async {
    if (!await Permission.location.status.isGranted) {
      await Permission.location.request();
    }
  }

  void _setCircles() {
    _circles.add(
      Circle(
          circleId: CircleId("0"),
          center: _initialPosition,
          radius: _radius,
          strokeWidth: 1,
          strokeColor: Colors.blue,
          fillColor: Colors.blue[200].withOpacity(.4)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
          zoom: 14.4746,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        zoomControlsEnabled: false,
        padding: EdgeInsets.only(top: 100),
        circles: _circles,
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: pets.length,
          itemBuilder: (BuildContext context, int index) =>
              PetMapWidget(pet: pets[index], index: index),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
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
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 38,
              child: TextField(
                decoration: InputDecoration(
                  isDense: true, // Added this
                  hintText: 'Search',

                  hintStyle: TextStyle(fontSize: 18, color: Colors.white54),
                  // border: InputBorder.none,
                  border: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white54)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
