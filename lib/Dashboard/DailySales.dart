import 'package:denario/Dashboard/DailySalesGraph.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailySales extends StatelessWidget {
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final registerStatus = Provider.of<CashRegister>(context);
    //final dailyTransactionsList = Provider.of<List<DailyTransactions>>(context);
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    if (registerStatus == null || dailyTransactions == null) {
      return Container();
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Total Sales
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.grey[200],
                      offset: new Offset(15.0, 15.0),
                      blurRadius: 10.0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Ventas',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 15),
                    //Amount
                    (registerStatus.registerisOpen)
                        ? Text(
                            '${formatCurrency.format(dailyTransactions.sales)}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            '\$0',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                    SizedBox(height: 15),
                    //Graph Sales per day
                    Expanded(child: DailySalesGraph())
                  ],
                )),
          ),
          SizedBox(height: 15),
          //Sales by Medium
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.grey[200],
                    offset: new Offset(15.0, 15.0),
                    blurRadius: 10.0,
                  )
                ],
              ),
              child: Center(child: Text('Sales by Medium')),
            ),
          ),
        ]);
  }
}
