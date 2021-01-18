import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_finder/app_them.dart';
import 'package:pet_finder/ui/bottom_navigator.dart';
import 'package:pet_finder/ui/root_page.dart';
import 'package:pet_finder/app_push.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppTheme.primaryColor,
        accentColor: AppTheme.accentColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: AppPushs(child: RootPage()),
      builder: EasyLoading.init(),
    );
  }
}
