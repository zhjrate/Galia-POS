import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConfirmWastage extends StatefulWidget {
  final double total;
  final orderDetail;
  final clearVariables;
  final dynamic items;
  final String ticketConcept;

  final TextEditingController controller;

  ConfirmWastage(
      {this.total,
      this.orderDetail,
      this.controller,
      this.clearVariables,
      this.items,
      this.ticketConcept});

  @override
  _ConfirmWastageState createState() => _ConfirmWastageState();
}

class _ConfirmWastageState extends State<ConfirmWastage> {
  Map<String, dynamic> wastageCategories;
  Future currentValuesBuilt;
  double currentWastageAmount;
  Map<String, dynamic> currentWastagebyItem;
  double newWastageAmount;

  Future currentValue() async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();
    var firestore = FirebaseFirestore.instance;
    final User user = FirebaseAuth.instance.currentUser;
    final String uid = user.uid.toString();
    String wastageDocument;

    if (widget.ticketConcept == 'Desperdicios') {
      wastageDocument = 'Wastage';
    } else {
      wastageDocument = 'Consumo de Empleados';
    }

    var docRef = firestore
        .collection('ERP')
        .doc(uid)
        .collection(year)
        .doc(month)
        .collection('Wastage and Employee Consumption')
        .doc(wastageDocument)
        .get();
    return docRef;
  }

  @override
  void initState() {
    newWastageAmount = 0;
    currentValuesBuilt = currentValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentValuesBuilt,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            try {
              currentWastageAmount = snap.data['Total'];
            } catch (e) {
              //
            }
            try {
              currentWastagebyItem = snap.data['Products'];
            } catch (e) {
              currentWastagebyItem = {};
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
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: Icon(Icons.close),
                                      splashRadius: 5,
                                      iconSize: 20.0),
                                )),
                            SizedBox(height: 20),
                            //Text
                            Center(
                                child: Text(
                              'Confirmar registro como desperdicio/consumo interno',
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
                                          ////////////////////////Update Accounts (sales and categories)
                                          if (currentWastageAmount == null ||
                                              currentWastageAmount < 1) {
                                            newWastageAmount =
                                                widget.total.toDouble();
                                          } else {
                                            newWastageAmount =
                                                currentWastageAmount +
                                                    widget.total.toDouble();
                                          }

                                          //Set Categories Variables
                                          wastageCategories = {};
                                          final cartList = widget.items;

                                          ////////////////////////////Add amounts by category/account///////////////////

                                          //Logic to add up categories totals in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (wastageCategories.containsKey(
                                                '${cartList[i]["Category"]}')) {
                                              //Add to existing category amount
                                              wastageCategories.update(
                                                  '${cartList[i]["Category"]}',
                                                  (value) =>
                                                      value +
                                                      (cartList[i]["Price"] *
                                                          cartList[i]
                                                              ["Quantity"]));
                                            } else {
                                              //Add new category with amount
                                              wastageCategories[
                                                      '${cartList[i]["Category"]}'] =
                                                  cartList[i]["Price"] *
                                                      cartList[i]["Quantity"];
                                            }
                                          }
                                          //Logic to add Sales by Categories to Firebase based on current Values from snap
                                          wastageCategories.forEach((k, v) {
                                            try {
                                              wastageCategories.update(
                                                  k,
                                                  (value) =>
                                                      v = v + snap.data['$k']);
                                            } catch (e) {
                                              //Do nothing
                                            }
                                          });

                                          ////////////////////////////Add by item count///////////////////

                                          //Logic to add up categories totals in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (currentWastagebyItem
                                                .containsKey(
                                                    '${cartList[i]["Name"]}')) {
                                              //Add to existing category amount
                                              currentWastagebyItem.update(
                                                  '${cartList[i]["Name"]}',
                                                  (value) =>
                                                      value +
                                                      cartList[i]["Quantity"]);
                                            } else {
                                              //Add new category with amount
                                              currentWastagebyItem[
                                                      '${cartList[i]["Name"]}'] =
                                                  cartList[i]["Quantity"];
                                            }
                                          }

                                          wastageCategories['Products'] =
                                              currentWastagebyItem;

                                          //Add Total sales edited to map
                                          wastageCategories['Total'] =
                                              newWastageAmount;

                                          //Save Details to FB Historic
                                          DatabaseService().createWastage(
                                              DateTime.now().year.toString(),
                                              DateTime.now().month.toString(),
                                              DateTime.now().toString(),
                                              widget.total * 0.5,
                                              widget.total,
                                              widget.orderDetail);

                                          DatabaseService().saveWastageDetails(
                                              widget.ticketConcept,
                                              wastageCategories);

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
          } else {
            return Container();
          }
        });
  }
}
