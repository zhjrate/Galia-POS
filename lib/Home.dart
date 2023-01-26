import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Home_Desk.dart';
import 'package:denario/Home_Mobile.dart';
import 'package:denario/Loading.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:denario/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models/DailyCash.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<UserBusinessData> userBusiness;
  int businessIndex;
  var activeBusinessField = '';
  var activeBusinessRol;

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserData>(context);

    if (userProfile == null || userProfile.businesses.isEmpty) {
      return Loading();
    }

    //Logic to get business role and field for Home View
    // userBusiness = userProfile.businesses;
    // userBusiness.forEach((element) {
    //   if (element.businessID == userProfile.activeBusiness) {
    //     businessIndex = userBusiness.indexOf(element);
    //   }
    // });
    // activeBusinessRol = userBusiness[businessIndex].roleInBusiness;

    final businessIndexOnProfile = userProfile.businesses.indexWhere(
        (element) => element.businessID == userProfile.activeBusiness);

    if (businessIndexOnProfile == -1) {
      return Loading();
    }

    return MultiProvider(
      providers: [
        StreamProvider<CashRegister>.value(
            initialData: null,
            value: DatabaseService()
                .cashRegisterStatus(userProfile.activeBusiness)),
        StreamProvider<BusinessProfile>.value(
            initialData: null,
            value: DatabaseService()
                .userBusinessProfile(userProfile.activeBusiness)),
        StreamProvider<HighLevelMapping>.value(
            initialData: null,
            value:
                DatabaseService().highLevelMapping(userProfile.activeBusiness)),
        StreamProvider<CategoryList>.value(
            initialData: null,
            value:
                DatabaseService().categoriesList(userProfile.activeBusiness)),
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
