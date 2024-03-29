import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/POS/PlateSelection_Mobile.dart';
import 'package:denario/POS/TicketView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class POSMobile extends StatefulWidget {
  @override
  _POSMobileState createState() => _POSMobileState();
}

class _POSMobileState extends State<POSMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKeyMobile =
      GlobalKey<ScaffoldState>();

  String category;
  int businessIndex;

  @override
  void initState() {
    category = 'Café';
    super.initState();
  }

  List categories = [
    'Promos',
    'Café',
    'Postres',
    'Panadería',
    'Platos',
    'Bebidas'
  ];

  @override
  Widget build(BuildContext context) {
    //final categoriesProvider = Provider.of<CategoryList>(context);
    final userProfile = Provider.of<UserData>(context);

    userProfile.businesses.forEach((element) {
      if (element.businessID == userProfile.activeBusiness) {
        businessIndex = userProfile.businesses.indexOf(element);
      }
    });

    return Scaffold(
      key: _scaffoldKeyMobile,
      endDrawer: Drawer(
        //Ticket View
        child: Container(
            color: Colors.white,
            child: TicketView(userProfile, businessIndex, false, null, false, false)),
      ),
      floatingActionButton: InkWell(
          onTap: () => _scaffoldKeyMobile.currentState.openEndDrawer(),
          child: Container(
            height: 50,
            width: 50,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: Center(
                child: Icon(Icons.format_list_bulleted, color: Colors.white)),
          )),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            //Category selection
            Container(
                width: double.infinity,
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                      return TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (category == categories[i])
                              ? Colors.black
                              : Colors.transparent,
                          minimumSize: Size(50, 50),
                        ),
                        onPressed: () {
                          setState(() {
                            category = categories[i];
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: Text(
                              categories[i],
                              style: TextStyle(
                                  color: (category == categories[i])
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      );
                    })),
            Divider(
                color: Colors.grey, thickness: 0.5, indent: 15, endIndent: 15),
            //Plates GridView
            Container(
                height: 400,
                child: StreamProvider<List<Products>>.value(
                    initialData: null,
                    value: DatabaseService()
                        .productList(category, userProfile.activeBusiness),
                    child: PlateSelectionMobile())),
          ],
        ),
      ),
    );
  }
}
