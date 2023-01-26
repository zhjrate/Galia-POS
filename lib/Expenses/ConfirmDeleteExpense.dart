import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteExpense extends StatefulWidget {
  final String businessID;
  final Expenses expense;
  final CashRegister registerStatus;
  final DailyTransactions dailyTransactions;
  const ConfirmDeleteExpense(this.businessID, this.expense, this.registerStatus,
      this.dailyTransactions,
      {Key key})
      : super(key: key);

  @override
  State<ConfirmDeleteExpense> createState() => _ConfirmDeleteExpenseState();
}

class _ConfirmDeleteExpenseState extends State<ConfirmDeleteExpense> {
  Future currentValue(businessID) async {
    var firestore = FirebaseFirestore.instance;
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    var docRef = firestore
        .collection('ERP')
        .doc(businessID)
        .collection(year)
        .doc(month)
        .get();
    return docRef;
  }

  Future currentValuesBuilt;

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue(widget.businessID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      '¿Deseas eliminar este gasto?',
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
                                //Get items as map
                                List<Map> items = [];

                                for (var i = 0;
                                    i < widget.expense.items.length;
                                    i++) {
                                  items.add({
                                    'Name': widget.expense.items[i].product,
                                    'Category':
                                        widget.expense.items[i].category,
                                    'Price': widget.expense.items[i].price,
                                    'Quantity': widget.expense.items[i].qty,
                                    'Total Price': widget.expense.items[i].total
                                  });
                                }

                                //////////Save expense as negative
                                DatabaseService().saveExpense(
                                    widget.businessID,
                                    widget.expense.costType,
                                    widget.expense.vendor,
                                    widget.expense.total * -1,
                                    widget.expense.paymentType,
                                    items,
                                    widget.expense.date,
                                    DateTime.now().year.toString(),
                                    DateTime.now().month.toString(),
                                    widget.expense.cashRegister,
                                    true,
                                    widget.expense.usedCashfromRegister,
                                    widget.expense.amountFromRegister,
                                    widget.expense.expenseID + '-1',
                                    setSearchParam(widget.expense.vendor));

                                //Record in sales list as negative
                                DatabaseService().markExpenseReversed(
                                    widget.businessID,
                                    widget.expense.expenseID,
                                    widget.expense.date.year.toString(),
                                    widget.expense.date.month.toString());

                                //Delete from PnL
                                var currentCostTypeAmount;

                                currentCostTypeAmount =
                                    snap.data[widget.expense.costType] -
                                        widget.expense.total;

                                //Create map to get categories totals
                                Map<String, dynamic> expenseCategories = {};

                                for (var i = 0; i < items.length; i++) {
                                  if (widget.expense.costType ==
                                      'Costo de Ventas') {
                                    //Check if the map contains the key
                                    if (expenseCategories.containsKey(
                                        'Costos de ${items[i]["Category"]}')) {
                                      //Add to existing category amount
                                      expenseCategories.update(
                                          'Costos de ${items[i]["Category"]}',
                                          (value) =>
                                              value +
                                              (items[i]["Price"] *
                                                  items[i]["Quantity"]));
                                    } else {
                                      //Add new category with amount
                                      expenseCategories[
                                              'Costos de ${items[i]["Category"]}'] =
                                          items[i]["Price"] *
                                              items[i]["Quantity"];
                                    }
                                  } else {
                                    //Check if the map contains the key
                                    if (expenseCategories.containsKey(
                                        '${items[i]["Category"]}')) {
                                      //Add to existing category amount
                                      expenseCategories.update(
                                          '${items[i]["Category"]}',
                                          (value) =>
                                              value +
                                              (items[i]["Price"] *
                                                  items[i]["Quantity"]));
                                    } else {
                                      //Add new category with amount
                                      expenseCategories[
                                          '${items[i]["Category"]}'] = items[i]
                                              ["Price"] *
                                          items[i]["Quantity"];
                                    }
                                  }
                                }
                                //Logic to add Sales by Categories to Firebase based on current Values from snap
                                expenseCategories.forEach((k, v) {
                                  try {
                                    expenseCategories.update(
                                        k, (value) => v = snap.data['$k'] - v);
                                  } catch (e) {
                                    //Do nothing
                                  }
                                });

                                //Add cost type account to MAP
                                expenseCategories[widget.expense.costType] =
                                    currentCostTypeAmount;

                                DatabaseService().saveExpenseType(
                                    widget.businessID,
                                    expenseCategories,
                                    widget.expense.date.year.toString(),
                                    widget.expense.date.month.toString());

                                //If cash register is open and it was on current and it was cash, reverse

                                if (widget.expense.paymentType == 'Efectivo' &&
                                    widget.expense.usedCashfromRegister ==
                                        true &&
                                    widget.expense.cashRegister ==
                                        widget.registerStatus.registerName) {
                                  double totalTransactionAmount =
                                      widget.dailyTransactions.outflows -
                                          widget.expense.amountFromRegister;

                                  double totalTransactions = widget
                                          .dailyTransactions.dailyTransactions +
                                      widget.expense.amountFromRegister;

                                  DatabaseService().updateCashRegister(
                                      widget.businessID,
                                      widget.registerStatus.registerName,
                                      'Ingresos',
                                      totalTransactionAmount,
                                      totalTransactions, {
                                    'Amount': widget.expense.amountFromRegister,
                                    'Type': 'Anulación de gasto',
                                    'Motive':
                                        'Reversa de ${widget.expense.costType}',
                                    'Time': DateTime.now()
                                  });
                                }

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
                                      'Eliminar gasto',
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
