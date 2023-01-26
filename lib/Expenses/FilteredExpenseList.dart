import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Expenses/SingleExpenseDialog.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilteredExpenseList extends StatelessWidget {
  final String businessID;
  final CashRegister registerStatus;
  FilteredExpenseList(this.businessID, this.registerStatus);

  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final expensesListfromSnap = Provider.of<List<Expenses>>(context);

    if (expensesListfromSnap == null) {
      return Expanded(child: Container(padding: EdgeInsets.all(20)));
    }

    final List<Expenses> expensesList = expensesListfromSnap.reversed.toList();

    return Expanded(
        child: Container(
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: expensesList.length,
          itemBuilder: (context, i) {
            return Container(
              color: i.isOdd ? Colors.grey[100] : Colors.white,
              width: double.infinity,
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Fecha
                  Container(
                      width: 50,
                      child: Text(
                        DateFormat.MMMd()
                            .format(expensesList[i].date)
                            .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  //Hora
                  Container(
                      width: 75,
                      child: Text(
                        DateFormat('HH:mm:ss')
                            .format(expensesList[i].date)
                            .toString(),
                        textAlign: TextAlign.center,
                      )),
                  //CostType
                  Container(
                      width: 120,
                      child: Text(
                        '${expensesList[i].costType}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )),
                  //Vendor
                  Container(
                      width: 120,
                      child: Text(
                        '${expensesList[i].vendor}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      )),
                  //Product
                  Container(
                      width: 120,
                      child: Text(
                        (expensesList[i].items.isEmpty)
                            ? 'Sin descripción'
                            : (expensesList[i].items.length > 1)
                                ? 'Varios'
                                : (expensesList[i].items[0].product == '')
                                    ? 'Sin descripción'
                                    : '${expensesList[i].items[0].product}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      )),
                  //Payment Type
                  Container(
                      width: 120,
                      child: Center(
                        child: Text(
                          '${expensesList[i].paymentType}',
                          style: TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )),
                  //Total
                  Container(
                      width: 70,
                      child: Center(
                        child: Text(
                          '${formatCurrency.format(expensesList[i].total)}',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      )),
                  //More Button
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black, size: 20),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StreamProvider<DailyTransactions>.value(
                                initialData: null,
                                value: DatabaseService().dailyTransactions(
                                    businessID, registerStatus.registerName),
                                child: SingleExpenseDialog(expensesList[i],
                                    businessID, registerStatus));
                          });
                    },
                  )
                ],
              ),
            );
          }),
    ));
  }
}
