import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/POS/PlateSelection_Desktop.dart';
import 'package:denario/POS/TicketView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class POSDesk extends StatefulWidget {

  @override
  _POSDeskState createState() => _POSDeskState();
}

class _POSDeskState extends State<POSDesk> {
  
  String category = 'Café';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Plate Selection
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //Category selection
                  MediaQuery.of(context).size.width < 950                  
                  ? Column(children: [
                      //1st row
                      Row(children: [
                        //Promos
                        FlatButton(
                          hoverColor: Colors.grey[350],
                          height: 50,
                          onPressed: () {
                          setState(() {
                            category = 'Promos';
                          });
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: Text('Promos',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        //Cafe
                        FlatButton(
                          hoverColor: Colors.grey[350],
                          height: 50,
                          onPressed: () {
                          setState(() {
                            category = 'Café';
                          });
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: Text('Café',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        //Postres
                        FlatButton(
                          hoverColor: Colors.grey[350],
                          height: 50,
                          onPressed: () {
                          setState(() {
                            category = 'Postres';
                          });
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: Text('Postres',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),                        
                        //Pan
                        FlatButton(
                          hoverColor: Colors.grey[350],
                          height: 50,
                          onPressed: () {
                          setState(() {
                            category = 'Panadería';
                          });
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: Text('Pan',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),                        
                      ],),
                      //2nd row
                      Row(children: [
                        //Platos
                        FlatButton(
                          hoverColor: Colors.grey[350],
                          height: 50,
                          onPressed: () {
                          setState(() {
                            category = 'Sandwich y Ensaladas';
                          });
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: Text('Platos',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        //Bebidas
                        FlatButton(
                          hoverColor: Colors.grey[350],
                          height: 50,
                          onPressed: () {
                          setState(() {
                            category = 'Bebidas';
                          });
                        },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: Text('Bebidas',
                                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),                        
                      ],)
                  ],)
                  : Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(children: [
                      //Promos
                      FlatButton(
                        hoverColor: Colors.grey[350],
                        height: 50,
                        onPressed: () {
                          setState(() {
                            category = 'Promos';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: Text('Promos',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      //Cafe
                      FlatButton(
                        hoverColor: Colors.grey[350],
                        height: 50,
                        onPressed: () {
                          setState(() {
                            category = 'Café';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: Text('Café',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      //Postres
                      FlatButton(
                        hoverColor: Colors.grey[350],
                        height: 50,
                        onPressed: () {
                          setState(() {
                            category = 'Postres';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: Text('Postres',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      //Pan
                      FlatButton(
                        hoverColor: Colors.grey[350],
                        height: 50,
                        onPressed: () {
                          setState(() {
                            category = 'Panadería';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: Text('Pan',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      //Platos
                      FlatButton(
                        hoverColor: Colors.grey[350],
                        height: 50,
                        onPressed: () {
                          setState(() {
                            category = 'Sandwich y Ensaladas';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: Text('Platos',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                      //Bebidas
                      FlatButton(
                        hoverColor: Colors.grey[350],
                        height: 50,
                        onPressed: () {
                          setState(() {
                            category = 'Bebidas';
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Center(
                            child: Text('Bebidas',
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    
                    ],),
                  ),
                  Divider(color: Colors.grey, thickness: 0.5, indent: 15, endIndent: 15),
                  //Plates GridView
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      child: StreamProvider<List<Products>>.value(
                        value: DatabaseService().productList(category),
                        child: PlateSelectionDesktop()))),
                ],
              ),
            ),
          ),
          //Ticket View
          Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width*0.25,
              constraints: BoxConstraints(minWidth: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[200],
                    offset: new Offset(-15.0, 15.0),
                    blurRadius: 10.0,
                  )
                ]),
              child: TicketView())
        ],
      ),
    );
  }
}
