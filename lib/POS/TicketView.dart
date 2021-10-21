import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:denario/POS/ActiveOrders.dart';
import 'package:denario/POS/ConfirmOrder.dart';
import 'package:denario/POS/MoreTicketPopUp.dart';
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

  var orderDetail;
  Map<String, dynamic> orderCategories;
  Map currentValues;
  double subTotal = 0;
  double tax = 0;
  double discount = 0;
  double total = 0;
  Color color = Colors.white;

  void clearVariables() {
    bloc.removeAllFromCart();
    _controller.clear();

    setState(() {
      discount = 0;
      tax = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final registerStatus = Provider.of<CashRegister>(context);
    final categoriesProvider = Provider.of<CategoryList>(context);

    if (registerStatus == null || categoriesProvider == null) {
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
                    SizedBox(height: 15),
                    //Actions (Save, Process)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Guardar
                        Container(
                          height: 40,
                          width: 40,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white70),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Colors.grey.shade300;
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed))
                                    return Colors.white;
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
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
                                '',
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
                              size: 18,
                            )),
                          ),
                        ),
                        SizedBox(width: 10),
                        //PopUp Menu
                        MoreTicketPopUp(categoriesProvider: categoriesProvider),
                        SizedBox(width: 10),
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
                                          subTotal: subTotal,
                                          tax: tax,
                                          controller: _controller,
                                          clearVariables: clearVariables,
                                          paymentTypes:
                                              registerStatus.paymentTypes),
                                    );
                                  });
                            },
                            child: Center(
                                child: Text('Pagar  \$ $total',
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
