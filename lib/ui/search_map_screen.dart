import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_finder/core/apis.dart';
import 'package:pet_finder/core/models/posts_list.dart';
import 'package:pet_finder/ui/post_detail.dart';
import 'package:pet_finder/ui/widgets/post_map_widget.dart';
import 'package:pet_finder/core/models/post.dart';
import 'package:pet_finder/utils.dart';
import 'package:http/http.dart' as http;
import 'package:pet_finder/core/services/my_location.dart';

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
    '2 kilometers',
    '3 kilometers',
    '4 kilometers',
    '5 kilometers',
    '10 kilometers',
    '20 kilometers',
  ];

  static LatLng _initialPosition = LatLng(10.873286, 106.7914436);

  double _radius = 1000;
  bool _isLoaded = false;
  List<Post> _posts;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _currentRadius = _radiuses[0];
    checkPermision();
  }

  void _getUserLocation() async {
    if (MyLocation().haveData) {
      _initialPosition = LatLng(MyLocation().lat, MyLocation().long);
    } else {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _initialPosition = LatLng(position.latitude, position.longitude);
    }

    setState(() {
      _isLoaded = true;
    });
    _moveCameraToUserLocation();
    _setCircles();
    _searchPosts();
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
    } else {
      _getUserLocation();
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
                if (_isLoaded) _buildContainer(),
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
        child: _posts != null
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _posts.length,
                itemBuilder: (BuildContext context, int index) =>
                    PostMapWidget(post: _posts[index], index: index),
              )
            : _error
                ? Center(child: Text('Error.'))
                : Center(
                    child: Container(),
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
                          });
                          _setCircles();
                          _searchPosts();
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

  void _searchPosts() async {
    String token = await getStringValue('token');
    // int categoryId = getCategoryId(widget.category);
    String radiusInt = _currentRadius.substring(
      0,
      _currentRadius.indexOf(' '),
    );
    Map<String, String> queryParams;
    if (_initialPosition != null)
      queryParams = {
        'Lat': _initialPosition.latitude?.toString() ?? '',
        'Lon': _initialPosition.longitude?.toString() ?? '',
        'Radius': radiusInt,
      };
    String queryString = (queryParams != null)
        ? '?' + Uri(queryParameters: queryParams).query
        : '';
    try {
      http.Response response = await http.get(
        Apis.getPostUrl + queryString,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ).timeout(Duration(seconds: 30));
      print('url:  ' + Apis.getPostUrl + queryString);
      print('_searchPosts:  ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        PostsList postsList = PostsList.fromJson(parsedJson);

        postsList.posts.sort((a, b) => (a.distance.compareTo(b.distance)));

        _allMarkers.clear();
        await _drawMarker(postsList.posts);
        setState(() {
          _posts = postsList.posts;
        });
      } else if (response.statusCode == 500) {
        _onError();
        showError('Server error, please try again latter.');
      }
    } on TimeoutException catch (e) {
      _onError();
      showError(e.toString());
    } on SocketException catch (e) {
      _onError();
      showError(e.toString());
    }
  }

  void _onError() {
    if (!_error)
      setState(() {
        _error = true;
      });
  }

  void _removeError() {
    setState(() {
      _error = false;
    });
  }

  Future<void> _drawMarker(List<Post> posts) async {
    _allMarkers.clear();
    for (Post post in posts) {
      BitmapDescriptor icon = await _getCustomIcon(
          Apis.baseURL + post?.imageUrls[0].trim(), post.pet.name);

      double lat;
      double long;
      if (post.pet.address.lat != null && post.pet.address.long != null) {
        lat = post.pet.address.lat;
        long = post.pet.address.long;
      } else {
        List<String> spliter = post.pet.address.addressName.split(';');
        lat = double.parse(spliter[0]);
        double.parse(spliter[1]);
      }
      _allMarkers.add(
        new Marker(
          markerId: MarkerId(post.id.toString()),
          icon: icon,
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
            title: post.pet.name,
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          PostDetail(post, from: "mapMarker_")));
            },
          ),
        ),
      );
    }
  }

  Future<BitmapDescriptor> _getCustomIcon(String url, String petName) async {
    Size size = Size(150.0, 150.0);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(50);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // // Add tag text
    // TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    // textPainter.text = TextSpan(
    //   text: '1',
    //   style: TextStyle(fontSize: 20.0, color: Colors.white),
    // );
    // textPainter.layout();
    // textPainter.paint(
    //     canvas,
    //     Offset(size.width - tagWidth / 2 - textPainter.width / 2,
    //         tagWidth / 2 - textPainter.height / 2));

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
    final Uint8List imageBytes = await markerImageFile.readAsBytes();

    final ui.Codec imageCodec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();

    ui.Image image = frameInfo.image;
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }
}
