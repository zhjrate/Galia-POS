import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.simpleCurrency();
    final dailyTransactions = Provider.of<DailyTransactions>(context);
    final categoriesProvider = Provider.of<CategoryList>(context);

    if (dailyTransactions == null) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            //Ups
            Text(
              'Upss..',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            //Text
            Text(
              'La caja registradora está cerrada, no hay nada que ver por aca',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      );
    } else {
      var productsList = dailyTransactions.salesAmountbyProduct.keys.toList();

      if (MediaQuery.of(context).size.width > 950) {
        return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Total sum and counts Summary
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Total Sales
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Amount
                                Text(
                                  '${dailyTransactions.sales}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25),
                                ),
                                SizedBox(height: 10),
                                //Text
                                Text(
                                  'Ingresos por Ventas',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.grey),
                                )
                              ]),
                        ),
                        Spacer(),
                        //Sales count
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Amount
                                Text(
                                  '${dailyTransactions.totalSalesCount}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25),
                                ),
                                SizedBox(height: 10),
                                //Text
                                Text(
                                  'No. de Ventas',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.grey),
                                )
                              ]),
                        ),
                        Spacer(),
                        //Products sold
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Amount
                                Text(
                                  '${dailyTransactions.totalItemsSold}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25),
                                ),
                                SizedBox(height: 10),
                                //Text
                                Text(
                                  'Productos Vendidos',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.grey),
                                )
                              ]),
                        ),
                        Spacer(),
                        //Average Sale+
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Amount
                                Text(
                                  '${dailyTransactions.sales / dailyTransactions.totalSalesCount}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25),
                                ),
                                SizedBox(height: 10),
                                //Text
                                Text(
                                  'Promedio por Venta',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.grey),
                                )
                              ]),
                        ),
                        Spacer(),
                      ]),
                ),
                SizedBox(height: 30),
                //Lists by Products/Category
                Expanded(
                  child: Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //By Product
                          Expanded(
                            child: Container(
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
                                      height: 40,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //Title
                                            Text(
                                              'Ventas por producto',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18),
                                            ),
                                            Spacer(),
                                            //Search Button
                                            IconButton(
                                                onPressed: () {},
                                                icon:
                                                    Icon(Icons.search_outlined))
                                          ]),
                                    ),
                                    Divider(
                                        thickness: 0.5,
                                        indent: 0,
                                        endIndent: 0),
                                    SizedBox(height: 10),
                                    //Titles
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                          //Monto vendidos
                                          Container(
                                              width: 100,
                                              child: Center(
                                                child: Text(
                                                    'Monto', //expenseList[i].total
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )),
                                        ]),
                                    SizedBox(height: 10),
                                    //List
                                    Expanded(
                                      child: Container(
                                        child: ListView.builder(
                                            itemCount: productsList.length,
                                            shrinkWrap: true,
                                            reverse: false,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return Container(
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    //Producto
                                                    Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${productsList[i]}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                                    Spacer(),
                                                    //Monto vendidos
                                                    Container(
                                                        width: 100,
                                                        child: Center(
                                                          child: Text(
                                                            '${formatCurrency.format(dailyTransactions.salesAmountbyProduct[productsList[i]])}', //expenseList[i].total
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        )),
                                                    SizedBox(width: 25),
                                                    //Cantidad vendido
                                                    Container(
                                                        width: 75,
                                                        child: Center(
                                                          child: Text(
                                                            '${dailyTransactions.salesCountbyProduct[productsList[i]]}', //'${expenseList[i].costType}',
                                                            textAlign:
                                                                TextAlign.end,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
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
                          //By Categories
                          Expanded(
                            child: Container(
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
                                      height: 40,
                                      child: Text(
                                        'Ventas por Categoría',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Divider(
                                        thickness: 0.5,
                                        indent: 0,
                                        endIndent: 0),
                                    SizedBox(height: 10),
                                    //List
                                    Expanded(
                                      child: Container(
                                        child: ListView.builder(
                                            itemCount: categoriesProvider
                                                .categoriesList.length,
                                            shrinkWrap: true,
                                            reverse: false,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, i) {
                                              return Container(
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    //Producto
                                                    Container(
                                                        width: 150,
                                                        child: Text(
                                                          '${categoriesProvider.categoriesList[i].category}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                                    Spacer(),
                                                    //Monto vendidos
                                                    Container(
                                                        width: 120,
                                                        child: Center(
                                                          child: Text(
                                                            (dailyTransactions
                                                                            .salesCountbyCategory[
                                                                        (categoriesProvider
                                                                            .categoriesList[i]
                                                                            .category)] !=
                                                                    null)
                                                                ? '${formatCurrency.format(dailyTransactions.salesCountbyCategory[(categoriesProvider.categoriesList[i].category)])}'
                                                                : '${formatCurrency.format(0)}',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
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
                        ]),
                  ),
                ),
              ]),
        );
      } else {
        return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Total sum and counts Summary
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Total Sales
                            Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Amount
                                    Text(
                                      '${dailyTransactions.sales}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 10),
                                    //Text
                                    Text(
                                      'Ingresos por Ventas',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    )
                                  ]),
                            ),
                            SizedBox(width: 20),
                            //Sales count
                            Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Amount
                                    Text(
                                      '${dailyTransactions.totalSalesCount}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 10),
                                    //Text
                                    Text(
                                      'No. de Ventas',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    )
                                  ]),
                            ),
                          ]),
                      SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Products sold
                            Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Amount
                                    Text(
                                      '${dailyTransactions.totalItemsSold}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 10),
                                    //Text
                                    Text(
                                      'Productos Vendidos',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    )
                                  ]),
                            ),
                            SizedBox(width: 20),
                            //Average Sale
                            Container(
                              width: 200,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Amount
                                    Text(
                                      '${dailyTransactions.sales / dailyTransactions.totalSalesCount}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 25),
                                    ),
                                    SizedBox(height: 10),
                                    //Text
                                    Text(
                                      'Promedio por Venta',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.grey),
                                    )
                                  ]),
                            ),
                          ]),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                //Lists by Products/Category
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //By Product
                        Container(
                          width: double.infinity,
                          height: 500,
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
                                  height: 40,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Title
                                        Text(
                                          'Ventas por producto',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18),
                                        ),
                                        Spacer(),
                                        //Search Button
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.search_outlined))
                                      ]),
                                ),
                                Divider(
                                    thickness: 0.5, indent: 0, endIndent: 0),
                                SizedBox(height: 10),
                                //Titles
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      //Monto vendidos
                                      Container(
                                          width: 75,
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
                                  child: Container(
                                    child: ListView.builder(
                                        itemCount: productsList.length,
                                        shrinkWrap: true,
                                        reverse: false,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return Container(
                                            height: 50,
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                //Producto
                                                Container(
                                                    width: 150,
                                                    child: Text(
                                                      '${productsList[i]}',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                Spacer(),
                                                //Monto vendidos
                                                Container(
                                                    width: 75,
                                                    child: Center(
                                                      child: Text(
                                                        '${formatCurrency.format(dailyTransactions.salesAmountbyProduct[productsList[i]])}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )),
                                                SizedBox(width: 25),
                                                //Cantidad vendido
                                                Container(
                                                    width: 75,
                                                    child: Center(
                                                      child: Text(
                                                        '${dailyTransactions.salesCountbyProduct[productsList[i]]}', //'${expenseList[i].costType}',
                                                        textAlign:
                                                            TextAlign.end,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ]),
                        ),
                        SizedBox(height: 20),
                        //By Categories
                        Container(
                          width: double.infinity,
                          height: 500,
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
                                  height: 40,
                                  child: Text(
                                    'Ventas por Categoría',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18),
                                  ),
                                ),
                                Divider(
                                    thickness: 0.5, indent: 0, endIndent: 0),
                                SizedBox(height: 10),
                                //List
                                Expanded(
                                  child: Container(
                                    child: ListView.builder(
                                        itemCount: categoriesProvider
                                            .categoriesList.length,
                                        shrinkWrap: true,
                                        reverse: false,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return Container(
                                            height: 50,
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                //Producto
                                                Container(
                                                    width: 150,
                                                    child: Text(
                                                      '${categoriesProvider.categoriesList[i].category}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )),
                                                Spacer(),
                                                //Monto vendidos
                                                Container(
                                                    width: 120,
                                                    child: Center(
                                                      child: Text(
                                                        (dailyTransactions
                                                                        .salesCountbyCategory[
                                                                    (categoriesProvider
                                                                        .categoriesList[
                                                                            i]
                                                                        .category)] !=
                                                                null)
                                                            ? '${formatCurrency.format(dailyTransactions.salesCountbyCategory[(categoriesProvider.categoriesList[i].category)])}'
                                                            : '${formatCurrency.format(0)}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ]),
                        ),
                      ]),
                ),
              ]),
        );
      }
    }
  }
}
