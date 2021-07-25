import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatefulWidget {
  final double total;
  final dynamic items;

  final double subTotal;
  final double discount;
  final double tax;
  final orderDetail;
  final String orderName;
  final String paymentType;
  final clearVariables;

  final TextEditingController controller;

  ConfirmOrder(
      {this.total,
      this.items,
      this.discount,
      this.orderDetail,
      this.orderName,
      this.paymentType,
      this.subTotal,
      this.tax,
      this.controller,
      this.clearVariables});

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  Map<String, dynamic> orderCategories;
  Future currentValuesBuilt;
  double salesAmount;

  Future currentValue() async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    var firestore = FirebaseFirestore.instance;

    var docRef = firestore
        .collection('ERP')
        .doc('VTam7iYZhiWiAFs3IVRBaLB5s3m2')
        .collection(year)
        .doc(month)
        .get();
    return docRef;
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    if (dailyTransactions == null) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            width: (MediaQuery.of(context).size.width > 900)
                ? 600
                : MediaQuery.of(context).size.width * 0.8,
            height: 250,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: (MediaQuery.of(context).size.width > 900)
                              ? 400
                              : MediaQuery.of(context).size.width * 0.5),
                      child: Text(
                        "Recuerda abrir caja antes de procesar pedidos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ));
    }

    return FutureBuilder(
        future: currentValuesBuilt,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            try {
              salesAmount = snap.data['Ventas'];
            } catch (e) {
              //
            }

            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  width: (MediaQuery.of(context).size.width > 900)
                      ? 600
                      : MediaQuery.of(context).size.width * 0.8,
                  height: 250,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: (MediaQuery.of(context).size.width >
                                        900)
                                    ? 400
                                    : MediaQuery.of(context).size.width * 0.5),
                            child: Text(
                              "Confirmar pedido por \$${widget.total} con ${widget.paymentType}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Volver
                              Container(
                                height: 35.0,
                                child: RaisedButton(
                                  color: Colors.grey,
                                  onPressed: () => Navigator.pop(context),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 150.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "VOLVER",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800]),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              //Confirmar
                              Container(
                                height: 35.0,
                                child: RaisedButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    double newSalesAmount = 0;
                                    //Date variables
                                    var year = DateTime.now().year.toString();
                                    var month = DateTime.now().month.toString();

                                    ////////////////////////Update Accounts (sales and categories)
                                    if (salesAmount == null ||
                                        salesAmount < 1) {
                                      newSalesAmount = widget.total.toDouble();
                                    } else {
                                      newSalesAmount =
                                          salesAmount + widget.total.toDouble();
                                    }
                                    //Set Categories Variables
                                    orderCategories = {};
                                    final cartList = widget.items;

                                    //Logic to retrieve and add up categories totals
                                    for (var i = 0; i < cartList.length; i++) {
                                      //Check if the map contains the key
                                      if (orderCategories.containsKey(
                                          'Ventas de ${cartList[i]["Category"]}')) {
                                        //Add to existing category amount
                                        orderCategories.update(
                                            'Ventas de ${cartList[i]["Category"]}',
                                            (value) =>
                                                value +
                                                (cartList[i]["Price"] *
                                                    cartList[i]["Quantity"]));
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
                                        orderCategories.update(k,
                                            (value) => v = v + snap.data['$k']);
                                      } catch (e) {
                                        //Do nothing
                                      }
                                    });
                                    //Add Total sales edited to map
                                    orderCategories['Ventas'] = newSalesAmount;

                                    //Create Sale
                                    DatabaseService().createOrder(
                                        year,
                                        month,
                                        DateTime.now().toString(),
                                        widget.subTotal,
                                        widget.discount,
                                        widget.tax,
                                        widget.total,
                                        widget.orderDetail,
                                        widget.orderName,
                                        widget.paymentType);

                                    /////Save Sales and Order Categories to database
                                    DatabaseService()
                                        .saveOrderType(orderCategories);

                                    ///////////////////////////Register in Daily Transactions
                                    double totalDailySales = 0;
                                    double totalDailyTransactions = 0;
                                    List salesByMedium = [];
                                    setState(() {
                                      totalDailySales =
                                          dailyTransactions.sales +
                                              widget.total;
                                      totalDailyTransactions =
                                          dailyTransactions.dailyTransactions +
                                              widget.total;
                                      salesByMedium =
                                          dailyTransactions.salesByMedium;
                                    });
                                    /////Update Sales by Medium
                                    bool listUpdated = false;

                                    for (var map in salesByMedium) {
                                      if (map["Type"] == widget.paymentType) {
                                        map['Amount'] =
                                            map['Amount'] + widget.total;
                                        listUpdated = true;
                                      }
                                    }
                                    if (!listUpdated) {
                                      salesByMedium.add({
                                        'Type': widget.paymentType,
                                        'Amount': widget.total
                                      });
                                    }

                                    DatabaseService().updateSalesinCashRegister(
                                        dailyTransactions.openDate.toString(),
                                        totalDailySales,
                                        salesByMedium,
                                        totalDailyTransactions);

                                    /////////////////Clear Variables
                                    widget.clearVariables();
                                    Navigator.of(context).pop();
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 150.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "CONFIRMAR",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ));
          } else {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  width: (MediaQuery.of(context).size.width > 900)
                      ? 600
                      : MediaQuery.of(context).size.width * 0.8,
                  height: 250,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: (MediaQuery.of(context).size.width >
                                        900)
                                    ? 400
                                    : MediaQuery.of(context).size.width * 0.5),
                            child: Text(
                              "Confirmar pedido por \$${widget.total} con ${widget.paymentType}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Volver
                              Container(
                                height: 35.0,
                                child: RaisedButton(
                                  color: Colors.grey,
                                  onPressed: () => Navigator.pop(context),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 150.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "VOLVER",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800]),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              //Confirmar
                              Container(
                                height: 35.0,
                                child: RaisedButton(
                                  color: Colors.grey,
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 150.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "CONFIRMAR",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[800]),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ));
          }
        });
  }
}
