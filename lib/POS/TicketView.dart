import 'dart:math';

//import 'package:denario/Backend/AFIPInvoicing.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/Models/Tables.dart';
import 'package:denario/Models/User.dart';
//import 'package:denario/Models/Stats.dart';
import 'package:denario/POS/ActiveOrders.dart';
import 'package:denario/POS/ConfirmOrder.dart';
import 'package:denario/POS/ConfirmWastage.dart';
// import 'package:denario/POS/ConfirmOrder.dart';
// import 'package:denario/POS/ConfirmStats.dart';
// import 'package:denario/POS/ConfirmWastage.dart';
import 'package:denario/POS/MoreTicketPopUp.dart';
import 'package:denario/POS/SelectTableDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TicketView extends StatefulWidget {
  final UserData userProfile;
  final int businessIndex;
  final bool insideTable;
  final bool counterSale;
  final PageController tableController;
  final bool onTableView;
  TicketView(this.userProfile, this.businessIndex, this.insideTable,
      this.tableController, this.counterSale, this.onTableView);
  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  String orderName;
  var _orderNamecontroller = TextEditingController();

  var orderDetail;
  Map<String, dynamic> orderCategories;
  Map currentValues;
  double subTotal;
  double tax;
  double discount;
  double total;
  Color color = Colors.white;
  String ticketConcept;
  IconData ticketIcon = Icons.assignment_outlined;

  @override
  void initState() {
    _orderNamecontroller = new TextEditingController(
        text: (bloc.ticketItems['Order Name'] != '')
            ? bloc.ticketItems['Order Name']
            : '');
    orderName = 'Sin Agregar';
    subTotal = 0;
    tax = 0;
    discount = 0;
    total = 0;

    super.initState();
  }

  void clearVariables() {
    bloc.removeAllFromCart();
    _orderNamecontroller.clear();

    setState(() {
      ticketConcept = 'Mostrador';
      discount = 0;
      tax = 0;
      ticketIcon = Icons.assignment_outlined;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryList>(context);
    final registerStatus = Provider.of<CashRegister>(context);
    final tables = Provider.of<List<Tables>>(context);

    if (categoriesProvider == null || tables == null) {
      return Container();
    }

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    if (widget.insideTable) {
      return StreamBuilder(
          stream: bloc.getStream,
          initialData: bloc.ticketItems,
          builder: (context, snapshot) {
            subTotal = snapshot.data["Subtotal"];
            tax = snapshot.data["IVA"];
            discount = snapshot.data["Discount"];
            total = snapshot.data["Total"];
            orderName = snapshot.data["Order Name"];
            color = snapshot.data["Color"];

            for (var i = 0; i < bloc.ticketItems['Items'].length; i++) {
              subTotal += bloc.ticketItems['Items'][i]["Price"] *
                  bloc.ticketItems['Items'][i]["Quantity"];
            }

            total = (subTotal + ((subTotal * tax).round())) - discount;

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Table
                      Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //Table
                              Text(
                                'Mesa ' + orderName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              //Go back to salon
                              Spacer(),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(12.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.greenAccent),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered))
                                        return Colors.greenAccent[100];
                                      if (states.contains(
                                              MaterialState.focused) ||
                                          states
                                              .contains(MaterialState.pressed))
                                        return Colors.green;
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  //If table was open, update
                                  if (snapshot.data["Open Table"]) {
                                    if (bloc.ticketItems['Items'].length < 1) {
                                      DatabaseService().updateTable(
                                        widget.userProfile.activeBusiness,
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
                                      DatabaseService().deleteOrder(
                                        widget.userProfile.activeBusiness,
                                        bloc.ticketItems['Order ID'],
                                      );
                                    } else {
                                      DatabaseService().updateTable(
                                        widget.userProfile.activeBusiness,
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
                                          'Name': snapshot.data["Client"]
                                              ['Name'],
                                          'Address': snapshot.data["Client"]
                                              ['Address'],
                                          'Phone': snapshot.data["Client"]
                                              ['Phone'],
                                          'email': snapshot.data["Client"]
                                              ['email'],
                                        },
                                      );
                                      DatabaseService().saveOrder(
                                        widget.userProfile.activeBusiness,
                                        bloc.ticketItems['Order ID'],
                                        subTotal,
                                        discount,
                                        tax,
                                        total,
                                        snapshot.data["Items"],
                                        orderName,
                                        '',
                                        (color == Colors.white)
                                            ? Colors.greenAccent.value
                                            : color.value,
                                        true,
                                        'Mesa',
                                        {
                                          'Name': snapshot.data["Client"]
                                              ['Name'],
                                          'Address': snapshot.data["Client"]
                                              ['Address'],
                                          'Phone': snapshot.data["Client"]
                                              ['Phone'],
                                          'email': snapshot.data["Client"]
                                              ['email'],
                                        },
                                      );
                                    }
                                  } else if (!snapshot.data["Open Table"] &&
                                      bloc.ticketItems['Items'].length > 0) {
                                    //If table was not open, open table, save to table doc and Saved collection
                                    DatabaseService().updateTable(
                                      widget.userProfile.activeBusiness,
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
                                        'Name': snapshot.data["Client"]['Name'],
                                        'Address': snapshot.data["Client"]
                                            ['Address'],
                                        'Phone': snapshot.data["Client"]
                                            ['Phone'],
                                        'email': snapshot.data["Client"]
                                            ['email'],
                                      },
                                    );
                                    DatabaseService().saveOrder(
                                      widget.userProfile.activeBusiness,
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
                                        'Name': snapshot.data["Client"]['Name'],
                                        'Address': snapshot.data["Client"]
                                            ['Address'],
                                        'Phone': snapshot.data["Client"]
                                            ['Phone'],
                                        'email': snapshot.data["Client"]
                                            ['email'],
                                      },
                                    );
                                  }
                                  widget.tableController
                                      .animateToPage(0,
                                          duration: Duration(milliseconds: 250),
                                          curve: Curves.easeIn)
                                      .then((value) => clearVariables());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Volver a Mesas",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 3),
                      Divider(thickness: 0.5, indent: 0, endIndent: 0),
                      SizedBox(height: 5),
                      //List of Products
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 5),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data["Items"].length,
                              itemBuilder: (context, i) {
                                final cartList = snapshot.data["Items"];
                                orderDetail = cartList;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //Column Name + Qty
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //Name
                                            Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 150),
                                              child: Text(cartList[i]['Name']),
                                            ),
                                            //Options
                                            (snapshot
                                                    .data["Items"][i]['Options']
                                                    .isEmpty)
                                                ? SizedBox()
                                                // : SizedBox(),
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Container(
                                                      child: Text(
                                                          cartList[i]['Options']
                                                              .join(', '),
                                                          maxLines: 6,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12)),
                                                    ),
                                                  ),

                                            //Quantity
                                            Row(
                                              children: [
                                                //Remove
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      bloc.removeQuantity(i);
                                                    });
                                                  },
                                                  icon: Icon(Icons
                                                      .remove_circle_outline),
                                                  iconSize: 16,
                                                ),
                                                Text(
                                                    '${cartList[i]['Quantity']}'),
                                                //Add
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      bloc.addQuantity(i);
                                                    });
                                                  },
                                                  icon: Icon(
                                                      Icons.add_circle_outline),
                                                  iconSize: 16,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        //Amount
                                        Spacer(),
                                        Text(formatCurrency.format(
                                            cartList[i]['Total Price'])),
                                        SizedBox(width: 10),
                                        //Delete
                                        IconButton(
                                            onPressed: () => bloc
                                                .removeFromCart(cartList[i]),
                                            icon: Icon(Icons.close),
                                            iconSize: 14)
                                      ]),
                                );
                              }),
                        ),
                      ),
                      SizedBox(height: 15),
                      (snapshot.data["Discount"] > 0)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  //Column Name + Qty
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 150),
                                    child: Text(
                                      'Descuento',
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                  ),
                                  //Amount
                                  Spacer(),
                                  Text(
                                      formatCurrency
                                          .format(snapshot.data["Discount"]),
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  SizedBox(width: 10),
                                  //Delete
                                  IconButton(
                                      onPressed: () =>
                                          bloc.setDiscountAmount(0),
                                      icon: Icon(Icons.close),
                                      iconSize: 14)
                                ])
                          : Container(),
                      //Actions (Save, Process)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //PopUp Menu
                          MoreTicketPopUp(
                              categoriesProvider: categoriesProvider),
                          SizedBox(width: 10),
                          //Pagar
                          Expanded(
                              child: Container(
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MultiProvider(
                                        providers: [
                                          StreamProvider<
                                                  DailyTransactions>.value(
                                              initialData: null,
                                              catchError: (_, err) => null,
                                              value: DatabaseService()
                                                  .dailyTransactions(
                                                      widget.userProfile
                                                          .activeBusiness,
                                                      registerStatus
                                                          .registerName)),
                                          StreamProvider<MonthlyStats>.value(
                                              initialData: null,
                                              value: DatabaseService()
                                                  .monthlyStatsfromSnapshot(
                                                      widget.userProfile
                                                          .activeBusiness)),
                                          StreamProvider<UserData>.value(
                                              initialData: null,
                                              value: DatabaseService()
                                                  .userProfile(uid)),
                                        ],
                                        child: ConfirmOrder(
                                          total: total,
                                          items: snapshot.data["Items"],
                                          discount: discount,
                                          orderDetail: orderDetail,
                                          orderName: orderName,
                                          subTotal: subTotal,
                                          tax: tax,
                                          controller: _orderNamecontroller,
                                          clearVariables: clearVariables,
                                          paymentTypes:
                                              registerStatus.paymentTypes,
                                          isTable: true,
                                          tableCode: orderName,
                                          businessID:
                                              widget.userProfile.activeBusiness,
                                          tablePageController:
                                              widget.tableController,
                                          isSavedOrder: false,
                                          savedOrderID: null,
                                          orderType:
                                              snapshot.data["Order Type"],
                                          onTableView: widget.onTableView,
                                          register: registerStatus,
                                        ),
                                      );
                                    });
                              },
                              child: Center(
                                  child: Text(
                                      'Pagar ${formatCurrency.format(total)}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400))),
                            ),
                          )),
                        ],
                      )
                    ]));
          });
    } else if (widget.counterSale) {
      return StreamBuilder(
          stream: bloc.getStream,
          initialData: bloc.ticketItems,
          builder: (context, snapshot) {
            subTotal = snapshot.data["Subtotal"];
            tax = snapshot.data["IVA"];
            discount = snapshot.data["Discount"];
            total = snapshot.data["Total"];
            orderName = snapshot.data["Order Name"];
            color = snapshot.data["Color"];

            for (var i = 0; i < bloc.ticketItems['Items'].length; i++) {
              subTotal += bloc.ticketItems['Items'][i]["Price"] *
                  bloc.ticketItems['Items'][i]["Quantity"];
            }

            total = (subTotal + ((subTotal * tax).round())) - discount;

            if (snapshot.data["Order Type"] == 'Mostrador') {
              ticketConcept = 'Mostrador';
              ticketIcon = ticketIcon = Icons.assignment_outlined;
            } else if (snapshot.data["Order Type"] == 'Delivery') {
              ticketConcept = 'Delivery';
              ticketIcon = Icons.directions_bike_outlined;
            } else if (snapshot.data["Order Type"] == 'Mesa') {
              ticketConcept = 'Mesa';
              ticketIcon = Icons.restaurant;
            } else if (snapshot.data["Order Type"] == 'Consumo de Empleados') {
              ticketConcept = 'Consumo de Empleados';
              ticketIcon = Icons.takeout_dining_outlined;
            } else {
              ticketConcept = 'Desperdicios';
              ticketIcon = Icons.coffee_outlined;
            }

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Order Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PopupMenuButton<int>(
                              child: Container(
                                child: Row(children: [
                                  //Text
                                  Icon(
                                    ticketIcon,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  SizedBox(width: 3),
                                  //Icon
                                  Icon(Icons.keyboard_arrow_down, size: 14),
                                ]),
                              ),
                              onSelected: (value) {
                                switch (value) {
                                  case 0:
                                    // setState(() {
                                    //   ticketConcept = 'Mostrador';
                                    //   ticketIcon = Icons.assignment_outlined;
                                    bloc.changeOrderType('Mostrador');
                                    // });
                                    break;
                                  case 1:
                                    // setState(() {
                                    //   ticketConcept = 'Delivery';
                                    //   ticketIcon =
                                    //       Icons.directions_bike_outlined;
                                    bloc.changeOrderType('Delivery');
                                    // });
                                    break;
                                  case 2:
                                    // setState(() {
                                    //   ticketConcept = 'Consumo de Empleados';
                                    //   ticketIcon =
                                    //       Icons.takeout_dining_outlined;
                                    // });
                                    bloc.changeOrderType(
                                        'Consumo de Empleados');
                                    break;
                                  case 3:
                                    // setState(() {
                                    //   ticketConcept = 'Desperdicios';
                                    //   ticketIcon = Icons.coffee_outlined;
                                    // });
                                    bloc.changeOrderType('Desperdicios');
                                    break;

                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                    //Mostradpr
                                    PopupMenuItem<int>(
                                        value: 0,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.assignment_outlined,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Mostrador")
                                          ],
                                        )),
                                    //Delivery
                                    PopupMenuItem<int>(
                                        value: 1,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.directions_bike_outlined,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Delivery")
                                          ],
                                        )),

                                    //Consumo
                                    PopupMenuItem<int>(
                                        value: 2,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.coffee_outlined,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Consumo de Empleados")
                                          ],
                                        )),
                                    //Desperdicios
                                    PopupMenuItem<int>(
                                        value: 3,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.takeout_dining_outlined,
                                              color: Colors.black,
                                              size: 16,
                                            ),
                                            SizedBox(width: 10),
                                            Text("Desperdicios")
                                          ],
                                        )),
                                  ]),
                          (snapshot.data["Order Type"] == 'Mostrador' ||
                                  snapshot.data["Order Type"] == 'Delivery')
                              ? Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: TextFormField(
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(15)
                                      ],
                                      cursorColor: Colors.grey,
                                      controller: _orderNamecontroller,
                                      // initialValue:
                                      //     (snapshot.data["Order Name"] == '')
                                      //         ? ''
                                      //         : snapshot.data["Order Name"],
                                      decoration: InputDecoration.collapsed(
                                        hintText: 'Nombre',
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 14),
                                      ),
                                      onChanged: (val) {
                                        bloc.changeOrderName(val);
                                        setState(() {
                                          orderName = val;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Text(ticketConcept,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1),
                                  ),
                                ),

                          (snapshot.data["Client"]['Address'] != '' ||
                                  snapshot.data["Client"]['Phone'] != 0 ||
                                  snapshot.data["Client"]['email'] != '' ||
                                  snapshot.data["Client"]['Name'] != '')
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Tooltip(
                                    message: (snapshot.data["Client"]
                                                    ['Address'] !=
                                                null &&
                                            snapshot.data["Client"]['Phone'] !=
                                                null &&
                                            snapshot.data["Client"]['email'] !=
                                                null &&
                                            snapshot.data["Client"]['Name'] !=
                                                null)
                                        ? ('${snapshot.data["Client"]['Address']} | ${snapshot.data["Client"]['Phone']} ${snapshot.data["Client"]['email']}')
                                        : '',
                                    child: Icon(Icons.info_outline),
                                  ),
                                )
                              : Container(),
                          SizedBox(width: 5),
                          //Delete Order
                          IconButton(
                              tooltip: 'Borrar y volver',
                              onPressed: () {
                                if (snapshot.data['Order Type'] == 'Mesa') {
                                  DatabaseService().updateTable(
                                    widget.userProfile.activeBusiness,
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
                                      'Name': orderName,
                                      'Address': '',
                                      'Phone': 0,
                                      'email': '',
                                    },
                                  );
                                }

                                DatabaseService()
                                    .deleteOrder(
                                      widget.userProfile.activeBusiness,
                                      bloc.ticketItems['Order ID'],
                                    )
                                    .then((value) => bloc.removeAllFromCart());
                                setState(() {
                                  ticketConcept = 'Mostrador';
                                });
                                widget.tableController
                                    .animateToPage(0,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeIn)
                                    .then((value) => clearVariables());
                              },
                              icon: Icon(Icons.delete, color: Colors.black))
                        ],
                      ),
                      SizedBox(height: 3),
                      Divider(thickness: 0.5, indent: 0, endIndent: 0),
                      SizedBox(height: 5),
                      //List of Products
                      (snapshot.data["Items"] == [])
                          ? SizedBox()
                          : Expanded(
                              child: Container(
                                padding: EdgeInsets.only(top: 5),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data["Items"].length,
                                    itemBuilder: (context, i) {
                                      final cartList = snapshot.data["Items"];
                                      orderDetail = cartList;

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //Column Name + Qty
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //Name
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 150),
                                                    child: Text(
                                                        cartList[i]['Name']),
                                                  ),
                                                  //Options
                                                  (snapshot
                                                          .data["Items"][i]
                                                              ['Options']
                                                          .isEmpty)
                                                      ? SizedBox()
                                                      // : SizedBox(),
                                                      : Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5),
                                                          child: Container(
                                                            child: Text(
                                                                cartList[i][
                                                                        'Options']
                                                                    .join(', '),
                                                                maxLines: 6,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12)),
                                                          ),
                                                        ),

                                                  //Quantity
                                                  Row(
                                                    children: [
                                                      //Remove
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            bloc.removeQuantity(
                                                                i);
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .remove_circle_outline),
                                                        iconSize: 16,
                                                      ),
                                                      Text(
                                                          '${cartList[i]['Quantity']}'),
                                                      //Add
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            bloc.addQuantity(i);
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .add_circle_outline),
                                                        iconSize: 16,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              //Amount
                                              Spacer(),
                                              Text(formatCurrency.format(
                                                  cartList[i]['Total Price'])),
                                              SizedBox(width: 10),
                                              //Delete
                                              IconButton(
                                                  onPressed: () =>
                                                      bloc.removeFromCart(
                                                          cartList[i]),
                                                  icon: Icon(Icons.close),
                                                  iconSize: 14)
                                            ]),
                                      );
                                    }),
                              ),
                            ),
                      SizedBox(height: 15),
                      (snapshot.data["Discount"] > 0)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                  //Column Name + Qty
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 150),
                                    child: Text(
                                      'Descuento',
                                      style: TextStyle(
                                          color: Colors.grey.shade700),
                                    ),
                                  ),
                                  //Amount
                                  Spacer(),
                                  Text(
                                      formatCurrency
                                          .format(snapshot.data["Discount"]),
                                      style: TextStyle(
                                          color: Colors.grey.shade700)),
                                  SizedBox(width: 10),
                                  //Delete
                                  IconButton(
                                      onPressed: () =>
                                          bloc.setDiscountAmount(0),
                                      icon: Icon(Icons.close),
                                      iconSize: 14)
                                ])
                          : Container(),
                      //Actions (Save, Process)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Guardar
                          Container(
                            height: 40,
                            width: 40,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.all(5)),
                                alignment: Alignment.center,
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white70),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered))
                                      return Colors.grey.shade300;
                                    if (states
                                            .contains(MaterialState.focused) ||
                                        states.contains(MaterialState.pressed))
                                      return Colors.white;
                                    return null; // Defer to the widget's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                //Save Order
                                DatabaseService().saveOrder(
                                  widget.userProfile.activeBusiness,
                                  (bloc.ticketItems['Order ID'] != '')
                                      ? bloc.ticketItems['Order ID']
                                      : DateTime.now().toString(),
                                  subTotal,
                                  discount,
                                  tax,
                                  total,
                                  (orderDetail == null) ? [] : orderDetail,
                                  orderName,
                                  '',
                                  (color == Colors.white)
                                      ? Colors
                                          .primaries[Random()
                                              .nextInt(Colors.primaries.length)]
                                          .value
                                      : color.value,
                                  false,
                                  ticketConcept,
                                  {
                                    'Name': snapshot.data["Client"]['Name'],
                                    'Address': snapshot.data["Client"]
                                        ['Address'],
                                    'Phone': snapshot.data["Client"]['Phone'],
                                    'email': snapshot.data["Client"]['email'],
                                  },
                                );

                                //Clear Variables
                                widget.tableController
                                    .animateToPage(0,
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeIn)
                                    .then((value) => clearVariables());
                              },
                              child: Icon(
                                Icons.save,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          //PopUp Menu
                          MoreTicketPopUp(
                              categoriesProvider: categoriesProvider),
                          SizedBox(width: 10),
                          //Pagar
                          Expanded(
                              child: Container(
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                              ),
                              onPressed: () {
                                //getServerStatus();
                                //createAFIPinvoice();
                                print(registerStatus.registerName);
                                if (ticketConcept == 'Mostrador' ||
                                    ticketConcept == 'Delivery' ||
                                    ticketConcept == 'Mesa') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return MultiProvider(
                                          providers: [
                                            StreamProvider<
                                                    DailyTransactions>.value(
                                                initialData: null,
                                                catchError: (_, err) => null,
                                                value: DatabaseService()
                                                    .dailyTransactions(
                                                        widget.userProfile
                                                            .activeBusiness,
                                                        registerStatus
                                                            .registerName)),
                                            StreamProvider<MonthlyStats>.value(
                                                initialData: null,
                                                value: DatabaseService()
                                                    .monthlyStatsfromSnapshot(
                                                        widget.userProfile
                                                            .activeBusiness)),
                                            StreamProvider<UserData>.value(
                                                initialData: null,
                                                value: DatabaseService()
                                                    .userProfile(uid)),
                                          ],
                                          child: ConfirmOrder(
                                            total: total,
                                            items: snapshot.data["Items"],
                                            discount: discount,
                                            orderDetail: orderDetail,
                                            orderName: orderName,
                                            subTotal: subTotal,
                                            tax: tax,
                                            controller: _orderNamecontroller,
                                            clearVariables: clearVariables,
                                            paymentTypes:
                                                registerStatus.paymentTypes,
                                            isTable:
                                                (snapshot.data["Order Type"] ==
                                                        'Mesa')
                                                    ? true
                                                    : false,
                                            tableCode:
                                                (snapshot.data["Order Type"] ==
                                                        'Mesa')
                                                    ? orderName
                                                    : null,
                                            businessID: widget
                                                .userProfile.activeBusiness,
                                            tablePageController:
                                                widget.tableController,
                                            isSavedOrder:
                                                (bloc.ticketItems['Order ID'] !=
                                                        '')
                                                    ? true
                                                    : false,
                                            savedOrderID:
                                                bloc.ticketItems['Order ID'],
                                            orderType:
                                                snapshot.data["Order Type"],
                                            onTableView: widget.onTableView,
                                            register: registerStatus,
                                          ),
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ConfirmWastage(
                                            total: total,
                                            orderDetail: orderDetail,
                                            items: snapshot.data["Items"],
                                            controller: _orderNamecontroller,
                                            clearVariables: clearVariables,
                                            ticketConcept: ticketConcept);
                                      });
                                }
                              },
                              child: Center(
                                  child: Text(
                                      (ticketConcept == 'Mostrador' ||
                                              ticketConcept == 'Delivery' ||
                                              ticketConcept == 'Mesa')
                                          ? 'Pagar ${formatCurrency.format(total)}'
                                          : 'Registrar',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400))),
                            ),
                          )),
                        ],
                      )
                    ]));
          });
    }

    return StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.ticketItems,
        builder: (context, snapshot) {
          subTotal = snapshot.data["Subtotal"];
          tax = snapshot.data["IVA"];
          discount = snapshot.data["Discount"];
          total = snapshot.data["Total"];
          orderName = snapshot.data["Order Name"];
          color = snapshot.data["Color"];

          for (var i = 0; i < bloc.ticketItems['Items'].length; i++) {
            subTotal += bloc.ticketItems['Items'][i]["Price"] *
                bloc.ticketItems['Items'][i]["Quantity"];
          }

          total = (subTotal + ((subTotal * tax).round())) - discount;

          if (snapshot.data["Order Type"] == 'Mostrador') {
            ticketConcept = 'Mostrador';
            ticketIcon = ticketIcon = Icons.assignment_outlined;
          } else if (snapshot.data["Order Type"] == 'Delivery') {
            ticketConcept = 'Delivery';
            ticketIcon = Icons.directions_bike_outlined;
          } else if (snapshot.data["Order Type"] == 'Mesa') {
            ticketConcept = 'Mesa';
            ticketIcon = Icons.restaurant;
          } else if (snapshot.data["Order Type"] == 'Consumo de Empleados') {
            ticketConcept = 'Consumo de Empleados';
            ticketIcon = Icons.takeout_dining_outlined;
          } else {
            ticketConcept = 'Desperdicios';
            ticketIcon = Icons.coffee_outlined;
          }

          return Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Active Orders
                    StreamProvider<List<SavedOrders>>.value(
                        initialData: null,
                        value: DatabaseService()
                            .orderList(widget.userProfile.activeBusiness),
                        child: ActiveOrders(_orderNamecontroller)),

                    //Order Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PopupMenuButton<int>(
                            tooltip: 'Abrir opciones',
                            child: Container(
                              child: Row(children: [
                                //Text
                                Icon(
                                  ticketIcon,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                SizedBox(width: 3),
                                //Icon
                                Icon(Icons.keyboard_arrow_down, size: 14),
                              ]),
                            ),
                            onSelected: (value) {
                              switch (value) {
                                case 0:
                                  // setState(() {
                                  // ticketConcept = 'Mostrador';
                                  // ticketIcon = Icons.assignment_outlined;
                                  bloc.changeOrderType('Mostrador');
                                  // });
                                  break;
                                case 1:
                                  // setState(() {
                                  //   ticketConcept = 'Delivery';
                                  //   ticketIcon = Icons.directions_bike_outlined;
                                  bloc.changeOrderType('Delivery');
                                  // });
                                  break;
                                case 2:
                                  // setState(() {
                                  //   ticketConcept = 'Mesa';
                                  //   ticketIcon = Icons.restaurant;
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SelectTableDialog(
                                            widget.userProfile,
                                            _orderNamecontroller,
                                            tables);
                                      });
                                  // });
                                  break;
                                case 3:
                                  // setState(() {
                                  //   ticketConcept = 'Consumo de Empleados';
                                  //   ticketIcon = Icons.takeout_dining_outlined;
                                  bloc.changeOrderType('Consumo de Empleados');
                                  // });
                                  break;
                                case 4:
                                  // setState(() {
                                  //   ticketConcept = 'Desperdicios';
                                  //   ticketIcon = Icons.coffee_outlined;
                                  bloc.changeOrderType('Desperdicios');
                                  // });
                                  break;
                                  break;
                                // case 3:
                                //   setState(() {
                                //     ticketConcept = 'Stats';
                                //   });
                                //   break;
                              }
                            },
                            itemBuilder: (context) => [
                                  //Mostradpr
                                  PopupMenuItem<int>(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.assignment_outlined,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Mostrador")
                                        ],
                                      )),
                                  //Delivery
                                  PopupMenuItem<int>(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.directions_bike_outlined,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Delivery")
                                        ],
                                      )),
                                  //Mesas
                                  PopupMenuItem<int>(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Mesa")
                                        ],
                                      )),
                                  //Consumo
                                  PopupMenuItem<int>(
                                      value: 3,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.coffee_outlined,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Consumo de Empleados")
                                        ],
                                      )),
                                  //Desperdicios
                                  PopupMenuItem<int>(
                                      value: 4,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.takeout_dining_outlined,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          SizedBox(width: 10),
                                          Text("Desperdicios")
                                        ],
                                      )),
                                ]),
                        (snapshot.data["Order Type"] == 'Mostrador' ||
                                snapshot.data["Order Type"] == 'Delivery')
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(15)
                                    ],
                                    cursorColor: Colors.grey,
                                    controller: _orderNamecontroller,
                                    // // initialValue:
                                    // //     (snapshot.data["Order Name"] == '')
                                    // //         ? ''
                                    // //         : snapshot.data["Order Name"],
                                    decoration: InputDecoration.collapsed(
                                      hintText: 'Nombre',
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14),
                                    ),
                                    onChanged: (val) {
                                      bloc.changeOrderName(val);
                                      setState(() {
                                        orderName = val;
                                      });
                                    },
                                  ),
                                ),
                              )
                            : (snapshot.data["Order Type"] == 'Mesa')
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text('Mesa ' + orderName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          overflow: TextOverflow.fade,
                                          maxLines: 1),
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(ticketConcept,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1),
                                    ),
                                  ),

                        (snapshot.data["Client"]['Address'] != '' ||
                                snapshot.data["Client"]['Phone'] != 0 ||
                                snapshot.data["Client"]['email'] != '' ||
                                snapshot.data["Client"]['Name'] != '')
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Tooltip(
                                  message: (snapshot.data["Client"]
                                                  ['Address'] !=
                                              null &&
                                          snapshot.data["Client"]['Phone'] !=
                                              null &&
                                          snapshot.data["Client"]['email'] !=
                                              null &&
                                          snapshot.data["Client"]['Name'] !=
                                              null)
                                      ? ('${snapshot.data["Client"]['Address']} | ${snapshot.data["Client"]['Phone']} ${snapshot.data["Client"]['email']}')
                                      : '',
                                  child: Icon(Icons.info_outline),
                                ),
                              )
                            : Container(),
                        SizedBox(width: 5),
                        //Delete Order
                        IconButton(
                            tooltip: 'Borrar pedido',
                            onPressed: () {
                              if (snapshot.data['Order Type'] == 'Mesa') {
                                DatabaseService().updateTable(
                                  widget.userProfile.activeBusiness,
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
                                    'Name': orderName,
                                    'Address': '',
                                    'Phone': 0,
                                    'email': '',
                                  },
                                );
                              }
                              if (snapshot.data["Open Table"]) {
                                DatabaseService()
                                    .deleteOrder(
                                      widget.userProfile.activeBusiness,
                                      bloc.ticketItems['Order ID'],
                                    )
                                    .then((value) => bloc.removeAllFromCart());
                                setState(() {
                                  ticketConcept = 'Mostrador';
                                });
                              }

                              bloc.removeAllFromCart();

                              _orderNamecontroller.clear();
                              setState(() {
                                discount = 0;
                                tax = 0;
                                orderCategories = {};
                                ticketConcept = 'Mostrador';
                              });
                            },
                            icon: Icon(Icons.delete, color: Colors.black))
                      ],
                    ),
                    SizedBox(height: 3),
                    Divider(thickness: 0.5, indent: 0, endIndent: 0),
                    SizedBox(height: 5),
                    //List of Products
                    (snapshot.data["Items"] == [])
                        ? SizedBox()
                        : Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 5),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data["Items"].length,
                                  itemBuilder: (context, i) {
                                    final cartList = snapshot.data["Items"];
                                    orderDetail = cartList;

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            //Column Name + Qty
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //Name
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 150),
                                                    child: Text(
                                                        cartList[i]['Name']),
                                                  ),
                                                  //Options
                                                  (snapshot
                                                          .data["Items"][i]
                                                              ['Options']
                                                          .isEmpty)
                                                      ? SizedBox()
                                                      // : SizedBox(),
                                                      : Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5),
                                                          child: Container(
                                                            child: Text(
                                                                cartList[i][
                                                                        'Options']
                                                                    .join(', '),
                                                                maxLines: 6,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12)),
                                                          ),
                                                        ),
                                                  //Quantity
                                                  Row(
                                                    children: [
                                                      //Remove
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            bloc.removeQuantity(
                                                                i);
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .remove_circle_outline),
                                                        iconSize: 16,
                                                      ),
                                                      Text(
                                                          '${cartList[i]['Quantity']}'),
                                                      //Add
                                                      IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            bloc.addQuantity(i);
                                                          });
                                                        },
                                                        icon: Icon(Icons
                                                            .add_circle_outline),
                                                        iconSize: 16,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            //Amount
                                            SizedBox(width: 10),
                                            Text(formatCurrency.format(
                                                cartList[i]['Total Price'])),
                                            SizedBox(width: 10),
                                            //Delete
                                            IconButton(
                                                padding: EdgeInsets.all(2),
                                                onPressed: () =>
                                                    bloc.removeFromCart(
                                                        cartList[i]),
                                                icon: Icon(Icons.close),
                                                iconSize: 14)
                                          ]),
                                    );
                                  }),
                            ),
                          ),
                    (snapshot.data["Discount"] > 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                //Column Name + Qty
                                Container(
                                  constraints: BoxConstraints(maxWidth: 150),
                                  child: Text(
                                    'Descuento',
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                ),
                                //Amount
                                Spacer(),
                                Text(
                                    formatCurrency
                                        .format(snapshot.data["Discount"]),
                                    style:
                                        TextStyle(color: Colors.grey.shade700)),
                                SizedBox(width: 10),
                                //Delete
                                IconButton(
                                    onPressed: () => bloc.setDiscountAmount(0),
                                    icon: Icon(Icons.close),
                                    iconSize: 14)
                              ])
                        : Container(),
                    SizedBox(height: 15),
                    //Actions (Save, Process)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Guardar
                        Container(
                          height: 40,
                          width: 40,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.all(5)),
                              alignment: Alignment.center,
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white70),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Colors.grey.shade300;
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed))
                                    return Colors.white;
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              //Save Order
                              //Default hacer que sea venta de mostrador (si estaba guardada o si no, si tiene productos o si no)
                              //Si es mesa, si esta abierta o no, si hay prd o no

                              //Si es venta de mostrador
                              if (snapshot.data["Order Type"] == 'Mostrador' ||
                                  snapshot.data["Order Type"] == 'Delivery') {
                                //Si ya estaba guardada
                                if (snapshot.data["Open Table"]) {
                                  if (bloc.ticketItems['Items'].length < 1) {
                                    DatabaseService().deleteOrder(
                                      widget.userProfile.activeBusiness,
                                      bloc.ticketItems['Order ID'],
                                    );
                                  } else {
                                    DatabaseService().saveOrder(
                                      widget.userProfile.activeBusiness,
                                      bloc.ticketItems['Order ID'],
                                      subTotal,
                                      discount,
                                      tax,
                                      total,
                                      (snapshot.data["Items"] == null)
                                          ? []
                                          : snapshot.data["Items"],
                                      orderName,
                                      '',
                                      color.value,
                                      false,
                                      snapshot.data["Order Type"],
                                      {
                                        'Name': snapshot.data["Client"]['Name'],
                                        'Address': snapshot.data["Client"]
                                            ['Address'],
                                        'Phone': snapshot.data["Client"]
                                            ['Phone'],
                                        'email': snapshot.data["Client"]
                                            ['email'],
                                      },
                                    );
                                  }
                                } else if (!snapshot.data["Open Table"] &&
                                    bloc.ticketItems['Items'].length > 0) {
                                  DatabaseService().saveOrder(
                                    widget.userProfile.activeBusiness,
                                    DateTime.now().toString(),
                                    subTotal,
                                    discount,
                                    tax,
                                    total,
                                    (snapshot.data["Items"] == null)
                                        ? []
                                        : snapshot.data["Items"],
                                    orderName,
                                    '',
                                    Colors
                                        .primaries[Random()
                                            .nextInt(Colors.primaries.length)]
                                        .value,
                                    false,
                                    ticketConcept,
                                    {
                                      'Name': snapshot.data["Client"]['Name'],
                                      'Address': snapshot.data["Client"]
                                          ['Address'],
                                      'Phone': snapshot.data["Client"]['Phone'],
                                      'email': snapshot.data["Client"]['email'],
                                    },
                                  );
                                }
                              } else if (snapshot.data["Order Type"] ==
                                      'Mesa' &&
                                  snapshot.data["Open Table"]) {
                                if (bloc.ticketItems['Items'].length < 1) {
                                  DatabaseService().updateTable(
                                    widget.userProfile.activeBusiness,
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
                                      'Name': snapshot.data["Client"]['Name'],
                                      'Address': snapshot.data["Client"]
                                          ['Address'],
                                      'Phone': snapshot.data["Client"]['Phone'],
                                      'email': snapshot.data["Client"]['email'],
                                    },
                                  );
                                  DatabaseService().deleteOrder(
                                    widget.userProfile.activeBusiness,
                                    bloc.ticketItems['Order ID'],
                                  );
                                } else {
                                  DatabaseService().updateTable(
                                    widget.userProfile.activeBusiness,
                                    orderName,
                                    subTotal,
                                    discount,
                                    tax,
                                    total,
                                    (snapshot.data["Items"] == null)
                                        ? []
                                        : snapshot.data["Items"],
                                    '',
                                    Colors.greenAccent.value,
                                    true,
                                    {
                                      'Name': snapshot.data["Client"]['Name'],
                                      'Address': snapshot.data["Client"]
                                          ['Address'],
                                      'Phone': snapshot.data["Client"]['Phone'],
                                      'email': snapshot.data["Client"]['email'],
                                    },
                                  );
                                  DatabaseService().saveOrder(
                                    widget.userProfile.activeBusiness,
                                    bloc.ticketItems['Order ID'],
                                    subTotal,
                                    discount,
                                    tax,
                                    total,
                                    (snapshot.data["Items"] == null)
                                        ? []
                                        : snapshot.data["Items"],
                                    orderName,
                                    '',
                                    color.value,
                                    true,
                                    'Mesa',
                                    {
                                      'Name': '',
                                      'Address': '',
                                      'Phone': 0,
                                      'email': '',
                                    },
                                  );
                                }
                              } else if (snapshot.data["Order Type"] ==
                                      'Mesa' &&
                                  !snapshot.data["Open Table"] &&
                                  bloc.ticketItems['Items'].length > 0) {
                                DatabaseService().updateTable(
                                  widget.userProfile.activeBusiness,
                                  orderName,
                                  subTotal,
                                  discount,
                                  tax,
                                  total,
                                  (snapshot.data["Items"] == null)
                                      ? []
                                      : snapshot.data["Items"],
                                  '',
                                  Colors.greenAccent.value,
                                  true,
                                  {
                                    'Name': snapshot.data["Client"]['Name'],
                                    'Address': snapshot.data["Client"]
                                        ['Address'],
                                    'Phone': snapshot.data["Client"]['Phone'],
                                    'email': snapshot.data["Client"]['email'],
                                  },
                                );
                                DatabaseService().saveOrder(
                                  widget.userProfile.activeBusiness,
                                  'Mesa ' + orderName,
                                  subTotal,
                                  discount,
                                  tax,
                                  total,
                                  (snapshot.data["Items"] == null)
                                      ? []
                                      : snapshot.data["Items"],
                                  orderName,
                                  '',
                                  Colors.greenAccent.value,
                                  true,
                                  'Mesa',
                                  {
                                    'Name': '',
                                    'Address': '',
                                    'Phone': 0,
                                    'email': '',
                                  },
                                );
                              }
                              //Clear Variables
                              clearVariables();
                            },
                            child: Center(
                                child: Icon(
                              Icons.save,
                              color: Colors.black,
                              size: 18,
                            )),
                          ),
                        ),
                        SizedBox(width: 10),
                        //PopUp Menu
                        MoreTicketPopUp(categoriesProvider: categoriesProvider),
                        SizedBox(width: 10),
                        //Pagar
                        Expanded(
                            child: Container(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            onPressed: () {
                              //getServerStatus();
                              //createAFIPinvoice();
                              if (ticketConcept == 'Mostrador' ||
                                  ticketConcept == 'Delivery' ||
                                  ticketConcept == 'Mesa') {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MultiProvider(
                                        providers: [
                                          StreamProvider<
                                                  DailyTransactions>.value(
                                              initialData: null,
                                              catchError: (_, err) => null,
                                              value: DatabaseService()
                                                  .dailyTransactions(
                                                      widget.userProfile
                                                          .activeBusiness,
                                                      registerStatus
                                                          .registerName)),
                                          StreamProvider<MonthlyStats>.value(
                                              initialData: null,
                                              value: DatabaseService()
                                                  .monthlyStatsfromSnapshot(
                                                      widget.userProfile
                                                          .activeBusiness)),
                                          StreamProvider<UserData>.value(
                                              initialData: null,
                                              value: DatabaseService()
                                                  .userProfile(uid)),
                                        ],
                                        child: ConfirmOrder(
                                          total: total,
                                          items: snapshot.data["Items"],
                                          discount: discount,
                                          orderDetail: orderDetail,
                                          orderName: orderName,
                                          subTotal: subTotal,
                                          tax: tax,
                                          controller: _orderNamecontroller,
                                          clearVariables: clearVariables,
                                          paymentTypes:
                                              registerStatus.paymentTypes,
                                          isTable: (ticketConcept == 'Mesa')
                                              ? true
                                              : false,
                                          tableCode:
                                              (snapshot.data["Order Type"] ==
                                                      'Mesa')
                                                  ? orderName
                                                  : null,
                                          businessID:
                                              widget.userProfile.activeBusiness,
                                          tablePageController: null,
                                          isSavedOrder:
                                              (bloc.ticketItems['Order ID'] !=
                                                      '')
                                                  ? true
                                                  : false,
                                          savedOrderID:
                                              bloc.ticketItems['Order ID'],
                                          orderType:
                                              snapshot.data["Order Type"],
                                          onTableView: widget.onTableView,
                                          register: registerStatus,
                                        ),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ConfirmWastage(
                                          total: total,
                                          orderDetail: orderDetail,
                                          items: snapshot.data["Items"],
                                          controller: _orderNamecontroller,
                                          clearVariables: clearVariables,
                                          ticketConcept: ticketConcept);
                                    });
                              }
                            },
                            child: Center(
                                child: Text(
                                    (ticketConcept == 'Mostrador' ||
                                            ticketConcept == 'Delivery' ||
                                            ticketConcept == 'Mesa')
                                        ? 'Pagar ${formatCurrency.format(total)}'
                                        : 'Registrar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400))),
                          ),
                        )),
                      ],
                    )
                  ]));
        });
  }
}
