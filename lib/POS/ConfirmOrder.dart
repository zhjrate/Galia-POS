import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatefulWidget {
  final double total;
  final dynamic items;

  final double subTotal;
  final double discount;
  final double tax;
  final orderDetail;
  final String orderName;
  final clearVariables;
  final List paymentTypes;

  final TextEditingController controller;

  ConfirmOrder(
      {this.total,
      this.items,
      this.discount,
      this.orderDetail,
      this.orderName,
      this.subTotal,
      this.tax,
      this.controller,
      this.clearVariables,
      this.paymentTypes});

  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  Map<String, dynamic> orderCategories;
  Future currentValuesBuilt;
  double salesAmount;
  String paymentType;
  bool otherChanageAmount;
  double paysWith = 0;
  FocusNode otherChangeNode;

  Future currentValue() async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    var firestore = FirebaseFirestore.instance;

    var docRef = firestore
        .collection('ERP')
        .doc('VTam7iYZhiWiAFs3IVRBaLB5s3m2')
        .collection(year)
        .doc(month)
        .get();
    return docRef;
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue();
    paymentType = 'Efectivo';
    otherChanageAmount = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    if (dailyTransactions == null) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            width: 400,
            height: 250,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment(1.0, 0.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                        iconSize: 20.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: (MediaQuery.of(context).size.width > 900)
                              ? 350
                              : MediaQuery.of(context).size.width * 0.5),
                      child: Text(
                        "Recuerda abrir caja antes de procesar pedidos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ));
    }

    return FutureBuilder(
        future: currentValuesBuilt,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            try {
              salesAmount = snap.data['Ventas'];
            } catch (e) {
              //
            }

            return SingleChildScrollView(
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: 400,
                    constraints: BoxConstraints(minHeight: 350),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Splt / Close
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Split
                                OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white70),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered))
                                          return Colors.grey.shade300;
                                        if (states.contains(
                                                MaterialState.focused) ||
                                            states.contains(
                                                MaterialState.pressed))
                                          return Colors.white;
                                        return null; // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Center(
                                      child: Text(
                                    'Split',
                                    style: TextStyle(color: Colors.black),
                                  )),
                                ),
                                Spacer(),
                                //Confirm Text
                                Text(
                                  "Confirmar pedido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                //Cancel
                                IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(Icons.close),
                                    splashRadius: 5,
                                    iconSize: 20.0),
                              ]),
                        ),
                        Divider(thickness: 0.5, indent: 0, endIndent: 0),
                        SizedBox(height: 15),
                        //Amount
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Text
                                Text(
                                  "Total:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                //Amount
                                Text(
                                  "\$${widget.total}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                        ),
                        Divider(thickness: 0.5, indent: 0, endIndent: 0),
                        SizedBox(
                          height: 15,
                        ),
                        //Change AMOUNT
                        (paymentType == 'Efectivo')
                            ? Container(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Text
                                      Text(
                                        "Paga con:",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      //Pays with
                                      (!otherChanageAmount)
                                          ? Row(
                                              children: [
                                                //500
                                                OutlinedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .green.shade200
                                                                .withOpacity(
                                                                    0.5)),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .hovered))
                                                          return Colors
                                                              .green.shade300;
                                                        if (states.contains(
                                                                MaterialState
                                                                    .focused) ||
                                                            states.contains(
                                                                MaterialState
                                                                    .pressed))
                                                          return Colors.green;
                                                        return null; // Defer to the widget's default.
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      paysWith = 500;
                                                    });
                                                  },
                                                  child: Center(
                                                      child: Text(
                                                    '\$500',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                                ),
                                                SizedBox(width: 10),
                                                //1000
                                                OutlinedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .orange.shade100
                                                                .withOpacity(
                                                                    0.5)),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .hovered))
                                                          return Colors
                                                              .orange.shade200;
                                                        if (states.contains(
                                                                MaterialState
                                                                    .focused) ||
                                                            states.contains(
                                                                MaterialState
                                                                    .pressed))
                                                          return Colors
                                                              .orange.shade400;
                                                        return null; // Defer to the widget's default.
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      paysWith = 1000;
                                                    });
                                                  },
                                                  child: Center(
                                                      child: Text(
                                                    '\$1.000',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                                ),
                                                SizedBox(width: 10),
                                                //otro
                                                OutlinedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white70),
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .resolveWith<Color>(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .hovered))
                                                          return Colors
                                                              .grey.shade300;
                                                        if (states.contains(
                                                                MaterialState
                                                                    .focused) ||
                                                            states.contains(
                                                                MaterialState
                                                                    .pressed))
                                                          return Colors.grey;
                                                        return null; // Defer to the widget's default.
                                                      },
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      otherChanageAmount = true;
                                                    });
                                                  },
                                                  child: Center(
                                                      child: Text(
                                                    'Otro',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                                ),
                                              ],
                                            )
                                          : Container(
                                              height: 50,
                                              width: 70,
                                              child: Center(
                                                child: TextFormField(
                                                  autofocus: true,
                                                  focusNode: otherChangeNode,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                      color: Colors.black),
                                                  validator: (val) =>
                                                      val.contains(',')
                                                          ? "Usa punto"
                                                          : null,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r"[0-9]+[.]?[0-9]*"))
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: Colors.black,
                                                  decoration:
                                                      InputDecoration.collapsed(
                                                    hintText: "0",
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade700),
                                                  ),
                                                  onChanged: (val) {
                                                    setState(() => paysWith =
                                                        double.parse(val));
                                                  },
                                                ),
                                              ),
                                            ),
                                    ]),
                              )
                            : Container(),
                        SizedBox(
                          height: (paymentType == 'Efectivo') ? 15 : 0,
                        ),
                        //Change FORMULA
                        (paymentType == 'Efectivo')
                            ? Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Text
                                    Text(
                                      "Cambio:  \$${paysWith - widget.total}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: (paymentType == 'Efectivo') ? 15 : 0,
                        ),
                        (paymentType == 'Efectivo')
                            ? Divider(thickness: 0.5, indent: 0, endIndent: 0)
                            : Container(),
                        SizedBox(
                          height: 15,
                        ),
                        //Payment type
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Text
                                Text(
                                  "Método:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 15),
                                //List of payment methods
                                Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.paymentTypes.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                paymentType = widget
                                                    .paymentTypes[i]['Type'];
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: (paymentType ==
                                                                widget.paymentTypes[
                                                                    i]['Type'])
                                                            ? Colors.green
                                                            : Colors.white10,
                                                        width: 2),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          widget.paymentTypes[i]
                                                              ['Image']),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ]),
                        ),
                        SizedBox(height: 25),
                        //Buttons
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //Confirmar
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.hovered))
                                            return Colors.grey;
                                          if (states.contains(
                                                  MaterialState.focused) ||
                                              states.contains(
                                                  MaterialState.pressed))
                                            return Colors.grey.shade300;
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      double newSalesAmount = 0;
                                      //Date variables
                                      var year = DateTime.now().year.toString();
                                      var month =
                                          DateTime.now().month.toString();

                                      ////////////////////////Update Accounts (sales and categories)
                                      if (salesAmount == null ||
                                          salesAmount < 1) {
                                        newSalesAmount =
                                            widget.total.toDouble();
                                      } else {
                                        newSalesAmount = salesAmount +
                                            widget.total.toDouble();
                                      }
                                      //Set Categories Variables
                                      orderCategories = {};
                                      final cartList = widget.items;

                                      //Logic to retrieve and add up categories totals
                                      for (var i = 0;
                                          i < cartList.length;
                                          i++) {
                                        //Check if the map contains the key
                                        if (orderCategories.containsKey(
                                            'Ventas de ${cartList[i]["Category"]}')) {
                                          //Add to existing category amount
                                          orderCategories.update(
                                              'Ventas de ${cartList[i]["Category"]}',
                                              (value) =>
                                                  value +
                                                  (cartList[i]["Price"] *
                                                      cartList[i]["Quantity"]));
                                        } else {
                                          //Add new category with amount
                                          orderCategories[
                                                  'Ventas de ${cartList[i]["Category"]}'] =
                                              cartList[i]["Price"] *
                                                  cartList[i]["Quantity"];
                                        }
                                      }
                                      //Logic to add Sales by Categories to Firebase based on current Values from snap
                                      orderCategories.forEach((k, v) {
                                        try {
                                          orderCategories.update(
                                              k,
                                              (value) =>
                                                  v = v + snap.data['$k']);
                                        } catch (e) {
                                          //Do nothing
                                        }
                                      });
                                      //Add Total sales edited to map
                                      orderCategories['Ventas'] =
                                          newSalesAmount;

                                      //Create Sale
                                      DatabaseService().createOrder(
                                          year,
                                          month,
                                          DateTime.now().toString(),
                                          widget.subTotal,
                                          widget.discount,
                                          widget.tax,
                                          widget.total,
                                          widget.orderDetail,
                                          widget.orderName,
                                          paymentType);

                                      /////Save Sales and Order Categories to database
                                      DatabaseService()
                                          .saveOrderType(orderCategories);

                                      ///////////////////////////Register in Daily Transactions
                                      double totalDailySales = 0;
                                      double totalDailyTransactions = 0;
                                      List salesByMedium = [];
                                      setState(() {
                                        totalDailySales =
                                            dailyTransactions.sales +
                                                widget.total;
                                        totalDailyTransactions =
                                            dailyTransactions
                                                    .dailyTransactions +
                                                widget.total;
                                        salesByMedium =
                                            dailyTransactions.salesByMedium;
                                      });
                                      /////Update Sales by Medium
                                      bool listUpdated = false;

                                      for (var map in salesByMedium) {
                                        if (map["Type"] == paymentType) {
                                          map['Amount'] =
                                              map['Amount'] + widget.total;
                                          listUpdated = true;
                                        }
                                      }
                                      if (!listUpdated) {
                                        salesByMedium.add({
                                          'Type': paymentType,
                                          'Amount': widget.total
                                        });
                                      }

                                      DatabaseService()
                                          .updateSalesinCashRegister(
                                              dailyTransactions.openDate
                                                  .toString(),
                                              totalDailySales,
                                              salesByMedium,
                                              totalDailyTransactions);

                                      /////////////////Clear Variables
                                      widget.clearVariables();
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Center(
                                        child: Text('Confirmar'),
                                      ),
                                    )),
                              ]),
                        ),
                      ],
                    ),
                  )),
            );
          } else {
            return SingleChildScrollView(
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: 400,
                    constraints: BoxConstraints(minHeight: 350),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Splt / Close
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Split
                                OutlinedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white70),
                                    overlayColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.hovered))
                                          return Colors.grey.shade300;
                                        if (states.contains(
                                                MaterialState.focused) ||
                                            states.contains(
                                                MaterialState.pressed))
                                          return Colors.white;
                                        return null; // Defer to the widget's default.
                                      },
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Center(
                                      child: Text(
                                    'Split',
                                    style: TextStyle(color: Colors.black),
                                  )),
                                ),
                                Spacer(),
                                //Confirm Text
                                Text(
                                  "Confirmar pedido",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                //Cancel
                                IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: Icon(Icons.close),
                                    splashRadius: 5,
                                    iconSize: 20.0),
                              ]),
                        ),
                        Divider(thickness: 0.5, indent: 0, endIndent: 0),
                        SizedBox(height: 15),
                        //Amount
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Text
                                Text(
                                  "Total:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                //Amount
                                Text(
                                  "\$${widget.total}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                        ),
                        Divider(thickness: 0.5, indent: 0, endIndent: 0),
                        SizedBox(
                          height: 15,
                        ),
                        //Change AMOUNT
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Text
                                Text(
                                  "Paga con:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                //Pays with
                                (!otherChanageAmount)
                                    ? Row(
                                        children: [
                                          //500
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.green.shade200
                                                          .withOpacity(0.5)),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered))
                                                    return Colors
                                                        .green.shade300;
                                                  if (states.contains(
                                                          MaterialState
                                                              .focused) ||
                                                      states.contains(
                                                          MaterialState
                                                              .pressed))
                                                    return Colors.green;
                                                  return null; // Defer to the widget's default.
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                paysWith = 500;
                                              });
                                            },
                                            child: Center(
                                                child: Text(
                                              '\$500',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                          ),
                                          SizedBox(width: 10),
                                          //1000
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.orange.shade100
                                                          .withOpacity(0.5)),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered))
                                                    return Colors
                                                        .orange.shade200;
                                                  if (states.contains(
                                                          MaterialState
                                                              .focused) ||
                                                      states.contains(
                                                          MaterialState
                                                              .pressed))
                                                    return Colors
                                                        .orange.shade400;
                                                  return null; // Defer to the widget's default.
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                paysWith = 1000;
                                              });
                                            },
                                            child: Center(
                                                child: Text(
                                              '\$1.000',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                          ),
                                          SizedBox(width: 10),
                                          //otro
                                          OutlinedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white70),
                                              overlayColor:
                                                  MaterialStateProperty
                                                      .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(
                                                      MaterialState.hovered))
                                                    return Colors.grey.shade300;
                                                  if (states.contains(
                                                          MaterialState
                                                              .focused) ||
                                                      states.contains(
                                                          MaterialState
                                                              .pressed))
                                                    return Colors.grey;
                                                  return null; // Defer to the widget's default.
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                otherChanageAmount = true;
                                              });
                                            },
                                            child: Center(
                                                child: Text(
                                              'Otro',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        height: 50,
                                        width: 70,
                                        child: Center(
                                          child: TextFormField(
                                            autofocus: true,
                                            focusNode: otherChangeNode,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Colors.black),
                                            validator: (val) =>
                                                val.contains(',')
                                                    ? "Usa punto"
                                                    : null,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9]+[.]?[0-9]*"))
                                            ],
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.black,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: "0",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                            onChanged: (val) {
                                              setState(() =>
                                                  paysWith = double.parse(val));
                                            },
                                          ),
                                        ),
                                      ),
                              ]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //Change FORMULA
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //Text
                              Text(
                                "Cambio:  \$${paysWith - widget.total}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(thickness: 0.5, indent: 0, endIndent: 0),
                        SizedBox(
                          height: 15,
                        ),
                        //Payment type
                        Container(
                          width: double.infinity,
                          height: 60,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Text
                                Text(
                                  "Método:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 15),
                                //List of payment methods
                                Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.paymentTypes.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                paymentType = widget
                                                    .paymentTypes[i]['Type'];
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: (paymentType ==
                                                                widget.paymentTypes[
                                                                    i]['Type'])
                                                            ? Colors.green
                                                            : Colors.white10,
                                                        width: 2),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          widget.paymentTypes[i]
                                                              ['Image']),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ]),
                        ),
                        SizedBox(height: 25),
                        //Buttons
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                //Confirmar
                                ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.hovered))
                                            return Colors.grey;
                                          if (states.contains(
                                                  MaterialState.focused) ||
                                              states.contains(
                                                  MaterialState.pressed))
                                            return Colors.grey.shade300;
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      child: Center(
                                        child: Text('Confirmar'),
                                      ),
                                    )),
                              ]),
                        ),
                      ],
                    ),
                  )),
            );
          }
        });
  }
}
