import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Home_Desk.dart';
import 'package:denario/Home_Mobile.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/DailyCash.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<CashRegister>.value(
            initialData: null, value: DatabaseService().cashRegisterStatus),
        StreamProvider<HighLevelMapping>.value(
            initialData: null, value: DatabaseService().highLevelMapping())
      ],
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
