import 'package:denario/Dashboard/CloseCashRegisterDialog.dart';
import 'package:denario/Dashboard/DailyHistory.dart';
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
  final formatCurrency = new NumberFormat.simpleCurrency();
  int indexOfCashSales = 0;
  double expectedInRegister = 0;
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

  List<DailyTransactions> dailyTransactionsList = [];

  @override
  Widget build(BuildContext context) {
    final registerStatus = Provider.of<CashRegister>(context);
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    if (registerStatus == null) {
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
                        'Arqueo de caja',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                    SizedBox(height: 10),
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

    indexOfCashSales = dailyTransactions.salesByMedium
        .indexWhere((element) => element['Type'] == 'Efectivo');

    if (indexOfCashSales == -1) {
      expectedInRegister = dailyTransactions.initialAmount +
          dailyTransactions.inflows -
          dailyTransactions.outflows;
    } else {
      expectedInRegister = dailyTransactions.salesByMedium[indexOfCashSales]
              ['Amount'] +
          dailyTransactions.initialAmount +
          dailyTransactions.inflows -
          dailyTransactions.outflows;
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Title
                          Text(
                            'Arqueo de caja',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                          Spacer(),
                          //Historic Cash Balancing
                          IconButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DailyHistory())),
                              icon: Icon(
                                Icons.list,
                                color: Colors.black,
                                size: 24,
                              ))
                        ]),
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
                  SizedBox(height: 5),
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
                                    padding: EdgeInsets.all(5),
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
                                                  fontSize: 11))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            //Date and name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Fecha
                                Container(
                                    child: Text(
                                  'Apertura: ' +
                                      (DateFormat.MMMd()
                                              .format(
                                                  dailyTransactions.openDate)
                                              .toString() +
                                          ', ' +
                                          DateFormat('HH:mm:ss')
                                              .format(
                                                  dailyTransactions.openDate)
                                              .toString()),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                                SizedBox(width: 10),
                                //User
                                Container(
                                    child: Center(
                                  child: Text(
                                    '|  Usuario: ${dailyTransactions.user}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 20),
                            //Monto apertura
                            Text(
                              'Monto de Apertura: ${formatCurrency.format(dailyTransactions.initialAmount)}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 15),
                            //Sales
                            Text(
                              'Ventas: ${formatCurrency.format(dailyTransactions.sales)}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 15),
                            //inflows
                            Text(
                              'Ingresos a Caja: ${formatCurrency.format(dailyTransactions.inflows)}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 15),
                            //outflows
                            Text(
                              'Egresos de Caja: ${formatCurrency.format(dailyTransactions.outflows)}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 15),
                            //Divider
                            Container(
                              width: double.infinity,
                              child: Divider(
                                thickness: 1,
                                endIndent: 10,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 15),
                            //Expected in Register
                            Text(
                              'Esperado en Caja: ${formatCurrency.format(expectedInRegister)}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 15),
                            //Buttons to add transactions
                            SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
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
      ],
    );
  }
}
