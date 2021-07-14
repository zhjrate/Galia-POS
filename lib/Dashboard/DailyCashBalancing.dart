import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Dashboard/CloseCashRegisterDialog.dart';
import 'package:denario/Dashboard/OpenCashRegisterDialog.dart';
import 'package:denario/Dashboard/UpdateCashRegisterDialog.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyCashBalancing extends StatefulWidget {
  @override
  _DailyCashBalancingState createState() => _DailyCashBalancingState();
}

class _DailyCashBalancingState extends State<DailyCashBalancing> {
  Widget closedRegister() {
    return Container(
      height: 40,
      width: 300,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.green,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return OpenCashRegisterDialog();
              });
        },
        child: Center(
            child: Text('Abrir caja',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registerStatus = Provider.of<CashRegister>(context);
    final dailyTransactionsList = Provider.of<List<DailyTransactions>>(context);
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    if (registerStatus == null || dailyTransactionsList == null) {
      return Container();
    } else if (dailyTransactions == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Open/Close Register
          Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Container(
                      width: double.infinity,
                      child: Text(
                        'CAJA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 50,
                      child: Divider(
                        thickness: 1,
                        endIndent: 10,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 15),
                    //Open / Current
                    closedRegister(),
                  ],
                )),
          ),
          SizedBox(height: 20),
          //Cash Balancing History (Last 5)
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Container(
                      width: double.infinity,
                      child: Text(
                        'HISTORIAL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 50,
                      child: Divider(
                        thickness: 1,
                        endIndent: 10,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 18),
                    //List of historic cash balances
                    Expanded(
                      child:
                          Container(width: double.infinity, child: Container()),
                    ),
                  ],
                )),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Open/Close Register
        Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Container(
                    width: double.infinity,
                    child: Text(
                      'CAJA',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 50,
                    child: Divider(
                      thickness: 1,
                      endIndent: 10,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 15),
                  //Open / Current
                  registerStatus.registerisOpen
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Open//Close
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //Openned
                                  Text(
                                    '• Caja abierta',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 12),
                                  ),
                                  Spacer(),
                                  //Close Button
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      color: Colors.red[50],
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CloseCashRegisterDialog(
                                                  currentRegister:
                                                      registerStatus
                                                          .registerName);
                                            });
                                      },
                                      child: Center(
                                          child: Text('Hacer cierre',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            //Details
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Fecha
                                Container(
                                    width: 50,
                                    child: Text(
                                      DateFormat.MMMd()
                                          .format(dailyTransactions.openDate)
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                SizedBox(width: 10),
                                //Detail
                                Container(
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        '${(dailyTransactions.openDate).hour.toString()}:${(dailyTransactions.openDate).minute.toString()}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                SizedBox(width: 10),
                                //Cost Type
                                Container(
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        '${dailyTransactions.user}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                                SizedBox(width: 10),
                                //Total
                                Container(
                                    width: 75,
                                    child: Center(
                                      child: Text(
                                          '\$${dailyTransactions.initialAmount}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    )),
                              ],
                            ),
                            //Ingresos - Egresos
                            SizedBox(height: 20),
                            Row(
                              children: [
                                //Inflows
                                Icon(Icons.arrow_upward_outlined,
                                    color: Colors.green, size: 16),
                                SizedBox(width: 5),
                                Text('\$${dailyTransactions.inflows}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 15),
                                //Outflows
                                Icon(Icons.arrow_downward_outlined,
                                    color: Colors.red, size: 16),
                                SizedBox(width: 5),
                                Text('\$${dailyTransactions.outflows}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            //Buttons to add transactions
                            SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Inngreso
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return UpdateCashRegisterDialog(
                                              currentRegister:
                                                  registerStatus.registerName,
                                              transactionType: 'Ingresos',
                                              transactionAmount:
                                                  dailyTransactions.inflows,
                                              currentTransactions:
                                                  dailyTransactions
                                                      .dailyTransactions,
                                            );
                                          });
                                    },
                                    child: Center(
                                        child: Text('Ingreso',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12))),
                                  ),
                                ),
                                SizedBox(width: 30),
                                //Egreso
                                Container(
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return UpdateCashRegisterDialog(
                                              currentRegister:
                                                  registerStatus.registerName,
                                              transactionType: 'Egresos',
                                              transactionAmount:
                                                  dailyTransactions.outflows,
                                              currentTransactions:
                                                  dailyTransactions
                                                      .dailyTransactions,
                                            );
                                          });
                                    },
                                    child: Center(
                                        child: Text('Egreso',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12))),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      : closedRegister(),
                ],
              )),
        ),
        SizedBox(height: 20),
        //Cash Balancing History (Last 5)
        Expanded(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Container(
                    width: double.infinity,
                    child: Text(
                      'HISTORIAL',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 50,
                    child: Divider(
                      thickness: 1,
                      endIndent: 10,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 18),
                  //List of historic cash balances
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: (dailyTransactionsList.length == 0)
                          ? Container()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: (dailyTransactionsList.length > 8)
                                  ? 8
                                  : dailyTransactionsList.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  height: 40,
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      //Fecha
                                      Container(
                                          width: 50,
                                          child: Text(
                                            DateFormat.MMMd()
                                                .format(dailyTransactionsList[i]
                                                    .openDate)
                                                .toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      //SizedBox(width: 10),
                                      //Apertura
                                      Container(
                                          width: 50,
                                          child: Text(
                                            '${(dailyTransactionsList[i].openDate).hour}:${(dailyTransactionsList[i].openDate).minute}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      //SizedBox(width: 10),
                                      //Cierre
                                      Container(
                                          width: 50,
                                          child: Text(
                                            '${(dailyTransactionsList[i].closeDate).hour}:${(dailyTransactionsList[i].closeDate).minute}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      //SizedBox(width: 10),
                                      //Usuario
                                      Container(
                                          width: 150,
                                          child: Center(
                                            child: Text(
                                              '${dailyTransactionsList[i].user}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )),
                                      //SizedBox(width: 10),
                                      //Monto Inicial
                                      Container(
                                          width: 75,
                                          child: Center(
                                            child: Text(
                                                '\$${dailyTransactionsList[i].initialAmount}',
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                          )),
                                      //Monto Cierre
                                      Container(
                                          width: 75,
                                          child: Center(
                                            child: Text(
                                                '\$${dailyTransactionsList[i].closeAmount}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black)),
                                          )),
                                    ],
                                  ),
                                );
                              }),
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
