import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Dashboard/SingleSaleDialog.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Sales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesDetailsView extends StatelessWidget {
  final String businessID;
  final CashRegister registerStatus;
  SalesDetailsView(this.businessID, this.registerStatus);
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final salesListfromSnap = Provider.of<List<Sales>>(context);

    if (salesListfromSnap == null || registerStatus == null) {
      return Container();
    }

    final List<Sales> salesList = salesListfromSnap.reversed.toList();

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: salesList.length,
          itemBuilder: (context, i) {
            return Container(
              height: 50,
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
                        DateFormat.MMMd().format(salesList[i].date).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  //Hora
                  Container(
                      width: 75,
                      child: Text(
                        DateFormat('HH:mm:ss')
                            .format(salesList[i].date)
                            .toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),

                  //Nombre
                  Container(
                      width: 120,
                      child: Text(
                        (salesList[i].orderName == '')
                            ? 'Sin nombre'
                            : '${salesList[i].orderName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),

                  //Payment Type
                  Container(
                      width: 120,
                      child: Center(
                        child: Text(
                          '${salesList[i].paymentType}',
                          textAlign: TextAlign.center,
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
                          '${formatCurrency.format(salesList[i].total)}',
                          textAlign: TextAlign.center,
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
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StreamProvider<DailyTransactions>.value(
                                initialData: null,
                                catchError: (_, err) => null,
                                value: DatabaseService().dailyTransactions(
                                    businessID, registerStatus.registerName),
                                builder: (context, snapshot) {
                                  return SingleSaleDialog(
                                      salesList[i],
                                      businessID,
                                      salesList[i].docID,
                                      registerStatus.paymentTypes,
                                      registerStatus);
                                });
                          });
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}
