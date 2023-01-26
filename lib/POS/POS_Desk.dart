import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/PendingOrders.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:denario/Models/Tables.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/POS/CounterViewDesktop.dart';
import 'package:denario/POS/OrderAlert.dart';
import 'package:denario/POS/PlateSelection_Desktop.dart';
import 'package:denario/POS/TablesViewDesk.dart';
import 'package:denario/POS/TicketView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class POSDesk extends StatefulWidget {
  final String firstCategory;
  POSDesk({this.firstCategory});

  @override
  _POSDeskState createState() => _POSDeskState();
}

class _POSDeskState extends State<POSDesk> {
  String category;
  List categories;

  int businessIndex;
  bool showTableView; //config at user profile

  //Mostrar mesas o mostrar pendientes de delivery/takeaway
  List tableViewTags = ['Mesas', 'Mostrador'];
  String selectedTag;

  final tableController = PageController();

  @override
  void initState() {
    category = widget.firstCategory;
    selectedTag = 'Mesas';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryList>(context);
    final userProfile = Provider.of<UserData>(context);
    final pendingOrders = Provider.of<List<PendingOrders>>(context);

    if (categoriesProvider == null ||
        userProfile == null ||
        pendingOrders == null) {
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
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, i) {
                            return TextButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                minimumSize: Size(50, 50),
                              ),
                              onPressed: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Center(),
                              ),
                            );
                          }),
                    ),
                    Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 15,
                        endIndent: 15),
                    //Plates GridView
                    Expanded(
                        child: Container(
                            child: GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width > 1100) ? 5 : 3,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 1,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: 12,
                      itemBuilder: (context, i) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade300),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.black12;
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed))
                                  return Colors.black26;
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {},
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                          ),
                        );
                      },
                    )))
                  ],
                ),
              ),
            ),
            //Ticket View
            Container(
                height: double.infinity,
                width: MediaQuery.of(context).size.width * 0.25,
                constraints: BoxConstraints(minWidth: 300),
                decoration:
                    BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[200],
                    offset: new Offset(-15.0, 15.0),
                    blurRadius: 10.0,
                  )
                ]),
                child: Container())
          ],
        ),
      );
    }

    //Logic to get table view config for POS View

    userProfile.businesses.forEach((element) {
      if (element.businessID == userProfile.activeBusiness) {
        businessIndex = userProfile.businesses.indexOf(element);
      }
    });

    if (userProfile.businesses[businessIndex].tableView) {
      categories = categoriesProvider.categoryList;
      return MultiProvider(
        providers: [
          StreamProvider<List<Tables>>.value(
            initialData: [],
            value: DatabaseService().tableList(userProfile.activeBusiness),
          ),
          StreamProvider<List<Products>>.value(
              initialData: [],
              value: DatabaseService()
                  .productList(category, userProfile.activeBusiness)),
          StreamProvider<List<SavedOrders>>.value(
              initialData: null,
              value: DatabaseService()
                  .savedCounterOrders(userProfile.activeBusiness)),
        ],
        child: Stack(
          children: [
            //POS
            Container(
              height: double.infinity,
              width: double.infinity,
              child: PageView(
                controller: tableController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  //Tables
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        //Tag selection (mesas o mostrador)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Tag selection
                            Container(
                              height: 50,
                              width: 500,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tableViewTags.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        width: 200,
                                        child: TextButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: (selectedTag ==
                                                    tableViewTags[i])
                                                ? Colors.black
                                                : Colors.transparent,
                                            minimumSize: Size(50, 50),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              selectedTag = tableViewTags[i];
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: Center(
                                              child: Text(
                                                tableViewTags[i],
                                                style: TextStyle(
                                                    color: (selectedTag ==
                                                            tableViewTags[i])
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Spacer(),
                            //Change to product view
                            Container(
                              height: 50,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  DatabaseService().deleteUserBusiness({
                                    'Business ID': userProfile
                                        .businesses[businessIndex].businessID,
                                    'Business Name': userProfile
                                        .businesses[businessIndex].businessName,
                                    'Business Rol': userProfile
                                        .businesses[businessIndex]
                                        .roleInBusiness,
                                    'Table View': userProfile
                                        .businesses[businessIndex].tableView
                                  }, userProfile.uid).then((value) {
                                    DatabaseService()
                                        .updateUserBusinessProfile({
                                      'Business ID': userProfile
                                          .businesses[businessIndex].businessID,
                                      'Business Name': userProfile
                                          .businesses[businessIndex]
                                          .businessName,
                                      'Business Rol': userProfile
                                          .businesses[businessIndex]
                                          .roleInBusiness,
                                      'Table View': false
                                    }, userProfile.uid);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.visibility, size: 16),
                                        SizedBox(width: 10),
                                        Text('Productos')
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 15,
                            endIndent: 15),
                        //Tables GridView
                        Expanded(
                            child: Container(
                                child: (selectedTag == 'Mesas')
                                    ? TablesViewDesktop(
                                        userProfile.activeBusiness,
                                        tableController)
                                    : CounterViewDesktop(
                                        userProfile.activeBusiness,
                                        tableController))),
                      ],
                    ),
                  ),

                  //Inside Table
                  StreamBuilder(
                      stream: bloc.getStream,
                      initialData: bloc.ticketItems,
                      builder: (context, snapshot) {
                        var subTotal = snapshot.data["Subtotal"];
                        var tax = snapshot.data["IVA"];
                        var discount = snapshot.data["Discount"];
                        var total = snapshot.data["Total"];
                        var orderName = snapshot.data["Order Name"];
                        var color = snapshot.data["Color"];

                        for (var i = 0;
                            i < bloc.ticketItems['Items'].length;
                            i++) {
                          subTotal += bloc.ticketItems['Items'][i]["Price"] *
                              bloc.ticketItems['Items'][i]["Quantity"];
                        }
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
                                      Row(
                                        children: [
                                          IconButton(
                                              tooltip: 'Volver',
                                              splashRadius: 15,
                                              hoverColor: Colors.grey[300],
                                              onPressed: () {
                                                //Si es venta de mostrador
                                                if (snapshot
                                                    .data["Counter Order"]) {
                                                  //Si ya estaba guardada
                                                  if (snapshot
                                                      .data["Open Table"]) {
                                                    if (bloc
                                                            .ticketItems[
                                                                'Items']
                                                            .length <
                                                        1) {
                                                      DatabaseService()
                                                          .deleteOrder(
                                                        userProfile
                                                            .activeBusiness,
                                                        bloc.ticketItems[
                                                            'Order ID'],
                                                      );
                                                    } else {
                                                      DatabaseService()
                                                          .saveOrder(
                                                        userProfile
                                                            .activeBusiness,
                                                        bloc.ticketItems[
                                                            'Order ID'],
                                                        subTotal,
                                                        discount,
                                                        tax,
                                                        total,
                                                        snapshot.data["Items"],
                                                        orderName,
                                                        '',
                                                        color.value,
                                                        false,
                                                        snapshot
                                                            .data["Order Type"],
                                                        {
                                                          'Name': snapshot.data[
                                                              'Client']['Name'],
                                                          'Address':
                                                              snapshot.data[
                                                                      'Client']
                                                                  ['Address'],
                                                          'Phone':
                                                              snapshot.data[
                                                                      'Client']
                                                                  ['Phone'],
                                                          'email': snapshot
                                                                  .data[
                                                              'Client']['email']
                                                        },
                                                      );
                                                    }
                                                  } else if (!snapshot
                                                          .data["Open Table"] &&
                                                      bloc.ticketItems['Items']
                                                              .length >
                                                          0) {
                                                    DatabaseService().saveOrder(
                                                      userProfile
                                                          .activeBusiness,
                                                      DateTime.now().toString(),
                                                      subTotal,
                                                      discount,
                                                      tax,
                                                      total,
                                                      snapshot.data["Items"],
                                                      orderName,
                                                      '',
                                                      Colors
                                                          .primaries[Random()
                                                              .nextInt(Colors
                                                                  .primaries
                                                                  .length)]
                                                          .value,
                                                      false,
                                                      snapshot
                                                          .data["Order Type"],
                                                      {
                                                        'Name': snapshot
                                                                .data['Client']
                                                            ['Name'],
                                                        'Address': snapshot
                                                                .data['Client']
                                                            ['Address'],
                                                        'Phone': snapshot
                                                                .data['Client']
                                                            ['Phone'],
                                                        'email': snapshot
                                                                .data['Client']
                                                            ['email']
                                                      },
                                                    );
                                                  }
                                                } else if (!snapshot.data[
                                                        "Counter Order"] &&
                                                    snapshot
                                                        .data["Open Table"]) {
                                                  if (bloc.ticketItems['Items']
                                                          .length <
                                                      1) {
                                                    DatabaseService()
                                                        .updateTable(
                                                      userProfile
                                                          .activeBusiness,
                                                      orderName,
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                      [],
                                                      '',
                                                      Colors.white.value,
                                                      false,
                                                      {
                                                        'Name': '',
                                                        'Address': '',
                                                        'Phone': 0,
                                                        'email': '',
                                                      },
                                                    );
                                                    DatabaseService()
                                                        .deleteOrder(
                                                      userProfile
                                                          .activeBusiness,
                                                      bloc.ticketItems[
                                                          'Order ID'],
                                                    );
                                                  } else {
                                                    DatabaseService()
                                                        .updateTable(
                                                      userProfile
                                                          .activeBusiness,
                                                      orderName,
                                                      subTotal,
                                                      discount,
                                                      tax,
                                                      total,
                                                      snapshot.data["Items"],
                                                      '',
                                                      Colors.greenAccent.value,
                                                      true,
                                                      {
                                                        'Name': snapshot
                                                                .data['Client']
                                                            ['Name'],
                                                        'Address': snapshot
                                                                .data['Client']
                                                            ['Address'],
                                                        'Phone': snapshot
                                                                .data['Client']
                                                            ['Phone'],
                                                        'email': snapshot
                                                                .data['Client']
                                                            ['email']
                                                      },
                                                    );
                                                    DatabaseService().saveOrder(
                                                      userProfile
                                                          .activeBusiness,
                                                      bloc.ticketItems[
                                                          'Order ID'],
                                                      subTotal,
                                                      discount,
                                                      tax,
                                                      total,
                                                      snapshot.data["Items"],
                                                      orderName,
                                                      '',
                                                      color.value,
                                                      true,
                                                      'Table Order',
                                                      {
                                                        'Name': snapshot
                                                                .data['Client']
                                                            ['Name'],
                                                        'Address': snapshot
                                                                .data['Client']
                                                            ['Address'],
                                                        'Phone': snapshot
                                                                .data['Client']
                                                            ['Phone'],
                                                        'email': snapshot
                                                                .data['Client']
                                                            ['email']
                                                      },
                                                    );
                                                  }
                                                } else if (!snapshot.data[
                                                        "Counter Order"] &&
                                                    !snapshot
                                                        .data["Open Table"] &&
                                                    bloc.ticketItems['Items']
                                                            .length >
                                                        0) {
                                                  DatabaseService().updateTable(
                                                    userProfile.activeBusiness,
                                                    orderName,
                                                    subTotal,
                                                    discount,
                                                    tax,
                                                    total,
                                                    snapshot.data["Items"],
                                                    '',
                                                    Colors.greenAccent.value,
                                                    true,
                                                    {
                                                      'Name': snapshot
                                                              .data['Client']
                                                          ['Name'],
                                                      'Address': snapshot
                                                              .data['Client']
                                                          ['Address'],
                                                      'Phone': snapshot
                                                              .data['Client']
                                                          ['Phone'],
                                                      'email': snapshot
                                                              .data['Client']
                                                          ['email']
                                                    },
                                                  );
                                                  DatabaseService().saveOrder(
                                                    userProfile.activeBusiness,
                                                    'Mesa ' + orderName,
                                                    subTotal,
                                                    discount,
                                                    tax,
                                                    total,
                                                    snapshot.data["Items"],
                                                    orderName,
                                                    '',
                                                    Colors.greenAccent.value,
                                                    true,
                                                    'Mesa',
                                                    {
                                                      'Name': snapshot
                                                              .data['Client']
                                                          ['Name'],
                                                      'Address': snapshot
                                                              .data['Client']
                                                          ['Address'],
                                                      'Phone': snapshot
                                                              .data['Client']
                                                          ['Phone'],
                                                      'email': snapshot
                                                              .data['Client']
                                                          ['email']
                                                    },
                                                  );
                                                }

                                                tableController.animateToPage(0,
                                                    duration: Duration(
                                                        milliseconds: 250),
                                                    curve: Curves.easeIn);
                                              },
                                              icon: Icon(Icons.arrow_back,
                                                  color: Colors.black)),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: categories.length,
                                                  itemBuilder: (context, i) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: TextButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.black,
                                                          backgroundColor:
                                                              (category ==
                                                                      categories[
                                                                          i])
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .transparent,
                                                          minimumSize:
                                                              Size(50, 50),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            category =
                                                                categories[i];
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      5.0),
                                                          child: Center(
                                                            child: Text(
                                                              categories[i],
                                                              style: TextStyle(
                                                                  color: (category ==
                                                                          categories[
                                                                              i])
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                          color: Colors.grey,
                                          thickness: 0.5,
                                          indent: 15,
                                          endIndent: 15),
                                      //Plates GridView
                                      Expanded(
                                          child: PlateSelectionDesktop(
                                              userProfile.activeBusiness,
                                              category)),
                                    ],
                                  ),
                                ),
                              ),
                              // //Ticket View
                              Container(
                                  height: double.infinity,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                                  child: TicketView(
                                      userProfile,
                                      businessIndex,
                                      (selectedTag == 'Mesas') ? true : false,
                                      tableController,
                                      (selectedTag == 'Mesas') ? false : true,
                                      userProfile
                                          .businesses[businessIndex].tableView))
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
            //Order Alert
            (pendingOrders.length > 0)
                ? OrderAlert(pendingOrders, userProfile.activeBusiness)
                : Container()
          ],
        ),
      );
    } else {
      categories = categoriesProvider.categoryList;

      return StreamProvider<List<Tables>>.value(
          initialData: [],
          value: DatabaseService().tableList(userProfile.activeBusiness),
          child: Stack(
            children: [
              //POS
              Container(
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
                            Row(
                              children: [
                                //categories
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categories.length,
                                        itemBuilder: (context, i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: TextButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    (category == categories[i])
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5.0),
                                                child: Center(
                                                  child: Text(
                                                    categories[i],
                                                    style: TextStyle(
                                                        color: (category ==
                                                                categories[i])
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                //Switch view
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    height: 50,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        DatabaseService().deleteUserBusiness({
                                          'Business ID': userProfile
                                              .businesses[businessIndex]
                                              .businessID,
                                          'Business Name': userProfile
                                              .businesses[businessIndex]
                                              .businessName,
                                          'Business Rol': userProfile
                                              .businesses[businessIndex]
                                              .roleInBusiness,
                                          'Table View': userProfile
                                              .businesses[businessIndex]
                                              .tableView
                                        }, userProfile.uid).then((value) {
                                          DatabaseService()
                                              .updateUserBusinessProfile({
                                            'Business ID': userProfile
                                                .businesses[businessIndex]
                                                .businessID,
                                            'Business Name': userProfile
                                                .businesses[businessIndex]
                                                .businessName,
                                            'Business Rol': userProfile
                                                .businesses[businessIndex]
                                                .roleInBusiness,
                                            'Table View': true
                                          }, userProfile.uid);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.visibility, size: 16),
                                              SizedBox(width: 10),
                                              Text('Mesas')
                                            ]),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                                indent: 15,
                                endIndent: 15),
                            //Plates GridView
                            Expanded(
                                child: Container(
                                    child: StreamProvider<List<Products>>.value(
                                        initialData: [],
                                        value: DatabaseService().productList(
                                            category,
                                            userProfile.activeBusiness),
                                        child: PlateSelectionDesktop(
                                            userProfile.activeBusiness,
                                            category)))),
                          ],
                        ),
                      ),
                    ),
                    //Ticket View
                    Container(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width * 0.25,
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
                        child: TicketView(
                            userProfile,
                            businessIndex,
                            false,
                            tableController,
                            false,
                            userProfile.businesses[businessIndex].tableView))
                  ],
                ),
              ),
              //Order Alert
              (pendingOrders.length > 0)
                  ? OrderAlert(pendingOrders, userProfile.activeBusiness)
                  : Container()
            ],
          ));
    }
  }
}
