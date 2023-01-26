import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/No%20POS%20Sales/NewSaleScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatefulWidget {
  final double total;
  final dynamic items;

  final double subTotal;
  final double discount;
  final double tax;
  final orderDetail;
  final String orderName;
  final clearVariables;
  final List paymentTypes;

  final TextEditingController controller;
  final bool isTable;
  final String tableCode;

  final PageController tablePageController;
  final String businessID;

  final bool isSavedOrder;
  final String savedOrderID;
  final String orderType;

  final bool onTableView;
  final CashRegister register;

  ConfirmOrder(
      {this.total,
      this.items,
      this.discount,
      this.orderDetail,
      this.orderName,
      this.subTotal,
      this.tax,
      this.controller,
      this.clearVariables,
      this.paymentTypes,
      this.isTable,
      this.tableCode,
      this.tablePageController,
      this.businessID,
      this.isSavedOrder,
      this.savedOrderID,
      this.orderType,
      this.onTableView,
      this.register});

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  Map<String, dynamic> orderCategories;
  Future currentValuesBuilt;
  double salesAmount;
  String paymentType;
  bool otherChanageAmount;
  double paysWith = 1000;
  FocusNode otherChangeNode;
  String invoiceNo;
  String clientName = '';

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

  //Split Payment Variables
  List splitPaymentDetails = [];
  int currentSplitAmount = 0;

  final controller = PageController(initialPage: 0);

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

  void saveOrder(snap, UserData userProfile,
      DailyTransactions dailyTransactions, String payment) {
    if (snap.connectionState == ConnectionState.done) {
      double newSalesAmount = 0;
      //Date variables
      var year = DateTime.now().year.toString();
      var month = DateTime.now().month.toString();

      ////////////////////////Update Accounts (sales and categories)
      try {
        salesAmount = snap.data['Ventas'];
      } catch (e) {
        salesAmount = 0;
      }

      if (salesAmount == null || salesAmount < 1) {
        newSalesAmount = widget.total.toDouble();
      } else {
        newSalesAmount = salesAmount + widget.total.toDouble();
      }
      //Set Categories Variables
      orderCategories = {};
      final cartList = widget.items;

      //Logic to retrieve and add up categories totals
      for (var i = 0; i < cartList.length; i++) {
        //Check if the map contains the key
        if (orderCategories
            .containsKey('Ventas de ${cartList[i]["Category"]}')) {
          //Add to existing category amount
          orderCategories.update(
              'Ventas de ${cartList[i]["Category"]}',
              (value) =>
                  value + (cartList[i]["Price"] * cartList[i]["Quantity"]));
        } else {
          //Add new category with amount
          orderCategories['Ventas de ${cartList[i]["Category"]}'] =
              cartList[i]["Price"] * cartList[i]["Quantity"];
        }
      }
      //Logic to add Sales by Categories to Firebase based on current Values from snap
      orderCategories.forEach((k, v) {
        try {
          orderCategories.update(k, (value) => v = v + snap.data['$k']);
        } catch (e) {
          //Do nothing
        }
      });
      //Add Total sales edited to map
      orderCategories['Ventas'] = newSalesAmount;

      //Create Sale
      DatabaseService().createOrder(
          userProfile.activeBusiness,
          year,
          month,
          DateTime.now(),
          widget.subTotal,
          widget.discount,
          widget.tax,
          widget.total,
          widget.orderDetail,
          widget.orderName,
          paymentType,
          widget.orderName,
          {
            'Name': widget.orderName,
            'Address': '',
            'Phone': 0,
            'email': '',
          },
          invoiceNo,
          widget.register.registerName,
          false);

      /////Save Sales and Order Categories to database
      DatabaseService()
          .saveOrderType(userProfile.activeBusiness, orderCategories);

      /////////////////////////// MONTH STATS ///////////////////////////

      //Sales Count
      if (currentSalesCount == null || currentSalesCount < 1) {
        newSalesCount = 1;
      } else {
        newSalesCount = currentSalesCount + 1;
      }

      //Set Categories Variables
      orderStats = {};

      //Items Sold
      if (currentTicketItemsCount == null || currentTicketItemsCount < 1) {
        newTicketItemsCount = cartList.length;
      } else {
        newTicketItemsCount = currentTicketItemsCount + cartList.length;
      }

      ////////////////////////////Add amounts by category/account

      //Logic to add up categories totals in current ticket
      for (var i = 0; i < cartList.length; i++) {
        //Check if the map contains the key
        if (salesCountbyCategory.containsKey('${cartList[i]["Category"]}')) {
          //Add to existing category amount
          salesCountbyCategory.update(
              '${cartList[i]["Category"]}',
              (value) =>
                  value + (cartList[i]["Price"] * cartList[i]["Quantity"]));
        } else {
          //Add new category with amount
          salesCountbyCategory['${cartList[i]["Category"]}'] =
              cartList[i]["Price"] * cartList[i]["Quantity"];
        }
      }

      ////////////////////////////Add by item count

      //Logic to add up item count  in current ticket
      for (var i = 0; i < cartList.length; i++) {
        //Check if the map contains the key
        if (currentItemsCount.containsKey('${cartList[i]["Name"]}')) {
          //Add to existing category amount
          currentItemsCount.update('${cartList[i]["Name"]}',
              (value) => value + cartList[i]["Quantity"]);
        } else {
          //Add new category with amount
          currentItemsCount['${cartList[i]["Name"]}'] = cartList[i]["Quantity"];
        }
      }

      //Logic to add up item Amount  in current ticket
      for (var i = 0; i < cartList.length; i++) {
        //Check if the map contains the key
        if (currentItemsAmount.containsKey('${cartList[i]["Name"]}')) {
          //Add to existing category amount
          currentItemsAmount.update(
              '${cartList[i]["Name"]}',
              (value) =>
                  value + (cartList[i]["Price"] * cartList[i]["Quantity"]));
        } else {
          //Add new category with amount
          currentItemsAmount['${cartList[i]["Name"]}'] =
              (cartList[i]["Price"] * cartList[i]["Quantity"]);
        }
      }

      //Logic to add up item sales by order type
      //Check if the map contains the key
      if (currentSalesbyOrderType.containsKey(widget.orderType)) {
        //Add to existing category amount
        currentSalesbyOrderType.update(
            widget.orderType, (value) => value + widget.total);
      } else {
        //Add new category with amount
        currentSalesbyOrderType[widget.orderType] = (widget.total);
      }

      orderStats['Total Sales'] = newSalesAmount;
      orderStats['Total Sales Count'] = newSalesCount;
      orderStats['Total Items Sold'] = newTicketItemsCount;
      orderStats['Sales Count by Product'] = currentItemsCount;
      orderStats['Sales Amount by Product'] = currentItemsAmount;
      orderStats['Sales Count by Category'] = salesCountbyCategory;
      orderStats['Sales by Order Type'] = currentSalesbyOrderType;

      //Save Details to Firestore Historic
      DatabaseService().saveOrderStats(userProfile.activeBusiness, orderStats);

      /////////////////////////// DAILY STATS ///////////////////////////

      //Get current values from Firestore into variables
      try {
        currentDailyItemsCount = dailyTransactions.salesCountbyProduct;
      } catch (e) {
        currentDailyItemsCount = {};
      }
      try {
        currentDailyItemsAmount = dailyTransactions.salesAmountbyProduct;
      } catch (e) {
        currentDailyItemsAmount = {};
      }
      try {
        dailySalesCountbyCategory = dailyTransactions.salesCountbyCategory;
      } catch (e) {
        dailySalesCountbyCategory = {};
      }
      try {
        dailySalesbyOrderType = dailyTransactions.salesbyOrderType;
      } catch (e) {
        dailySalesbyOrderType = {};
      }

      //Sales Count
      newDailySalesCount = dailyTransactions.totalSalesCount + 1;

      //Items Sold
      newDailyTicketItemsCount =
          dailyTransactions.totalItemsSold + cartList.length;

      ////////////////////////////Add amounts by category/account

      //Logic to add up categories totals in current ticket
      for (var i = 0; i < cartList.length; i++) {
        //Check if the map contains the key
        if (dailySalesCountbyCategory
            .containsKey('${cartList[i]["Category"]}')) {
          //Add to existing category amount
          dailySalesCountbyCategory.update(
              '${cartList[i]["Category"]}',
              (value) =>
                  value + (cartList[i]["Price"] * cartList[i]["Quantity"]));
        } else {
          //Add new category with amount
          dailySalesCountbyCategory['${cartList[i]["Category"]}'] =
              cartList[i]["Price"] * cartList[i]["Quantity"];
        }
      }

      ////////////////////////////Add by item count

      //Logic to add up item count  in current ticket
      for (var i = 0; i < cartList.length; i++) {
        //Check if the map contains the key
        if (currentDailyItemsCount.containsKey('${cartList[i]["Name"]}')) {
          //Add to existing category amount
          currentDailyItemsCount.update('${cartList[i]["Name"]}',
              (value) => value + cartList[i]["Quantity"]);
        } else {
          //Add new category with amount
          currentDailyItemsCount['${cartList[i]["Name"]}'] =
              cartList[i]["Quantity"];
        }
      }

      //Logic to add up item Amount  in current ticket
      for (var i = 0; i < cartList.length; i++) {
        //Check if the map contains the key
        if (currentDailyItemsAmount.containsKey('${cartList[i]["Name"]}')) {
          //Add to existing category amount
          currentDailyItemsAmount.update(
              '${cartList[i]["Name"]}',
              (value) =>
                  value + (cartList[i]["Price"] * cartList[i]["Quantity"]));
        } else {
          //Add new category with amount
          currentDailyItemsAmount['${cartList[i]["Name"]}'] =
              (cartList[i]["Price"] * cartList[i]["Quantity"]);
        }
      }

      //Logic to add up item sales by order type
      //Check if the map contains the key
      if (dailySalesbyOrderType.containsKey(widget.orderType)) {
        //Add to existing category amount
        dailySalesbyOrderType.update(
            widget.orderType, (value) => value + widget.total);
      } else {
        //Add new category with amount
        dailySalesbyOrderType[widget.orderType] = (widget.total);
      }

      //Save Details to FB Historic
      DatabaseService().saveDailyOrderStats(
          userProfile.activeBusiness,
          dailyTransactions.openDate.toString(),
          newDailyTicketItemsCount,
          newDailySalesCount,
          currentDailyItemsCount,
          dailySalesCountbyCategory,
          currentDailyItemsAmount,
          dailySalesbyOrderType);

      ///////////////////////////Register in Daily Transactions/////
      double totalDailySales = 0;
      double totalDailyTransactions = 0;
      List salesByMedium = [];
      setState(() {
        totalDailySales = dailyTransactions.sales + widget.total;
        totalDailyTransactions =
            dailyTransactions.dailyTransactions + widget.total;
        salesByMedium = dailyTransactions.salesByMedium;
      });
      /////Update Sales by Medium
      bool listUpdated = false;

      for (var map in salesByMedium) {
        if (map["Type"] == paymentType) {
          map['Amount'] = map['Amount'] + widget.total;
          listUpdated = true;
        }
      }
      if (!listUpdated) {
        salesByMedium.add({'Type': paymentType, 'Amount': widget.total});
      }

      DatabaseService().updateSalesinCashRegister(
          userProfile.activeBusiness,
          dailyTransactions.openDate.toString(),
          totalDailySales,
          salesByMedium,
          totalDailyTransactions);

      //If is table
      if (widget.isTable) {
        DatabaseService().updateTable(
          userProfile.activeBusiness,
          widget.tableCode,
          0,
          0,
          0,
          0,
          [],
          '',
          Colors.white.value,
          false,
          {
            'Name': widget.orderName,
            'Address': '',
            'Phone': 0,
            'email': '',
          },
        );
        DatabaseService().deleteOrder(
            userProfile.activeBusiness, 'Mesa ' + widget.tableCode);
      }

      //If is saved order
      if (widget.isSavedOrder) {
        DatabaseService()
            .deleteOrder(userProfile.activeBusiness, widget.savedOrderID);
      }

      /////////////////Clear Variables
      widget.clearVariables();
      if (widget.onTableView) {
        widget.tablePageController.jumpTo(0);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue(widget.businessID);
    invoiceNo = '00' +
        (DateTime.now().day).toString() +
        (DateTime.now().month).toString() +
        (DateTime.now().year).toString() +
        (DateTime.now().hour).toString() +
        (DateTime.now().minute).toString() +
        (DateTime.now().millisecond).toString();
    paymentType = 'Efectivo';
    otherChanageAmount = false;
    newSalesCount = 0;
    newTicketItemsCount = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyTransactions = Provider.of<DailyTransactions>(context);
    final monthlyStats = Provider.of<MonthlyStats>(context);
    final userProfile = Provider.of<UserData>(context);

    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    if (dailyTransactions == null) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width * 0.35,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment(1.0, 0.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                        iconSize: 20.0),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Ups!...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Debes abrir caja para poder realizar un cobro por el punto de venta. Tambien puedes registrar una venta independiente si así lo deseas",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //Cerrar
                      Container(
                          height: 50,
                          child: OutlinedButton(
                              style: ButtonStyle(
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
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Center(
                                  child: Text(
                                    'Cerrar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ))),
                      SizedBox(width: 20),
                      //Abrir ventas independientes
                      Container(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MultiProvider(
                                          providers: [
                                            StreamProvider<UserData>.value(
                                                initialData: null,
                                                value: DatabaseService()
                                                    .userProfile(uid)),
                                            StreamProvider<MonthlyStats>.value(
                                              value: DatabaseService()
                                                  .monthlyStatsfromSnapshot(
                                                      widget.businessID),
                                              initialData: null,
                                            )
                                          ],
                                          child: Scaffold(
                                              body: NewSaleScreen(
                                                  widget.businessID)),
                                        ))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Center(
                                child: Text('Abirir Venta Independiente'),
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
    }

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

    return FutureBuilder(
        future: currentValuesBuilt,
        builder: (context, snap) {
          // if (snap.connectionState == ConnectionState.done) {
          //   try {
          //     salesAmount = snap.data['Ventas'];
          //   } catch (e) {
          //     //
          //   }

          if (snap.connectionState == ConnectionState.waiting ||
              snap.connectionState == ConnectionState.none) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  height: (paymentType == 'Efectivo') ? 500 : 400,
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

          return SingleChildScrollView(
            child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: (paymentType == 'Efectivo') ? 500 : 400,
                  width: MediaQuery.of(context).size.width * 0.35,
                  constraints: (paymentType == 'Efectivo')
                      ? BoxConstraints(minHeight: 500, minWidth: 400)
                      : BoxConstraints(minHeight: 400, minWidth: 400),
                  child: PageView(
                      controller: controller,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        //Regular Checkout
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Splt / Close
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Split
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white70),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.hovered))
                                              return Colors.grey.shade300;
                                            if (states.contains(
                                                    MaterialState.focused) ||
                                                states.contains(
                                                    MaterialState.pressed))
                                              return Colors.white;
                                            return null; // Defer to the widget's default.
                                          },
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          paymentType = 'Efectivo';
                                        });
                                        for (var i = 0;
                                            i < widget.paymentTypes.length;
                                            i++) {
                                          splitPaymentDetails.add({
                                            'Type': widget.paymentTypes[i]
                                                ['Type'],
                                            'Amount': 0
                                          });
                                        }
                                        controller.nextPage(
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      },
                                      child: Center(
                                          child: Text(
                                        'Split',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                    ),
                                    Spacer(),
                                    //Confirm Text
                                    Text(
                                      "Confirmar pedido",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    //Cancel
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Icons.close),
                                        splashRadius: 5,
                                        iconSize: 20.0),
                                  ]),
                            ),
                            Divider(thickness: 0.5, indent: 0, endIndent: 0),
                            SizedBox(height: 15),
                            //Amount
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Text
                                    Text(
                                      "Total:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    //Amount
                                    Text(
                                      "${formatCurrency.format(widget.total)}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ]),
                            ),
                            Divider(thickness: 0.5, indent: 0, endIndent: 0),
                            SizedBox(
                              height: 15,
                            ),
                            //Change AMOUNT
                            (paymentType == 'Efectivo')
                                ? Container(
                                    width: double.infinity,
                                    height: 50,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //Text
                                          Text(
                                            "Paga con:",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Spacer(),
                                          //Pays with
                                          (!otherChanageAmount)
                                              ? Row(
                                                  children: [
                                                    //500
                                                    OutlinedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .white70),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .hovered))
                                                              return Colors.grey
                                                                  .shade300;
                                                            if (states.contains(
                                                                    MaterialState
                                                                        .focused) ||
                                                                states.contains(
                                                                    MaterialState
                                                                        .pressed))
                                                              return Colors
                                                                  .grey;
                                                            return null; // Defer to the widget's default.
                                                          },
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          paysWith = 500;
                                                        });
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                        '500',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                    ),
                                                    SizedBox(width: 10),
                                                    //1000
                                                    OutlinedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .white70),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .hovered))
                                                              return Colors.grey
                                                                  .shade300;
                                                            if (states.contains(
                                                                    MaterialState
                                                                        .focused) ||
                                                                states.contains(
                                                                    MaterialState
                                                                        .pressed))
                                                              return Colors
                                                                  .grey;
                                                            return null; // Defer to the widget's default.
                                                          },
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          paysWith = 1000;
                                                        });
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                        '1.000',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                    ),
                                                    SizedBox(width: 10),
                                                    //otro
                                                    OutlinedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .white70),
                                                        overlayColor:
                                                            MaterialStateProperty
                                                                .resolveWith<
                                                                    Color>(
                                                          (Set<MaterialState>
                                                              states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .hovered))
                                                              return Colors.grey
                                                                  .shade300;
                                                            if (states.contains(
                                                                    MaterialState
                                                                        .focused) ||
                                                                states.contains(
                                                                    MaterialState
                                                                        .pressed))
                                                              return Colors
                                                                  .grey;
                                                            return null; // Defer to the widget's default.
                                                          },
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          otherChanageAmount =
                                                              true;
                                                        });
                                                      },
                                                      child: Center(
                                                          child: Text(
                                                        'Otro',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  height: 50,
                                                  width: 70,
                                                  child: Center(
                                                    child: TextFormField(
                                                      autofocus: true,
                                                      focusNode:
                                                          otherChangeNode,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 18,
                                                          color: Colors.black),
                                                      validator: (val) =>
                                                          val.contains(',')
                                                              ? "Usa punto"
                                                              : null,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r"[0-9]+[.]?[0-9]*"))
                                                      ],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      cursorColor: Colors.black,
                                                      decoration:
                                                          InputDecoration
                                                              .collapsed(
                                                        hintText: "0",
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey.shade700),
                                                      ),
                                                      onChanged: (val) {
                                                        setState(() =>
                                                            paysWith =
                                                                double.parse(
                                                                    val));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                        ]),
                                  )
                                : Container(),
                            SizedBox(
                              height: (paymentType == 'Efectivo') ? 15 : 0,
                            ),
                            //Change FORMULA
                            (paymentType == 'Efectivo')
                                ? Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //Text
                                        Text(
                                          "Cambio:  ${formatCurrency.format(paysWith - widget.total)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: (paymentType == 'Efectivo') ? 15 : 0,
                            ),
                            (paymentType == 'Efectivo')
                                ? Divider(
                                    thickness: 0.5, indent: 0, endIndent: 0)
                                : Container(),
                            SizedBox(
                              height: 15,
                            ),
                            //Payment type
                            Container(
                              width: double.infinity,
                              height: 60,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Text
                                    Text(
                                      "Método:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    //List of payment methods
                                    Expanded(
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: widget.paymentTypes.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, i) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    paymentType =
                                                        widget.paymentTypes[i]
                                                            ['Type'];
                                                  });
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    height: 45,
                                                    width: 45,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        color: Colors.white,
                                                        border: Border.all(
                                                            color: (paymentType ==
                                                                    widget.paymentTypes[
                                                                            i][
                                                                        'Type'])
                                                                ? Colors.green
                                                                : Colors
                                                                    .white10,
                                                            width: 2),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              widget.paymentTypes[
                                                                  i]['Image']),
                                                          fit: BoxFit.cover,
                                                        )),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ]),
                            ),
                            SizedBox(height: 25),
                            //Buttons
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //To Receivables
                                    Container(
                                      height: 50,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                        ),
                                        onPressed: () {
                                          saveOrder(snap, userProfile,
                                              dailyTransactions, 'Por Cobrar');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('A ventas por cobrar'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    //Confirmar
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                        onPressed: () {
                                          saveOrder(snap, userProfile,
                                              dailyTransactions, paymentType);
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
                        //Split
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Header (back, amount, close)
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Back
                                    IconButton(
                                        onPressed: () {
                                          splitPaymentDetails = [];
                                          controller.previousPage(
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.ease);
                                        },
                                        icon: Icon(Icons.arrow_back)),
                                    Spacer(),
                                    //Amount
                                    Text(
                                      "Total: \$${widget.total}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    //Cancel
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: Icon(Icons.close),
                                        splashRadius: 5,
                                        iconSize: 20.0),
                                  ]),
                            ),
                            Divider(thickness: 0.5, indent: 0, endIndent: 0),
                            SizedBox(height: 15),
                            //List of payment methods
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: splitPaymentDetails.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              //Text
                                              Text(
                                                splitPaymentDetails[i]['Type'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Spacer(),
                                              //Dollar sign
                                              Container(
                                                width: 15,
                                                child: Text(
                                                  "\$",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              //Amount
                                              Container(
                                                height: 50,
                                                width: 70,
                                                child: Center(
                                                  child: TextFormField(
                                                    autofocus: true,
                                                    focusNode: otherChangeNode,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 24,
                                                        color: Colors.black),
                                                    validator: (val) =>
                                                        val.contains(',')
                                                            ? "Usa punto"
                                                            : null,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r"[0-9]+[.]?[0-9]*"))
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                      hintText: "0",
                                                      hintStyle: TextStyle(
                                                          color: Colors
                                                              .grey.shade700),
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        splitPaymentDetails[i]
                                                                ['Amount'] =
                                                            int.parse(val);
                                                      });

                                                      currentSplitAmount = 0;
                                                      for (var i = 0;
                                                          i <
                                                              splitPaymentDetails
                                                                  .length;
                                                          i++) {
                                                        currentSplitAmount =
                                                            currentSplitAmount +
                                                                splitPaymentDetails[
                                                                        i]
                                                                    ['Amount'];
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Divider(
                                                  thickness: 0.5,
                                                  indent: 0,
                                                  endIndent: 0),
                                            ]),
                                      ),
                                    );
                                  }),
                            ),
                            //
                            Divider(thickness: 0.5, indent: 0, endIndent: 0),
                            SizedBox(height: 15),
                            //Remaining
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Text
                                    Text(
                                      "Remanente:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    //Dollar sign
                                    Container(
                                      width: 15,
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    //Amount
                                    Container(
                                      height: 50,
                                      width: 70,
                                      child: Center(
                                        child: Text(
                                          "${widget.total - currentSplitAmount}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            SizedBox(height: 25),
                            //Buttons
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //Confirmar
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              (currentSplitAmount !=
                                                      widget.total)
                                                  ? MaterialStateProperty.all<
                                                      Color>(Colors.grey)
                                                  : MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.hovered))
                                                return Colors.grey;
                                              if (states.contains(
                                                      MaterialState.focused) ||
                                                  states.contains(
                                                      MaterialState.pressed))
                                                return Colors.grey.shade300;
                                              return null; // Defer to the widget's default.
                                            },
                                          ),
                                        ),
                                        onPressed: () {
                                          if (currentSplitAmount !=
                                              widget.total) {
                                            //Do nothing
                                          } else {
                                            double newSalesAmount = 0;
                                            //Date variables
                                            var year =
                                                DateTime.now().year.toString();
                                            var month =
                                                DateTime.now().month.toString();

                                            ////////////////////////Update Accounts (sales and categories)
                                            try {
                                              salesAmount = snap.data['Ventas'];
                                            } catch (e) {
                                              salesAmount = 0;
                                            }

                                            if (salesAmount == null ||
                                                salesAmount < 1) {
                                              newSalesAmount =
                                                  widget.total.toDouble();
                                            } else {
                                              newSalesAmount = salesAmount +
                                                  widget.total.toDouble();
                                            }
                                            //Set Categories Variables
                                            orderCategories = {};
                                            final cartList = widget.items;

                                            //Logic to retrieve and add up categories totals
                                            for (var i = 0;
                                                i < cartList.length;
                                                i++) {
                                              //Check if the map contains the key
                                              if (orderCategories.containsKey(
                                                  'Ventas de ${cartList[i]["Category"]}')) {
                                                //Add to existing category amount
                                                orderCategories.update(
                                                    'Ventas de ${cartList[i]["Category"]}',
                                                    (value) =>
                                                        value +
                                                        (cartList[i]["Price"] *
                                                            cartList[i]
                                                                ["Quantity"]));
                                              } else {
                                                //Add new category with amount
                                                orderCategories[
                                                        'Ventas de ${cartList[i]["Category"]}'] =
                                                    cartList[i]["Price"] *
                                                        cartList[i]["Quantity"];
                                              }
                                            }

                                            //Logic to add Sales by Categories to Firebase based on current Values from snap
                                            orderCategories.forEach((k, v) {
                                              try {
                                                orderCategories.update(
                                                    k,
                                                    (value) => v =
                                                        v + snap.data['$k']);
                                              } catch (e) {
                                                //Do nothing
                                              }
                                            });

                                            // Add Total sales edited to map
                                            orderCategories['Ventas'] =
                                                newSalesAmount;

                                            // Create Sale
                                            DatabaseService().createOrder(
                                                userProfile.activeBusiness,
                                                year,
                                                month,
                                                DateTime.now(),
                                                widget.subTotal,
                                                widget.discount,
                                                widget.tax,
                                                widget.total,
                                                widget.orderDetail,
                                                widget.orderName,
                                                'Split',
                                                widget.orderName,
                                                {
                                                  'Name': widget.orderName,
                                                  'Address': '',
                                                  'Phone': 0,
                                                  'email': '',
                                                },
                                                invoiceNo,
                                                widget.register.registerName,
                                                false);

                                            ///Save Sales and Order Categories to database
                                            DatabaseService().saveOrderType(
                                                userProfile.activeBusiness,
                                                orderCategories);

                                            ///////////////////////// MONTH STATS ///////////////////////////

                                            // Sales Count
                                            if (currentSalesCount == null ||
                                                currentSalesCount < 1) {
                                              newSalesCount = 1;
                                            } else {
                                              newSalesCount =
                                                  currentSalesCount + 1;
                                            }

                                            // Set Categories Variables
                                            orderStats = {};

                                            // Items Sold
                                            if (currentTicketItemsCount ==
                                                    null ||
                                                currentTicketItemsCount < 1) {
                                              newTicketItemsCount =
                                                  cartList.length;
                                            } else {
                                              newTicketItemsCount =
                                                  currentTicketItemsCount +
                                                      cartList.length;
                                            }

                                            //////////////////////////Add amounts by category/account///////////////////

                                            //Logic to add up categories totals in current ticket
                                            for (var i = 0;
                                                i < cartList.length;
                                                i++) {
                                              //Check if the map contains the key
                                              if (salesCountbyCategory.containsKey(
                                                  '${cartList[i]["Category"]}')) {
                                                // Add to existing category amount
                                                salesCountbyCategory.update(
                                                    '${cartList[i]["Category"]}',
                                                    (value) =>
                                                        value +
                                                        (cartList[i]["Price"] *
                                                            cartList[i]
                                                                ["Quantity"]));
                                              } else {
                                                //Add new category with amount
                                                salesCountbyCategory[
                                                        '${cartList[i]["Category"]}'] =
                                                    cartList[i]["Price"] *
                                                        cartList[i]["Quantity"];
                                              }
                                            }

                                            //////////////////////////Add by item count///////////////////

                                            // Logic to add up item count  in current ticket
                                            for (var i = 0;
                                                i < cartList.length;
                                                i++) {
                                              //Check if the map contains the key
                                              if (currentItemsCount.containsKey(
                                                  '${cartList[i]["Name"]}')) {
                                                //Add to existing category amount
                                                currentItemsCount.update(
                                                    '${cartList[i]["Name"]}',
                                                    (value) =>
                                                        value +
                                                        cartList[i]
                                                            ["Quantity"]);
                                              } else {
                                                //Add new category with amount
                                                currentItemsCount[
                                                        '${cartList[i]["Name"]}'] =
                                                    cartList[i]["Quantity"];
                                              }
                                            }

                                            // Logic to add up item Amount  in current ticket
                                            for (var i = 0;
                                                i < cartList.length;
                                                i++) {
                                              //   Check if the map contains the key
                                              if (currentItemsAmount.containsKey(
                                                  '${cartList[i]["Name"]}')) {
                                                //     Add to existing category amount
                                                currentItemsAmount.update(
                                                    '${cartList[i]["Name"]}',
                                                    (value) =>
                                                        value +
                                                        (cartList[i]["Price"] *
                                                            cartList[i]
                                                                ["Quantity"]));
                                              } else {
                                                //     Add new category with amount
                                                currentItemsAmount[
                                                        '${cartList[i]["Name"]}'] =
                                                    (cartList[i]["Price"] *
                                                        cartList[i]
                                                            ["Quantity"]);
                                              }
                                            }

                                            //Logic to add up item sales by order type
                                            //Check if the map contains the key
                                            if (currentSalesbyOrderType
                                                .containsKey(
                                                    widget.orderType)) {
                                              //Add to existing category amount
                                              currentSalesbyOrderType.update(
                                                  widget.orderType,
                                                  (value) =>
                                                      value + widget.total);
                                            } else {
                                              //Add new category with amount
                                              currentSalesbyOrderType[widget
                                                  .orderType] = (widget.total);
                                            }

                                            orderStats['Total Sales'] =
                                                newSalesAmount;
                                            orderStats['Total Sales Count'] =
                                                newSalesCount;
                                            orderStats['Total Items Sold'] =
                                                newTicketItemsCount;
                                            orderStats[
                                                    'Sales Count by Product'] =
                                                currentItemsCount;
                                            orderStats[
                                                    'Sales Amount by Product'] =
                                                currentItemsAmount;
                                            orderStats[
                                                    'Sales Count by Category'] =
                                                salesCountbyCategory;
                                            orderStats['Sales by Order Type'] =
                                                currentSalesbyOrderType;

                                            // Save Details to FB Historic
                                            DatabaseService().saveOrderStats(
                                                userProfile.activeBusiness,
                                                orderStats);

                                            ///////////////////////// DAILY STATS ///////////////////////////

                                            // Get current values from Firestore into variables
                                            try {
                                              currentDailyItemsCount =
                                                  dailyTransactions
                                                      .salesCountbyProduct;
                                            } catch (e) {
                                              currentDailyItemsCount = {};
                                            }
                                            try {
                                              currentDailyItemsAmount =
                                                  dailyTransactions
                                                      .salesAmountbyProduct;
                                            } catch (e) {
                                              currentDailyItemsAmount = {};
                                            }
                                            try {
                                              dailySalesCountbyCategory =
                                                  dailyTransactions
                                                      .salesCountbyCategory;
                                            } catch (e) {
                                              dailySalesCountbyCategory = {};
                                            }
                                            try {
                                              dailySalesbyCategory =
                                                  dailyTransactions
                                                      .salesbyCategory;
                                            } catch (e) {
                                              dailySalesbyCategory = {};
                                            }
                                            try {
                                              dailySalesbyOrderType =
                                                  dailyTransactions
                                                      .salesbyOrderType;
                                            } catch (e) {
                                              dailySalesbyOrderType = {};
                                            }

                                            //Sales Count
                                            newDailySalesCount =
                                                dailyTransactions
                                                        .totalSalesCount +
                                                    1;

                                            //Items Sold
                                            newDailyTicketItemsCount =
                                                dailyTransactions
                                                        .totalItemsSold +
                                                    cartList.length;

                                            //////////////////////////Add amounts by category/account

                                            // Logic to add up categories count
                                            for (var i = 0;
                                                i < cartList.length;
                                                i++) {
                                              //   Check if the map contains the key
                                              if (dailySalesCountbyCategory
                                                  .containsKey(
                                                      '${cartList[i]["Category"]}')) {
                                                //     Add to existing category amount
                                                dailySalesCountbyCategory.update(
                                                    '${cartList[i]["Category"]}',
                                                    (value) =>
                                                        value +
                                                        (cartList[i]["Price"] *
                                                            cartList[i]
                                                                ["Quantity"]));
                                              } else {
                                                //     Add new category with amount
                                                dailySalesCountbyCategory[
                                                        '${cartList[i]["Category"]}'] =
                                                    cartList[i]["Price"] *
                                                        cartList[i]["Quantity"];
                                              }
                                            }

                                            // //////////////////////////Add by item count

                                            // Logic to add up item count  in current ticket
                                            for (var i = 0;
                                                i < cartList.length;
                                                i++) {
                                              //   Check if the map contains the key
                                              if (currentDailyItemsCount
                                                  .containsKey(
                                                      '${cartList[i]["Name"]}')) {
                                                //     Add to existing category amount
                                                currentDailyItemsCount.update(
                                                    '${cartList[i]["Name"]}',
                                                    (value) =>
                                                        value +
                                                        cartList[i]
                                                            ["Quantity"]);
                                              } else {
                                                //     Add new category with amount
                                                currentDailyItemsCount[
                                                        '${cartList[i]["Name"]}'] =
                                                    cartList[i]["Quantity"];
                                              }
                                            }

                                            // Logic to add up item Amount  in current ticket
                                            for (var i = 0;
                                                i < cartList.length;
                                                i++) {
                                              //   Check if the map contains the key
                                              if (currentDailyItemsAmount
                                                  .containsKey(
                                                      '${cartList[i]["Name"]}')) {
                                                //     Add to existing category amount
                                                currentDailyItemsAmount.update(
                                                    '${cartList[i]["Name"]}',
                                                    (value) =>
                                                        value +
                                                        (cartList[i]["Price"] *
                                                            cartList[i]
                                                                ["Quantity"]));
                                              } else {
                                                //     Add new category with amount
                                                currentDailyItemsAmount[
                                                        '${cartList[i]["Name"]}'] =
                                                    (cartList[i]["Price"] *
                                                        cartList[i]
                                                            ["Quantity"]);
                                              }
                                            }

                                            //Logic to add up item sales by order type
                                            //Check if the map contains the key
                                            if (dailySalesbyOrderType
                                                .containsKey(
                                                    widget.orderType)) {
                                              //Add to existing category amount
                                              dailySalesbyOrderType.update(
                                                  widget.orderType,
                                                  (value) =>
                                                      value + widget.total);
                                            } else {
                                              //Add new category with amount
                                              dailySalesbyOrderType[widget
                                                  .orderType] = (widget.total);
                                            }

                                            // Save Details to FB Historic
                                            DatabaseService()
                                                .saveDailyOrderStats(
                                                    userProfile.activeBusiness,
                                                    dailyTransactions.openDate
                                                        .toString(),
                                                    newDailyTicketItemsCount,
                                                    newDailySalesCount,
                                                    currentDailyItemsCount,
                                                    dailySalesCountbyCategory,
                                                    currentDailyItemsAmount,
                                                    dailySalesbyOrderType);

                                            ///////////////////////////Register in Daily Transactions
                                            double totalDailySales = 0;
                                            double totalDailyTransactions = 0;
                                            List salesByMedium = [];
                                            setState(() {
                                              totalDailySales =
                                                  dailyTransactions.sales +
                                                      widget.total;
                                              totalDailyTransactions =
                                                  dailyTransactions
                                                          .dailyTransactions +
                                                      widget.total;
                                              salesByMedium = dailyTransactions
                                                  .salesByMedium;
                                            });

                                            ///Update Sales by Medium

                                            for (var x in splitPaymentDetails) {
                                              bool listUpdated = false;
                                              for (var map in salesByMedium) {
                                                if (map["Type"] == x['Type']) {
                                                  map['Amount'] =
                                                      map['Amount'] +
                                                          x['Amount'];
                                                  listUpdated = true;
                                                }
                                              }
                                              if (!listUpdated) {
                                                salesByMedium.add({
                                                  'Type': x['Type'],
                                                  'Amount': x['Amount']
                                                });
                                              }
                                            }

                                            DatabaseService()
                                                .updateSalesinCashRegister(
                                                    userProfile.activeBusiness,
                                                    dailyTransactions.openDate
                                                        .toString(),
                                                    totalDailySales,
                                                    salesByMedium,
                                                    totalDailyTransactions);

                                            //If is table
                                            if (widget.isTable) {
                                              DatabaseService().updateTable(
                                                userProfile.activeBusiness,
                                                widget.tableCode,
                                                0,
                                                0,
                                                0,
                                                0,
                                                [],
                                                '',
                                                Colors.white.value,
                                                false,
                                                {
                                                  'Name': widget.orderName,
                                                  'Address': '',
                                                  'Phone': 0,
                                                  'email': '',
                                                },
                                              );
                                              DatabaseService().deleteOrder(
                                                  userProfile.activeBusiness,
                                                  'Mesa ' + widget.tableCode);
                                            }

                                            //If is saved order
                                            if (widget.isSavedOrder) {
                                              DatabaseService().deleteOrder(
                                                  userProfile.activeBusiness,
                                                  widget.savedOrderID);
                                            }

                                            /////////////////Clear Variables
                                            widget.clearVariables();
                                            if ((widget.onTableView &&
                                                    widget.isTable) ||
                                                (widget.onTableView &&
                                                    widget.isSavedOrder)) {
                                              widget.tablePageController
                                                  .jumpTo(0);
                                            }
                                            Navigator.of(context).pop();
                                          }
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
                      ]),
                )),
          );
        });
  }
}
