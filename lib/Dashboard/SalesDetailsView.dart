import 'package:denario/Dashboard/SingleSaleDialog.dart';
import 'package:denario/Models/Sales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesDetailsView extends StatelessWidget {
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final salesListfromSnap = Provider.of<List<Sales>>(context);

    if (salesListfromSnap == null) {
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Go Back /// Title
            Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                //Back
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.keyboard_arrow_left_outlined)),
                Spacer(),
                Text('Ventas del día'),
                Spacer()
              ]),
            ),
            SizedBox(height: 20),
            //Historical Details
            Expanded(child: Container(padding: EdgeInsets.all(20)))
          ],
        ),
      ));
    }

    final List<Sales> salesList = salesListfromSnap.reversed.toList();

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Go Back /// Title
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              //Back
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.keyboard_arrow_left_outlined)),
              Spacer(),
              Text('Ventas del día'),
              Spacer()
            ]),
          ),
          SizedBox(height: 20),
          //Historical Details
          Expanded(
              child: Container(
            padding: EdgeInsets.all(20),
            child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: salesList.length,
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
                                  .format(salesList[i].date)
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
                                  .format(salesList[i].date)
                                  .toString(),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        //More Button
                        IconButton(
                          icon:
                              Icon(Icons.search, color: Colors.black, size: 20),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SingleSaleDialog(sale: salesList[i]);
                                });
                          },
                        )
                      ],
                    ),
                  );
                }),
          ))
        ],
      ),
    ));
  }
}
