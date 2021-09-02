import 'dart:async';

import 'package:denario/Wrapper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => Wrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Center(
            child: Container(
          height: 150,
          child: Image(
            image: AssetImage('images/Denario Tag.png'),
            fit: BoxFit.fitHeight,
          ),
        )),
      ),
    );
  }
}
