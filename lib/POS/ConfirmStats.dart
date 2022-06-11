import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Stats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmStats extends StatefulWidget {
  final double total;
  final orderDetail;
  final clearVariables;
  final dynamic items;
  final String ticketConcept;

  final TextEditingController controller;

  ConfirmStats(
      {this.total,
      this.orderDetail,
      this.controller,
      this.clearVariables,
      this.items,
      this.ticketConcept});

  @override
  _ConfirmStatsState createState() => _ConfirmStatsState();
}

class _ConfirmStatsState extends State<ConfirmStats> {
  Map<String, dynamic> orderStats;
  int currentSalesCount;
  Map<String, dynamic> currentItemsCount;
  Map<String, dynamic> currentItemsAmount;
  Map<String, dynamic> salesCountbyCategory;
  int newSalesCount;
  int currentTicketItemsCount;
  int newTicketItemsCount;

  @override
  void initState() {
    newSalesCount = 0;
    newTicketItemsCount = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final monthlyStats = Provider.of<MonthlyStats>(context);

    if (monthlyStats == null) {
      currentSalesCount = 0;
      currentTicketItemsCount = 0;
      currentItemsCount = {};
      currentItemsAmount = {};
      salesCountbyCategory = {};
    }

    try {
      currentSalesCount = monthlyStats.totalSalesCount;
    } catch (e) {
      //
    }
    try {
      currentItemsCount = monthlyStats.salesCountbyProduct;
    } catch (e) {
      currentItemsCount = {};
    }
    try {
      currentItemsAmount = monthlyStats.salesAmountbyProduct;
    } catch (e) {
      currentItemsAmount = {};
    }
    try {
      currentTicketItemsCount = monthlyStats.totalItemsSold;
    } catch (e) {
      currentTicketItemsCount = 0;
    }
    try {
      salesCountbyCategory = monthlyStats.salesCountbyCategory;
    } catch (e) {
      salesCountbyCategory = {};
    }

    return Center(
      child: SingleChildScrollView(
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: EdgeInsets.all(20),
                width: 400,
                constraints: BoxConstraints(minHeight: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Close
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Icon(Icons.close),
                              splashRadius: 5,
                              iconSize: 20.0),
                        )),
                    SizedBox(height: 20),
                    //Text
                    Center(
                        child: Text(
                      'Confirmar stats',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    )),
                    SizedBox(height: 30),
                    //Buttons
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //Confirmar
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered))
                                        return Colors.grey;
                                      if (states.contains(
                                              MaterialState.focused) ||
                                          states
                                              .contains(MaterialState.pressed))
                                        return Colors.grey.shade300;
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  ////////////////////////Update Accounts (sales and categories)
                                  //Sales Count
                                  if (currentSalesCount == null ||
                                      currentSalesCount < 1) {
                                    newSalesCount = 1;
                                  } else {
                                    newSalesCount = currentSalesCount + 1;
                                  }

                                  //Set Categories Variables
                                  orderStats = {};
                                  final cartList = widget.items;

                                  //Items Sold
                                  if (currentTicketItemsCount == null ||
                                      currentTicketItemsCount < 1) {
                                    newTicketItemsCount = cartList.length;
                                  } else {
                                    newTicketItemsCount =
                                        currentTicketItemsCount +
                                            cartList.length;
                                  }

                                  ////////////////////////////Add amounts by category/account///////////////////

                                  //Logic to add up categories totals in current ticket
                                  for (var i = 0; i < cartList.length; i++) {
                                    //Check if the map contains the key
                                    if (salesCountbyCategory.containsKey(
                                        '${cartList[i]["Category"]}')) {
                                      //Add to existing category amount
                                      salesCountbyCategory.update(
                                          '${cartList[i]["Category"]}',
                                          (value) =>
                                              value +
                                              (cartList[i]["Price"] *
                                                  cartList[i]["Quantity"]));
                                    } else {
                                      //Add new category with amount
                                      salesCountbyCategory[
                                              '${cartList[i]["Category"]}'] =
                                          cartList[i]["Price"] *
                                              cartList[i]["Quantity"];
                                    }
                                  }

                                  ////////////////////////////Add by item count///////////////////

                                  //Logic to add up item count  in current ticket
                                  for (var i = 0; i < cartList.length; i++) {
                                    //Check if the map contains the key
                                    if (currentItemsCount.containsKey(
                                        '${cartList[i]["Name"]}')) {
                                      //Add to existing category amount
                                      currentItemsCount.update(
                                          '${cartList[i]["Name"]}',
                                          (value) =>
                                              value + cartList[i]["Quantity"]);
                                    } else {
                                      //Add new category with amount
                                      currentItemsCount[
                                              '${cartList[i]["Name"]}'] =
                                          cartList[i]["Quantity"];
                                    }
                                  }

                                  //Logic to add up item Amount  in current ticket
                                  for (var i = 0; i < cartList.length; i++) {
                                    //Check if the map contains the key
                                    if (currentItemsAmount.containsKey(
                                        '${cartList[i]["Name"]}')) {
                                      //Add to existing category amount
                                      currentItemsAmount.update(
                                          '${cartList[i]["Name"]}',
                                          (value) =>
                                              value +
                                              (cartList[i]["Price"] *
                                                  cartList[i]["Quantity"]));
                                    } else {
                                      //Add new category with amount
                                      currentItemsAmount[
                                              '${cartList[i]["Name"]}'] =
                                          (cartList[i]["Price"] *
                                              cartList[i]["Quantity"]);
                                    }
                                  }

                                  orderStats['Total Sales Count'] =
                                      newSalesCount;
                                  orderStats['Total Items Sold'] =
                                      newTicketItemsCount;
                                  orderStats['Sales Count by Product'] =
                                      currentItemsCount;
                                  orderStats['Sales Amount by Product'] =
                                      currentItemsAmount;
                                  orderStats['Sales Count by Category'] =
                                      salesCountbyCategory;

                                  //Save Details to FB Historic
                                  DatabaseService().saveOrderStats(orderStats);

                                  widget.clearVariables();

                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Center(
                                    child: Text('Confirmar'),
                                  ),
                                )),
                          ]),
                    ),
                  ],
                ),
              ))),
    );
  }
}
