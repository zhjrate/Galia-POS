import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:denario/POS/ActiveOrders.dart';
import 'package:denario/POS/ConfirmOrder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TicketView extends StatefulWidget {
  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  String orderName = 'Sin Agregar';
  var _controller = TextEditingController();
  var _discountTextController = TextEditingController();

  var orderDetail;
  Map<String, dynamic> orderCategories;
  Map currentValues;
  double subTotal = 0;
  double tax = 0;
  double discount = 0;
  double total = 0;
  Color color = Colors.white;

  String paymentType = 'Efectivo';

  void clearVariables() {
    bloc.removeAllFromCart();
    _controller.clear();

    setState(() {
      discount = 0;
      tax = 0;
      paymentType = 'Efectivo';
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerStatus = Provider.of<CashRegister>(context);

    if (registerStatus == null) {
      return Container();
    }

    return StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.ticketItems,
        builder: (context, snapshot) {
          subTotal = snapshot.data["Subtotal"];
          tax = snapshot.data["IVA"];
          discount = snapshot.data["Discount"];
          total = snapshot.data["Total"];
          orderName = snapshot.data["Order Name"];
          color = snapshot.data["Color"];

          for (var i = 0; i < bloc.ticketItems['Items'].length; i++) {
            subTotal += bloc.ticketItems['Items'][i]["Price"] *
                bloc.ticketItems['Items'][i]["Quantity"];
          }

          total = (subTotal + ((subTotal * tax).round())) - discount;

          return Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Active Orders
                    StreamProvider<List<SavedOrders>>.value(
                        initialData: null,
                        value: DatabaseService().orderList(),
                        child: ActiveOrders()),
                    Divider(thickness: 0.5, indent: 0, endIndent: 0),
                    SizedBox(height: 3),
                    //Order Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pedido: ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: TextFormField(
                              controller:
                                  _controller, //..text = snapshot.data["Order Name"],
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(15)
                              ],
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration.collapsed(
                                hintText: (snapshot.data["Order Name"] == '')
                                    ? 'Mesa 1'
                                    : snapshot.data["Order Name"],
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 14),
                              ),
                              onChanged: (val) {
                                bloc.changeOrderName(val);
                                setState(() {
                                  orderName = val;
                                });
                              },
                            ),
                          ),
                        ),
                        Spacer(),
                        //Delete Order
                        IconButton(
                            onPressed: () {
                              bloc.removeAllFromCart();
                              _controller.clear();
                              setState(() {
                                discount = 0;
                                tax = 0;
                                paymentType = 'Efectivo';
                                orderCategories = {};
                              });
                            },
                            icon: Icon(Icons.delete, color: Colors.black))
                      ],
                    ),
                    SizedBox(height: 3),
                    Divider(thickness: 0.5, indent: 0, endIndent: 0),
                    SizedBox(height: 5),
                    //List of Products
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 5),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data["Items"].length,
                            itemBuilder: (context, i) {
                              final cartList = snapshot.data["Items"];
                              orderDetail = cartList;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Column Name + Qty
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Name
                                          Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 150),
                                            child: Text(cartList[i]['Name']),
                                          ),
                                          //Quantity
                                          Row(
                                            children: [
                                              //Remove
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    bloc.removeQuantity(i);
                                                  });
                                                },
                                                icon: Icon(Icons
                                                    .remove_circle_outline),
                                                iconSize: 16,
                                              ),
                                              Text(
                                                  '${cartList[i]['Quantity']}'),
                                              //Add
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    bloc.addQuantity(i);
                                                  });
                                                },
                                                icon: Icon(
                                                    Icons.add_circle_outline),
                                                iconSize: 16,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      //Amount
                                      Spacer(),
                                      Text(cartList[i]['Total Price']
                                          .toString()),
                                      SizedBox(width: 10),
                                      //Delete
                                      IconButton(
                                          onPressed: () =>
                                              bloc.removeFromCart(cartList[i]),
                                          icon: Icon(Icons.close),
                                          iconSize: 14)
                                    ]),
                              );
                            }),
                      ),
                    ),
                    Divider(thickness: 0.5, indent: 0, endIndent: 0),
                    //Subtotal
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              child: Text('Subtotal:',
                                  style: TextStyle(fontSize: 11))),
                          Spacer(),
                          Text('\$$subTotal', style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    //Tax
                    InkWell(
                      hoverColor: Colors.grey,
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Container(
                                height: 200,
                                width: 250,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment(1.0, 0.0),
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: Icon(Icons.close),
                                            iconSize: 20.0),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 5),
                                        child: Text(
                                          "IVA",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 35,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            //Exento
                                            Container(
                                              height: 35.0,
                                              width: 100,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    tax = 0;
                                                    bloc.removeTaxAmount();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        width: 0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 200.0,
                                                        minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Exento",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            //21
                                            Container(
                                              height: 35.0,
                                              width: 100,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    tax = 0.21;
                                                    bloc.setTaxAmount(tax);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        width: 0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 200.0,
                                                        minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "21%",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              child:
                                  Text('IVA:', style: TextStyle(fontSize: 11)),
                            ),
                            Spacer(),
                            Text('\$${(subTotal * tax).toStringAsFixed(1)}',
                                style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    //Discounts
                    InkWell(
                      hoverColor: Colors.grey,
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Container(
                                height: 250,
                                width: 250,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment(1.0, 0.0),
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: Icon(Icons.close),
                                            iconSize: 20.0),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 5),
                                        child: Text(
                                          "Aplica un descuento",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: 70,
                                        child: Center(
                                          child: TextFormField(
                                            autofocus: true,
                                            controller: _discountTextController,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            cursorColor:
                                                Theme.of(context).accentColor,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: '\$10',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                            onChanged: (val) {
                                              if (val == null || val == '') {
                                                setState(() {
                                                  discount = 0;
                                                });
                                              } else {
                                                setState(() {
                                                  discount =
                                                      double.tryParse(val);
                                                  bloc.setDiscountAmount(
                                                      discount);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          color: Colors.black,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Center(
                                              child: Text('Guardar',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 150),
                              child: Text('Descuetos:',
                                  style: TextStyle(fontSize: 11)),
                            ),
                            Spacer(),
                            Text('\$$discount', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    //Total
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 150),
                            child: Text('TOTAL',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          Text('\$$total',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    //Payment type
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: registerStatus.paymentTypes.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    paymentType =
                                        registerStatus.paymentTypes[i]['Type'];
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: (paymentType ==
                                                    registerStatus
                                                            .paymentTypes[i]
                                                        ['Type'])
                                                ? Colors.green
                                                : Colors.white10,
                                            width: 2),
                                        image: DecorationImage(
                                          image: NetworkImage(registerStatus
                                              .paymentTypes[i]['Image']),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 15),
                    //Actions (Save, Process)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Guardar
                        Container(
                          width: 50,
                          height: 40,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.white70,
                            onPressed: () {
                              //Save Order
                              DatabaseService().saveOrder(
                                DateTime.now().toString(),
                                subTotal,
                                discount,
                                tax,
                                total,
                                orderDetail,
                                orderName,
                                paymentType,
                                (color == Colors.white)
                                    ? Colors
                                        .primaries[Random()
                                            .nextInt(Colors.primaries.length)]
                                        .value
                                    : color.value,
                              );

                              //Clear Variables
                              clearVariables();
                            },
                            child: Center(
                                child: Icon(
                              Icons.save,
                              color: Colors.black,
                            )),
                          ),
                        ),
                        SizedBox(width: 15),
                        //Pagar
                        Expanded(
                            child: Container(
                          height: 40,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.black,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StreamProvider<
                                        DailyTransactions>.value(
                                      initialData: null,
                                      value: DatabaseService()
                                          .dailyTransactions(
                                              registerStatus.registerName),
                                      child: ConfirmOrder(
                                          total: total,
                                          items: snapshot.data["Items"],
                                          discount: discount,
                                          orderDetail: orderDetail,
                                          orderName: orderName,
                                          paymentType: paymentType,
                                          subTotal: subTotal,
                                          tax: tax,
                                          controller: _controller,
                                          clearVariables: clearVariables),
                                    );
                                  });
                            },
                            child: Center(
                                child: Text('Ordenar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400))),
                          ),
                        )),
                      ],
                    )
                  ]));
        });
  }
}
