import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:flutter/material.dart';

class RegisterExpenseDialog extends StatefulWidget {
  final String costType;
  final String selectedCategory;
  final String selectedAccount;
  final String selectedVendor;
  final String expenseDescription;
  final int qty;
  final double price;
  final double total;

  RegisterExpenseDialog(
      this.costType,
      this.selectedVendor,
      this.selectedAccount,
      this.selectedCategory,
      this.expenseDescription,
      this.qty,
      this.price,
      this.total);

  @override
  _RegisterExpenseDialogState createState() => _RegisterExpenseDialogState();
}

class _RegisterExpenseDialogState extends State<RegisterExpenseDialog> {
  String paymentType = 'Efectivo';
  double currentCostTypeAmount = 0;
  double currentAccountAmount = 0;
  double currentCategoryAmount = 0;
  Future currentValuesBuilt;

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

  Widget paymentButton(String type, String imagePath) {
    return GestureDetector(
        onTap: () {
          setState(() {
            paymentType = type;
          });
        },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                    border: Border.all(
                        color: (paymentType == type)
                            ? Colors.green
                            : Colors.white10,
                        width: 2),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    )),
              ),
              SizedBox(height: 15),
              Container(
                  width: 120,
                  height: 50,
                  child: Text(
                    type,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.grey[400]),
                    textAlign: TextAlign.center,
                  ))
            ]));
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currentValuesBuilt,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            currentCostTypeAmount =
                snapshot.data[widget.costType] + widget.total;
          } catch (e) {
            currentCostTypeAmount = widget.total;
          }

          try {
            currentAccountAmount =
                snapshot.data[widget.selectedAccount] + widget.total;
          } catch (e) {
            currentAccountAmount = widget.total;
          }

          try {
            currentCategoryAmount =
                snapshot.data[widget.selectedCategory] + widget.total;
          } catch (e) {
            currentCategoryAmount = widget.total;
          }

          return SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                width: 600,
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
                        child: Text(
                          "Método de pago",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: //Payment type
                            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Efectivo
                            paymentButton('Efectivo', 'images/Cash.png'),
                            //MercadoPago
                            paymentButton('MercadoPago', 'images/MP.png'),
                            //Card
                            paymentButton('Tarjeta', 'images/CreditCard.png'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        height: 35.0,
                        child: RaisedButton(
                          color: Colors.black,
                          onPressed: () {
                            DatabaseService().saveExpense(
                                widget.costType,
                                widget.selectedCategory,
                                widget.selectedAccount,
                                widget.selectedVendor,
                                widget.expenseDescription,
                                widget.qty,
                                widget.price,
                                widget.total,
                                paymentType);
                            DatabaseService().saveExpenseType(
                                widget.costType,
                                widget.selectedCategory,
                                widget.selectedAccount,
                                currentCostTypeAmount,
                                currentAccountAmount,
                                currentCategoryAmount);

                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "REGISTRAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center();
        }
      },
    );
  }
}
