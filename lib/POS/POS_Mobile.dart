import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/POS/PlateSelection_Mobile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class POSMobile extends StatefulWidget {
  @override
  _POSMobileState createState() => _POSMobileState();
}

class _POSMobileState extends State<POSMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKeyMobile =
      GlobalKey<ScaffoldState>();

  String category = 'Café';
  List categories = ['Promos', 'Café', 'Postres', 'Panadería', 'Sandwich y Ensaladas', 'Bebidas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyMobile,
      endDrawer: Drawer(
        //Ticket View
        child: Container(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, children: []))),
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
                itemBuilder: (context, i){
                  return  FlatButton(
                    hoverColor: Colors.grey[350],
                    height: 50,
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
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  );
                }
              )                            
            ),
            Divider(
                color: Colors.grey, thickness: 0.5, indent: 15, endIndent: 15),
            //Plates GridView
            Container(
                child: StreamProvider<List<Products>>.value(
                    value: DatabaseService().productList(category),
                    child: PlateSelectionMobile())),
          ],
        ),
      ),
    );
  }
}
