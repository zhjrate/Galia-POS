import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
          child: Center(
        child: SpinKitSpinningCircle(
          color: Colors.blueGrey.shade900,
          size: 30.0,
        ),
      )),
    );
  }
}
