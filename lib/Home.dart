import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Home_Desk.dart';
import 'package:denario/Home_Mobile.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<HighLevelMapping>.value(
      value: DatabaseService().highLevelMapping(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 650) {
            return HomeDesk();
          } else {
            return HomeMobile();
          }
        },
      ),
    );
  }
}
