import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Sales.dart';
import 'package:denario/Models/Stats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmDeleteOrder extends StatefulWidget {
  final String businessID;
  final Sales sale;
  final CashRegister registerStatus;
  final DailyTransactions dailyTransactions;
  const ConfirmDeleteOrder(
      this.businessID, this.sale, this.registerStatus, this.dailyTransactions,
      {Key key})
      : super(key: key);

  @override
  State<ConfirmDeleteOrder> createState() => _ConfirmDeleteOrderState();
}

class _ConfirmDeleteOrderState extends State<ConfirmDeleteOrder> {
  Future currentValue(businessID) async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    var firestore = FirebaseFirestore.instance;

    var docRef = firestore
        .collection('ERP')
        .doc(businessID)
        .collection(year)
        .doc(month)
        .get();
    return docRef;
  }

  Future currentValuesBuilt;

  //Month Stats Variables
  Map<String, dynamic> orderStats;
  int currentSalesCount;
  Map<String, dynamic> currentItemsCount;
  Map<String, dynamic> currentItemsAmount;
  Map<String, dynamic> salesCountbyCategory;
  Map<String, dynamic> currentSalesbyOrderType;
  int newSalesCount;
  int currentTicketItemsCount;
  int newTicketItemsCount;

  //Daily Stats Variables
  int currentDailySalesCount;
  Map<String, dynamic> currentDailyItemsCount;
  Map<String, dynamic> currentDailyItemsAmount;
  Map<String, dynamic> dailySalesCountbyCategory;
  Map<String, dynamic> dailySalesbyCategory;
  Map<String, dynamic> dailySalesbyOrderType;
  int newDailySalesCount;
  int newDailyTicketItemsCount;

  @override
  void initState() {
    currentValuesBuilt = currentValue(widget.businessID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final monthlyStats = Provider.of<MonthlyStats>(context);

    try {
      currentSalesCount = monthlyStats.totalSalesCount;
    } catch (e) {
      currentSalesCount = 0;
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
    try {
      currentSalesbyOrderType = monthlyStats.salesbyOrderType;
    } catch (e) {
      currentSalesbyOrderType = {};
    }

    return Center(
      child: FutureBuilder(
          future: currentValuesBuilt,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting ||
                snap.connectionState == ConnectionState.none) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width * 0.35,
                    constraints: BoxConstraints(minHeight: 400, minWidth: 400),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment(1.0, 0.0),
                            child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.close),
                                iconSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          Container(
                              height: 25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.black26)),
                          SizedBox(height: 10),
                          Container(
                              height: 25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.black26)),
                          SizedBox(height: 10),
                          Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.black26)),
                          SizedBox(height: 30),
                          Container(
                              height: 25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.black26)),
                          Spacer(),
                          Container(
                            height: 100,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black38)),
                                Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black38)),
                                Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black38)),
                                Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black38)),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ));
            }
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: EdgeInsets.all(20),
                height: 200,
                width: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Title
                    Text(
                      'Estas apunto de eliminar esta venta ¿Deseas continuar?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                    SizedBox(height: 30),
                    //Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Si
                        Container(
                          height: 45,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.greenAccent),
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered))
                                      return Colors.grey[300];
                                    if (states
                                            .contains(MaterialState.focused) ||
                                        states.contains(MaterialState.pressed))
                                      return Colors.grey[300];
                                    return null; // Defer to the widget's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                double newSalesAmount = 0;
                                double salesAmount = 0;

                                //Date variables
                                var year = DateTime.now().year.toString();
                                var month = DateTime.now().month.toString();

                                ////////Update Accounts (sales and categories)
                                try {
                                  salesAmount = snap.data['Ventas'];

                                  newSalesAmount = salesAmount -
                                      widget.sale.total.toDouble();
                                } catch (e) {
                                  salesAmount = 0;
                                }

                                List<Map> items = [];

                                for (var i = 0;
                                    i < widget.sale.soldItems.length;
                                    i++) {
                                  items.add({
                                    'Name': widget.sale.soldItems[i].product,
                                    'Category':
                                        widget.sale.soldItems[i].category,
                                    'Price': widget.sale.soldItems[i].price,
                                    'Quantity': widget.sale.soldItems[i].qty,
                                    'Total Price':
                                        widget.sale.soldItems[i].total
                                  });
                                }

                                //Record in sales list as negative
                                DatabaseService().markSaleReversed(
                                    widget.businessID, widget.sale.docID);
                                //Create Sale negative
                                DatabaseService().createOrder(
                                    widget.businessID,
                                    year,
                                    month,
                                    DateTime.now(),
                                    widget.sale.subTotal * -1,
                                    widget.sale.discount,
                                    widget.sale.tax,
                                    widget.sale.total * -1,
                                    items,
                                    'Reversa de ' + widget.sale.transactionID,
                                    widget.sale.paymentType,
                                    widget.sale.orderName,
                                    widget.sale.clientDetails,
                                    widget.sale.transactionID + '-1',
                                    widget.sale.cashRegister,
                                    true);

                                /////Save Sales and Order Categories to database
                                //Set Categories Variables
                                Map<String, dynamic> orderCategories = {};

                                //Logic to retrieve and add up categories totals
                                for (var i = 0; i < items.length; i++) {
                                  //Check if the map contains the key
                                  if (orderCategories.containsKey(
                                      'Ventas de ${items[i]['Category']}')) {
                                    //Add to existing category amount
                                    orderCategories.update(
                                        'Ventas de ${items[i]['Category']}',
                                        (value) =>
                                            value + (items[i]['Total Price']));
                                  } else {
                                    //Add new category with amount
                                    orderCategories[
                                            'Ventas de ${items[i]['Category']}'] =
                                        items[i]['Total Price'];
                                  }
                                }
                                //Logic to add Sales by Categories to Firebase based on current Values from snap
                                orderCategories.forEach((k, v) {
                                  try {
                                    orderCategories.update(
                                        k, (value) => v = snap.data['$k'] - v);
                                  } catch (e) {
                                    //Do nothing
                                  }
                                });
                                //Add Total sales edited to map
                                orderCategories['Ventas'] = newSalesAmount;

                                DatabaseService().saveOrderType(
                                    widget.businessID, orderCategories);

                                //If it was on current register, substract from payment method
                                //If it was cash, substract amount from register
                                ///////////////////////////Register in Daily Transactions/////

                                if (widget.sale.cashRegister ==
                                    widget.registerStatus.registerName) {
                                  //Update sales by medium
                                  List salesByMedium =
                                      widget.dailyTransactions.salesByMedium;

                                  for (var map in salesByMedium) {
                                    if (map["Type"] ==
                                        widget.sale.paymentType) {
                                      map['Amount'] =
                                          map['Amount'] - widget.sale.total;
                                    }
                                  }

                                  DatabaseService().updateSalesinCashRegister(
                                      widget.businessID,
                                      widget.dailyTransactions.openDate
                                          .toString(),
                                      widget.dailyTransactions.sales -
                                          widget.sale.total,
                                      salesByMedium,
                                      widget
                                          .dailyTransactions.dailyTransactions);
                                }

                                ///////////////////////// MONTH STATS ///////////////////////////

                                // Sales Count
                                newSalesCount = currentSalesCount - 1;

                                // Set Categories Variables
                                orderStats = {};

                                // Items Sold
                                newTicketItemsCount =
                                    currentTicketItemsCount - items.length;

                                //////////////////////////Add amounts by category/account///////////////////

                                //Logic to add up categories totals in current ticket
                                for (var i = 0; i < items.length; i++) {
                                  //Check if the map contains the key
                                  if (salesCountbyCategory
                                      .containsKey('${items[i]["Category"]}')) {
                                    // Add to existing category amount
                                    salesCountbyCategory.update(
                                        '${items[i]["Category"]}',
                                        (value) =>
                                            value -
                                            (items[i]["Price"] *
                                                items[i]["Quantity"]));
                                  }
                                }

                                //////////////////////////Add by item count///////////////////

                                // Logic to add up item count  in current ticket
                                for (var i = 0; i < items.length; i++) {
                                  //Check if the map contains the key
                                  if (currentItemsCount
                                      .containsKey('${items[i]["Name"]}')) {
                                    //Add to existing category amount
                                    currentItemsCount.update(
                                        '${items[i]["Name"]}',
                                        (value) =>
                                            value - items[i]["Quantity"]);
                                  }
                                }

                                // Logic to add up item Amount  in current ticket
                                for (var i = 0; i < items.length; i++) {
                                  //   Check if the map contains the key
                                  if (currentItemsAmount
                                      .containsKey('${items[i]["Name"]}')) {
                                    //     Add to existing category amount
                                    currentItemsAmount.update(
                                        '${items[i]["Name"]}',
                                        (value) =>
                                            value -
                                            (items[i]["Price"] *
                                                items[i]["Quantity"]));
                                  }
                                }

                                orderStats['Total Sales'] = newSalesAmount;
                                orderStats['Total Sales Count'] = newSalesCount;
                                orderStats['Total Items Sold'] =
                                    newTicketItemsCount;
                                orderStats['Sales Count by Product'] =
                                    currentItemsCount;
                                orderStats['Sales Amount by Product'] =
                                    currentItemsAmount;
                                orderStats['Sales Count by Category'] =
                                    salesCountbyCategory;
                                orderStats['Sales by Order Type'] =
                                    currentSalesbyOrderType;

                                // Save Details to FB Historic
                                DatabaseService().saveOrderStats(
                                    widget.businessID, orderStats);

                                ///////////////////////// DAILY STATS ///////////////////////////

                                // Get current values from Firestore into variables
                                try {
                                  currentDailyItemsCount = widget
                                      .dailyTransactions.salesCountbyProduct;
                                } catch (e) {
                                  currentDailyItemsCount = {};
                                }
                                try {
                                  currentDailyItemsAmount = widget
                                      .dailyTransactions.salesAmountbyProduct;
                                } catch (e) {
                                  currentDailyItemsAmount = {};
                                }
                                try {
                                  dailySalesCountbyCategory = widget
                                      .dailyTransactions.salesCountbyCategory;
                                } catch (e) {
                                  dailySalesCountbyCategory = {};
                                }
                                try {
                                  dailySalesbyCategory =
                                      widget.dailyTransactions.salesbyCategory;
                                } catch (e) {
                                  dailySalesbyCategory = {};
                                }
                                try {
                                  dailySalesbyOrderType =
                                      widget.dailyTransactions.salesbyOrderType;
                                } catch (e) {
                                  dailySalesbyOrderType = {};
                                }

                                //Sales Count
                                newDailySalesCount =
                                    widget.dailyTransactions.totalSalesCount -
                                        1;

                                //Items Sold
                                newDailyTicketItemsCount =
                                    widget.dailyTransactions.totalItemsSold -
                                        items.length;

                                //////////////////////////Add amounts by category/account

                                // Logic to add up categories count
                                for (var i = 0; i < items.length; i++) {
                                  //   Check if the map contains the key
                                  if (dailySalesCountbyCategory
                                      .containsKey('${items[i]["Category"]}')) {
                                    //     Add to existing category amount
                                    dailySalesCountbyCategory.update(
                                        '${items[i]["Category"]}',
                                        (value) =>
                                            value -
                                            (items[i]["Price"] *
                                                items[i]["Quantity"]));
                                  }
                                }

                                // //////////////////////////Add by item count

                                // Logic to add up item count  in current ticket
                                for (var i = 0; i < items.length; i++) {
                                  //   Check if the map contains the key
                                  if (currentDailyItemsCount
                                      .containsKey('${items[i]["Name"]}')) {
                                    //     Add to existing category amount
                                    currentDailyItemsCount.update(
                                        '${items[i]["Name"]}',
                                        (value) =>
                                            value - items[i]["Quantity"]);
                                  }
                                }

                                // Logic to add up item Amount  in current ticket
                                for (var i = 0; i < items.length; i++) {
                                  //   Check if the map contains the key
                                  if (currentDailyItemsAmount
                                      .containsKey('${items[i]["Name"]}')) {
                                    //     Add to existing category amount
                                    currentDailyItemsAmount.update(
                                        '${items[i]["Name"]}',
                                        (value) =>
                                            value -
                                            (items[i]["Price"] *
                                                items[i]["Quantity"]));
                                  }
                                }

                                // Save Details to FB Historic
                                DatabaseService().saveDailyOrderStats(
                                    widget.businessID,
                                    widget.dailyTransactions.openDate
                                        .toString(),
                                    newDailyTicketItemsCount,
                                    newDailySalesCount,
                                    currentDailyItemsCount,
                                    dailySalesCountbyCategory,
                                    currentDailyItemsAmount,
                                    dailySalesbyOrderType);

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Text(
                                      'Eliminar venta',
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(width: 25),
                        //No
                        Container(
                          height: 45,
                          child: OutlinedButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.hovered))
                                      return Colors.grey[300];
                                    if (states
                                            .contains(MaterialState.focused) ||
                                        states.contains(MaterialState.pressed))
                                      return Colors.grey[300];
                                    return null; // Defer to the widget's default.
                                  },
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Text(
                                      'Volver',
                                      style: TextStyle(color: Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
