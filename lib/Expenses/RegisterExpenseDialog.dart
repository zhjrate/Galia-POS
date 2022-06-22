import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterExpenseDialog extends StatefulWidget {
  final String costType;
  final String selectedCategory;
  final String selectedAccount;
  final String selectedVendor;
  final String expenseDescription;
  final int qty;
  final double price;
  final double total;
  final CashRegister registerStatus;
  final DailyTransactions dailyTransactions;
  final clearVariables;

  RegisterExpenseDialog(
      this.costType,
      this.selectedVendor,
      this.selectedAccount,
      this.selectedCategory,
      this.expenseDescription,
      this.qty,
      this.price,
      this.total,
      this.registerStatus,
      this.dailyTransactions,
      this.clearVariables);

  get currentRegister => null;

  String get transactionType => null;

  @override
  _RegisterExpenseDialogState createState() => _RegisterExpenseDialogState();
}

class _RegisterExpenseDialogState extends State<RegisterExpenseDialog> {
  String paymentType = 'Efectivo';
  double currentCostTypeAmount = 0;
  double currentAccountAmount = 0;
  double currentCategoryAmount = 0;
  Future currentValuesBuilt;
  bool isChecked;
  double cashRegisterAmount = 0;
  bool useEntireAmount;

  Future currentValue() async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();

    var firestore = FirebaseFirestore.instance;

    var docRef =
        firestore.collection('ERP').doc(uid).collection(year).doc(month).get();
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

  Widget checkBox() {
    return Container(
      height: 40,
      width: 40,
      child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            side: MaterialStateProperty.all(
                BorderSide(width: 2, color: Colors.green)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered))
                  return Colors.grey.shade50;
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed))
                  return Colors.grey.shade200;
                return null; // Defer to the widget's default.
              },
            ),
          ),
          onPressed: () {
            setState(() {
              isChecked = !isChecked;
            });

            if (isChecked) {
              useEntireAmount = true;
              setState(() {
                cashRegisterAmount = widget.total;
              });
            }
          },
          child: Center(
              child: Icon(Icons.check,
                  color: isChecked ? Colors.green : Colors.transparent))),
    );
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue();
    isChecked = false;
    useEntireAmount = false;
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
                      //Go back
                      Container(
                        alignment: Alignment(1.0, 0.0),
                        child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                            iconSize: 20.0),
                      ),
                      //Title
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
                      //Payment Buttons
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
                        height: 5,
                      ),
                      //Use cashier money text
                      (paymentType == 'Efectivo' &&
                              widget.registerStatus != null)
                          ? Text(
                              "¿Usar dinero de la caja?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 12,
                      ),
                      //Use money in petty cash?
                      (paymentType == 'Efectivo')
                          ? Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  checkBox(),
                                  isChecked ? SizedBox(width: 15) : Container(),
                                  isChecked
                                      ? Container(
                                          width: 100,
                                          height: 40,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                            autofocus: true,
                                            validator: (val) => val.isEmpty
                                                ? "No olvides agregar un monto"
                                                : null,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            cursorColor: Colors.grey,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: "¿Cuánto?",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                            onChanged: (val) {
                                              setState(() =>
                                                  cashRegisterAmount =
                                                      double.parse(val));
                                              useEntireAmount = false;
                                            },
                                          ),
                                        )
                                      : Container(),
                                  isChecked ? SizedBox(width: 15) : Container(),
                                  isChecked
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                            side: MaterialStateProperty.all(
                                                BorderSide(
                                                    width: 2,
                                                    color: useEntireAmount
                                                        ? Colors.green
                                                        : Colors.white)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered))
                                                  return Colors.grey.shade100;
                                                if (states.contains(
                                                        MaterialState
                                                            .focused) ||
                                                    states.contains(
                                                        MaterialState.pressed))
                                                  return Colors.grey.shade200;
                                                return null; // Defer to the widget's default.
                                              },
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              useEntireAmount =
                                                  !useEntireAmount;
                                              cashRegisterAmount = widget.total;
                                            });
                                          },
                                          child: Center(
                                              child: Text(
                                            'Todo el importe',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: useEntireAmount
                                                    ? Colors.green
                                                    : Colors.grey,
                                                fontSize: 11),
                                          )))
                                      : Container(),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 25,
                      ),
                      //Boton
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

                            ///////////If we use money in cash register ///////////////
                            if (isChecked &&
                                widget.registerStatus.registerisOpen) {
                              double totalTransactionAmount =
                                  widget.dailyTransactions.outflows +
                                      cashRegisterAmount;

                              double totalTransactions =
                                  widget.dailyTransactions.dailyTransactions -
                                      cashRegisterAmount;

                              DatabaseService().updateCashRegister(
                                  widget.registerStatus.registerName,
                                  'Egresos',
                                  totalTransactionAmount,
                                  totalTransactions, {
                                'Amount': cashRegisterAmount,
                                'Type': widget.costType,
                                'Motive': widget.expenseDescription,
                                'Time': DateTime.now()
                              });
                            }

                            //Clear Expenses Variables and go back
                            widget.clearVariables();
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
