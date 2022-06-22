import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilteredExpenseList extends StatelessWidget {
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
      padding: EdgeInsets.all(20),
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: expensesList.length,
          itemBuilder: (context, i) {
            return Container(
              height: 40,
              width: double.infinity,
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
                      )),
                  //Hora
                  Container(
                      width: 75,
                      child: Text(
                        DateFormat('HH:mm:ss')
                            .format(expensesList[i].date)
                            .toString(),
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
                      )),
                  //Category
                  Container(
                      width: 120,
                      child: Text(
                        '${expensesList[i].category}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  //Vendor
                  Container(
                      width: 120,
                      child: Text(
                        '${expensesList[i].vendor}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  //Product
                  Container(
                      width: 120,
                      child: Text(
                        (expensesList[i].product == '')
                            ? 'Sin descripción'
                            : '${expensesList[i].product}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                        ),
                      )),
                  //More Button
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black, size: 20),
                    onPressed: () {
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return SingleSaleDialog(
                      //           sale: expensesList[i]);
                      //     });
                    },
                  )
                ],
              ),
            );
          }),
    ));
  }
}
