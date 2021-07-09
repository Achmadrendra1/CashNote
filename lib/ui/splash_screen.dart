import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uas_rendra/theme.dart';
import 'package:uas_rendra/ui/home.dart';

class SplashPage extends StatefulWidget {
  // const SplashPage({ Key? key }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 170,
              height: 170,
              child: Image.asset('assets/images/logo.png'),
            ),
            Text(
              'CASHNOTE',
              style: whiteText.copyWith(fontSize: 48),
            )
          ],
        ),
      ),
    );
  }
}
