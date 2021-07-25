import 'package:cached_network_image/cached_network_image.dart';
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
    final dailyTransactionsList = Provider.of<List<DailyTransactions>>(context);
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    if (dailyTransactions == null || registerStatus == null) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/EmptyState.png'),
                  fit: BoxFit.fitWidth)),
        ),
      );
    }

    final transactionsList = dailyTransactionsList.reversed.take(7).toList();

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
                    (registerStatus != null && registerStatus.registerisOpen)
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
                    Expanded(
                        child: (dailyTransactions == null ||
                                dailyTransactionsList == null)
                            ? Container()
                            : DailySalesGraph(transactionsList))
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
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Text(
                    'Ventas por medio',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 15),
                  //List of payment types
                  Expanded(
                    child: (Container(
                        child: GridView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width > 1100) ? 4 : 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 1,
                      ),
                      scrollDirection: Axis.vertical,
                      itemCount: registerStatus.paymentTypes.length,
                      itemBuilder: (context, i) {
                        var salesByMediumIndex = dailyTransactions.salesByMedium
                            .indexWhere((x) =>
                                x['Type'] ==
                                registerStatus.paymentTypes[i]['Type']);
                        print(salesByMediumIndex);

                        return Container(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            children: <Widget>[
                              ///Image
                              Expanded(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: CachedNetworkImage(
                                        imageUrl: registerStatus.paymentTypes[i]
                                            ['Image'],
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(height: 10),

                              ///Text
                              Text(
                                (salesByMediumIndex != null &&
                                        salesByMediumIndex >= 0)
                                    ? '${formatCurrency.format(dailyTransactions.salesByMedium[salesByMediumIndex]['Amount'])}'
                                    : '${formatCurrency.format(0)}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      },
                    ))),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
