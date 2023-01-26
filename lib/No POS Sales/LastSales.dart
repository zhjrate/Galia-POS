import 'package:denario/Models/Sales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LastSales extends StatelessWidget {
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final salesList = Provider.of<List<Sales>>(context);

    if (salesList == null) {
      return Container();
    }
    print(salesList.length);

    return Container(
      child: ListView.builder(
          itemCount: (salesList.length > 8) ? 8 : salesList.length,
          shrinkWrap: true,
          reverse: false,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, i) {
            return Container(
              height: 40,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Producto
                  Container(
                      width: 150,
                      child: Text(
                        (salesList[i].soldItems.length > 1)
                            ? 'Varios'
                            : salesList[i].soldItems[0].product,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Spacer(),
                  //Cliente
                  Container(
                      width: 100,
                      child: Text(
                        salesList[i].clientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  Spacer(),
                  //Monto vendidos
                  Container(
                      width: 100,
                      child: Center(
                        child: Text(
                          '${formatCurrency.format(salesList[i].total)}', //expenseList[i].total
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )),
                  SizedBox(width: 25),
                  //Cantidad vendido
                  Container(
                      width: 75,
                      child: Center(
                        child: Text(
                          salesList[i].soldItems.length.toString(),
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }
}
