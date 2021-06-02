import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
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
  int subTotal = 0;
  double tax = 0;
  int discount = 0;
  int total = 0;

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
    return StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.ticketItems,
        builder: (context, snapshot) {
          subTotal = snapshot.data["Subtotal"];
          tax = snapshot.data["IVA"];
          discount = snapshot.data["Discount"];
          total = snapshot.data["Total"];
          orderName = snapshot.data["Order Name"];

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
                    Row(
                      children: [
                        Text('Pedidos: '),
                        SizedBox(width: 5),
                        StreamProvider<List<SavedOrders>>.value(
                            value: DatabaseService().orderList(),
                            child: ActiveOrders())
                      ],
                    ),
                    Divider(thickness: 0.5, indent: 0, endIndent: 0),
                    SizedBox(height: 5),
                    //Order Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pedido: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: TextFormField(
                              controller:
                                  _controller, //..text = snapshot.data["Order Name"],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(15)
                              ],
                              cursorColor: Theme.of(context).accentColor,
                              decoration: InputDecoration.collapsed(
                                hintText: (snapshot.data["Order Name"] == '')
                                    ? 'Mesa 1'
                                    : snapshot.data["Order Name"],
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
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
                    SizedBox(height: 5),
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
                            child: Text('Subtotal:'),
                          ),
                          Spacer(),
                          Text('\$$subTotal'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
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
                                            Container(
                                              height: 35.0,
                                              width: 100,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    tax = 0;
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
                                            Container(
                                              height: 35.0,
                                              width: 100,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    tax = 0.12;
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
                                                      "12%",
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
                              child: Text('IVA:'),
                            ),
                            Spacer(),
                            Text('\$${(subTotal * tax).toStringAsFixed(1)}'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
                                                  discount = int.tryParse(val);
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
                              child: Text('Descuetos:'),
                            ),
                            Spacer(),
                            Text('\$$discount'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
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
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Spacer(),
                          Text('\$$total',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    //Payment type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Efectivo
                        InkWell(
                          onTap: () {
                            setState(() {
                              paymentType = 'Efectivo';
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                                border: Border.all(
                                    color: (paymentType == 'Efectivo')
                                        ? Colors.green
                                        : Colors.white10,
                                    width: 2),
                                image: DecorationImage(
                                  image: AssetImage('images/Cash.png'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        //MercadoPago
                        InkWell(
                          onTap: () {
                            setState(() {
                              paymentType = 'MercadoPago';
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                                border: Border.all(
                                    color: (paymentType == 'MercadoPago')
                                        ? Colors.green
                                        : Colors.white10,
                                    width: 2),
                                image: DecorationImage(
                                  image: AssetImage('images/MP.png'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        //Card
                        InkWell(
                          onTap: () {
                            setState(() {
                              paymentType = 'LAPOS';
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                                border: Border.all(
                                    color: (paymentType == 'LAPOS')
                                        ? Colors.green
                                        : Colors.white10,
                                    width: 2),
                                image: DecorationImage(
                                  image: AssetImage('images/CreditCard.png'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        //PedidosYA
                        InkWell(
                          onTap: () {
                            setState(() {
                              paymentType = 'PedidosYa';
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                                border: Border.all(
                                    color: (paymentType == 'PedidosYa')
                                        ? Colors.green
                                        : Colors.white10,
                                    width: 2),
                                image: DecorationImage(
                                  image: AssetImage('images/PedidosYA.png'),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                                Colors
                                    .primaries[Random()
                                        .nextInt(Colors.primaries.length)]
                                    .value,
                              );

                              //Clear Variables
                              bloc.removeAllFromCart();
                              _controller.clear();
                              setState(() {
                                discount = 0;
                                tax = 0;
                                paymentType = 'Efectivo';
                              });
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
                                    return ConfirmOrder(
                                        total: total,
                                        items: snapshot.data["Items"],
                                        discount: discount,
                                        orderDetail: orderDetail,
                                        orderName: orderName,
                                        paymentType: paymentType,
                                        subTotal: subTotal,
                                        tax: tax,
                                        controller: _controller,
                                        clearVariables: clearVariables);
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
