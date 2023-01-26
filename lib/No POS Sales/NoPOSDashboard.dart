import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Dashboard/SalesDetailsFilters.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Sales.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/No%20POS%20Sales/LastSales.dart';
import 'package:denario/No%20POS%20Sales/NewSaleScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NoPOSDashboard extends StatelessWidget {
  final String currentBusiness;
  final formatCurrency = new NumberFormat.simpleCurrency();

  NoPOSDashboard(this.currentBusiness);

// • Crear nueva venta
// • Ver historico de ventas
// • Ver ventas por medio de pago
// • resumen de stats del mes?
// • Resumen de PnL (ventas totales vs gastos totales)

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<CashRegister>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: double.infinity,
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 800, minWidth: 950),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Text(
              'Dashboard',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
            ),
          ),
          //Info
          Expanded(
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Sales
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: <BoxShadow>[
                                new BoxShadow(
                                  color: Colors.grey[350],
                                  offset: new Offset(0, 0),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                //Action
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Title
                                          Text(
                                            'Ventas',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          SizedBox(height: 15),
                                          //Make new sale
                                          Text(
                                            'Registra una nueva venta',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.grey[600]),
                                          ),
                                          SizedBox(height: 15),
                                          //Button
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor:
                                                    Colors.grey[200],
                                                backgroundColor: Colors.black),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StreamProvider<
                                                            MonthlyStats>.value(
                                                          value: DatabaseService()
                                                              .monthlyStatsfromSnapshot(
                                                                  currentBusiness),
                                                          initialData: null,
                                                          child: NewSaleScreen(
                                                              currentBusiness),
                                                        ))),
                                            child: Container(
                                              width: 120,
                                              height: 30,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 10),
                                              child: Center(
                                                child: Text(
                                                  'Crear venta',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(width: 20),
                                //Illustration
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        //History
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: <BoxShadow>[
                                new BoxShadow(
                                  color: Colors.grey[350],
                                  offset: Offset(0.0,
                                      0.0), //offset: new Offset(15.0, 15.0),
                                  blurRadius: 10.0,
                                  // spreadRadius: 2.0,
                                )
                              ],
                            ),
                            child: Column(children: [
                              //Title
                              Row(
                                children: [
                                  Text(
                                    'Últimas ventas concretadas',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                  Spacer(),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StreamProvider<
                                                            CashRegister>.value(
                                                        initialData: null,
                                                        value: DatabaseService()
                                                            .cashRegisterStatus(
                                                                currentBusiness),
                                                        child:
                                                            SalesDetailsFilters(
                                                                currentBusiness,
                                                                register))));
                                        // MultiProvider(
                                        //     providers: [
                                        //       StreamProvider<
                                        //               List<
                                        //                   Sales>>.value(
                                        //           initialData: null,
                                        //           value: DatabaseService()
                                        //               .salesList(
                                        //                   currentBusiness))
                                        //     ],
                                        //     child:
                                        //         SalesDetailsView())));
                                      },
                                      child: Text('Ver más',
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 12)))
                                ],
                              ),
                              SizedBox(height: 15),
                              //List of last sales
                              //Titles
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Producto
                                    Container(
                                        width: 150,
                                        child: Text(
                                          'Producto',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Spacer(),
                                    Container(
                                        width: 100,
                                        child: Text(
                                          'Cliente',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Spacer(),
                                    //Monto vendidos
                                    Container(
                                        width: 100,
                                        child: Center(
                                          child: Text(
                                              'Monto', //expenseList[i].total
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        )),
                                    SizedBox(width: 25),
                                    //Cantidad vendido
                                    Container(
                                        width: 75,
                                        child: Center(
                                          child: Text(
                                            'Cantidad', //'${expenseList[i].costType}',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                  ]),
                              SizedBox(height: 10),
                              //List
                              Expanded(
                                  child: StreamProvider<List<Sales>>.value(
                                      initialData: null,
                                      value: DatabaseService()
                                          .shortsalesList(currentBusiness),
                                      child: LastSales()))
                            ]),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //PnL
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: <BoxShadow>[
                                new BoxShadow(
                                  color: Colors.grey[350],
                                  offset: new Offset(0, 0),
                                  blurRadius: 10.0,
                                )
                              ],
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Title
                                  Text(
                                    'Resumen de resultados de este mes',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(height: 15),
                                  //PnL
                                  Expanded(
                                    child: Container(
                                        child: Center(
                                      child: Text('PNL'),
                                    )),
                                  )
                                ]),
                          ),
                        ),
                        SizedBox(height: 20),
                        //Pending sales/payments
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Row(
                              children: [
                                //Sales
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // height: double.infinity,
                                    // width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: Colors.grey[350],
                                          offset: new Offset(0, 0),
                                          blurRadius: 10.0,
                                        )
                                      ],
                                    ),
                                    child: Column(children: [
                                      //Title
                                      Row(
                                        children: [
                                          Text(
                                            'Ventas pendientes',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Spacer(),
                                          TextButton(
                                              onPressed: () {},
                                              child: Text('Ver más',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 12)))
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      //Titles
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            //Producto
                                            Container(
                                                width: 100,
                                                child: Text(
                                                  'Producto',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            Spacer(),
                                            Container(
                                                width: 100,
                                                child: Text(
                                                  'Status',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ]),
                                      SizedBox(height: 10),
                                      //List
                                      Expanded(
                                        child: Container(
                                          child: ListView.builder(
                                              itemCount: 4,
                                              shrinkWrap: true,
                                              reverse: false,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, i) {
                                                return Container(
                                                  height: 40,
                                                  width: double.infinity,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      //Producto
                                                      Container(
                                                          width: 100,
                                                          child: Text(
                                                            'Ejemplo',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                      Spacer(),
                                                      //Cliente
                                                      Container(
                                                          width: 100,
                                                          child: Text(
                                                            'Status',
                                                            textAlign:
                                                                TextAlign.end,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                                SizedBox(width: 20),
                                //Payments
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    // height: double.infinity,
                                    // width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: <BoxShadow>[
                                        new BoxShadow(
                                          color: Colors.grey[350],
                                          offset: new Offset(0, 0),
                                          blurRadius: 10.0,
                                        )
                                      ],
                                    ),
                                    child: Column(children: [
                                      //Title
                                      Row(
                                        children: [
                                          Text(
                                            'Pagos pendientes',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          Spacer(),
                                          TextButton(
                                              onPressed: () {},
                                              child: Text('Ver más',
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 12)))
                                        ],
                                      ),
                                      SizedBox(height: 15),
                                      //Titles
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            //Producto
                                            Container(
                                                width: 100,
                                                child: Text(
                                                  'Producto',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            Spacer(),
                                            Container(
                                                width: 100,
                                                child: Text(
                                                  'Status',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ]),
                                      SizedBox(height: 10),
                                      //List
                                      Expanded(
                                        child: Container(
                                          child: ListView.builder(
                                              itemCount: 4,
                                              shrinkWrap: true,
                                              reverse: false,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, i) {
                                                return Container(
                                                  height: 40,
                                                  width: double.infinity,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      //Producto
                                                      Container(
                                                          width: 100,
                                                          child: Text(
                                                            'Ejemplo',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                      Spacer(),
                                                      //Cliente
                                                      Container(
                                                          width: 100,
                                                          child: Text(
                                                            'Status',
                                                            textAlign:
                                                                TextAlign.end,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
