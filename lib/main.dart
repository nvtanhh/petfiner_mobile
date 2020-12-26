import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_finder/ui/bottom_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final MaterialColor primary = const MaterialColor(0xFF395AD2, {
  //   50: Color.fromRGBO(57, 90, 210, .1),
  //   100: Color.fromRGBO(57, 90, 210, .2),
  //   200: Color.fromRGBO(57, 90, 210, .3),
  //   300: Color.fromRGBO(57, 90, 210, .4),
  //   400: Color.fromRGBO(57, 90, 210, .5),
  //   500: Color.fromRGBO(57, 90, 210, .6),
  //   600: Color.fromRGBO(57, 90, 210, .7),
  //   700: Color.fromRGBO(57, 90, 210, .8),
  //   800: Color.fromRGBO(57, 90, 210, .9),
  //   900: Color.fromRGBO(57, 90, 210, 1),
  // });
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Navigation(),
    );
  }
}
