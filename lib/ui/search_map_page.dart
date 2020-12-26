import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_finder/ui/widgets/pet_map_widget.dart';
import 'package:pet_finder/ui/widgets/pet_widget.dart';

import '../data.dart';

class MapSearcher extends StatefulWidget {
  MapSearcher({Key key}) : super(key: key);

  @override
  _MapSearcherState createState() => _MapSearcherState();
}

class _MapSearcherState extends State<MapSearcher> {
  Set<Marker> _markers = HashSet<Marker>();
  Set<Polygon> _polygons = HashSet<Polygon>();
  Set<Polyline> _polylines = HashSet<Polyline>();
  Set<Circle> _circles = HashSet<Circle>();
  bool _showMapStyle = false;

  GoogleMapController _mapController;
  BitmapDescriptor _markerIcon;

  List<Pet> pets = getPetList();

  @override
  void initState() {
    super.initState();
    // _setMarkerIcon();
    // _setPolygons();
    // _setPolylines();
    // _setCircles();
  }

  void _setMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/noodle_icon.png');
  }

  void _toggleMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');

    if (_showMapStyle) {
      _mapController.setMapStyle(style);
    } else {
      _mapController.setMapStyle(null);
    }
  }

  void _setPolygons() {
    List<LatLng> polygonLatLongs = List<LatLng>();
    polygonLatLongs.add(LatLng(37.78493, -122.42932));
    polygonLatLongs.add(LatLng(37.78693, -122.41942));
    polygonLatLongs.add(LatLng(37.78923, -122.41542));
    polygonLatLongs.add(LatLng(37.78923, -122.42582));

    _polygons.add(
      Polygon(
        polygonId: PolygonId("0"),
        points: polygonLatLongs,
        fillColor: Colors.white,
        strokeWidth: 1,
      ),
    );
  }

  void _setPolylines() {
    List<LatLng> polylineLatLongs = List<LatLng>();
    polylineLatLongs.add(LatLng(37.74493, -122.42932));
    polylineLatLongs.add(LatLng(37.74693, -122.41942));
    polylineLatLongs.add(LatLng(37.74923, -122.41542));
    polylineLatLongs.add(LatLng(37.74923, -122.42582));

    _polylines.add(
      Polyline(
        polylineId: PolylineId("0"),
        points: polylineLatLongs,
        color: Colors.purple,
        width: 1,
      ),
    );
  }

  void _setCircles() {
    _circles.add(
      Circle(
          circleId: CircleId("0"),
          center: LatLng(37.76493, -122.42432),
          radius: 1000,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(102, 51, 153, .5)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // setState(() {
    //   _markers.add(
    //     Marker(
    //         markerId: MarkerId("0"),
    //         position: LatLng(37.77483, -122.41942),
    //         infoWindow: InfoWindow(
    //           title: "San Francsico",
    //           snippet: "An Interesting city",
    //         ),
    //         icon: _markerIcon),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Find pet by location')),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
          _buildContainer(),
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
          target: LatLng(10.873286, 106.7914436),
          zoom: 17,
        ),
        markers: _markers,
        polygons: _polygons,
        polylines: _polylines,
        circles: _circles,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
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
}
