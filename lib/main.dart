import 'package:flutter/material.dart';
import 'package:uas_rendra/theme.dart';
import 'package:uas_rendra/ui/home.dart';
import 'package:uas_rendra/ui/splash_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
