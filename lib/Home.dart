import 'package:denario/Home_Desk.dart';
import 'package:denario/Home_Mobile.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 650) {
          return HomeDesk();
        } else {
          return HomeMobile();
        }
      },
    );
  }
}