import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/No%20POS%20Sales/ScheduleSaleDialog.dart';
import 'package:denario/No%20POS%20Sales/SelectItemDialog.dart';
import 'package:denario/POS/DiscountDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewSaleScreen extends StatefulWidget {
  final String currentBusiness;
  NewSaleScreen(this.currentBusiness);

  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  int numberOfItems = 0;
  String invoiceNo;
  DateTime selectedIvoiceDate;
  String clientName = '';
  final FocusNode _clientNode = FocusNode();
  List saleStatusList = ['Cobrado', 'Venta por cobrar'];
  String saleStatus = 'Cobrado';

  String orderName;
  double subTotal;
  double tax;
  double discount;
  double total;
  Color color = Colors.white;

  List<TextEditingController> _controllers = [];
  TextEditingController invoiceController;
  TextEditingController clientController;

  ValueKey redrawObject = ValueKey('List');

  Map<String, dynamic> orderCategories;
  double salesAmount;
  String paymentType;

  //Month Stats Variables
  Map<String, dynamic> orderStats = {};
  int currentSalesCount;
  Map<String, dynamic> currentItemsCount = {};
  Map<String, dynamic> currentItemsAmount = {};
  Map<String, dynamic> salesCountbyCategory = {};
  Map<String, dynamic> currentSalesbyOrderType = {};
  int newSalesCount;
  int currentTicketItemsCount;
  int newTicketItemsCount;

  Future currentValue() async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    var firestore = FirebaseFirestore.instance;

    var docRef = firestore
        .collection('ERP')
        .doc(widget.currentBusiness)
        .collection(year)
        .doc(month)
        .get();
    return docRef;
  }

  Future currentValuesBuilt;

  void clearControllers() {
    setState(() {
      _controllers = [];
      invoiceNo = '00' +
          (DateTime.now().day).toString() +
          (DateTime.now().month).toString() +
          (DateTime.now().year).toString() +
          (DateTime.now().hour).toString() +
          (DateTime.now().minute).toString() +
          (DateTime.now().millisecond).toString();
      selectedIvoiceDate = DateTime.now();
      orderName = 'Sin Agregar';
      subTotal = 0;
      tax = 0;
      discount = 0;
      total = 0;
      clientController = new TextEditingController(text: '');
      invoiceController = new TextEditingController(text: invoiceNo);
    });
  }

  void initState() {
    invoiceNo = '00' +
        (DateTime.now().day).toString() +
        (DateTime.now().month).toString() +
        (DateTime.now().year).toString() +
        (DateTime.now().hour).toString() +
        (DateTime.now().minute).toString() +
        (DateTime.now().millisecond).toString();
    selectedIvoiceDate = DateTime.now();
    orderName = 'Sin Agregar';
    subTotal = 0;
    tax = 0;
    discount = 0;
    total = 0;
    currentValuesBuilt = currentValue();
    invoiceController = new TextEditingController(text: invoiceNo);
    clientController = new TextEditingController(text: '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserData>(context);
    final monthlyStats = Provider.of<MonthlyStats>(context);

    if (monthlyStats == null) {
      currentSalesCount = 0;
      currentTicketItemsCount = 0;
      currentItemsCount = {};
      currentItemsAmount = {};
      salesCountbyCategory = {};
    }

    try {
      currentSalesCount = monthlyStats.totalSalesCount;
    } catch (e) {
      //
    }
    try {
      currentItemsCount = monthlyStats.salesCountbyProduct;
    } catch (e) {
      currentItemsCount = {};
    }
    try {
      currentItemsAmount = monthlyStats.salesAmountbyProduct;
    } catch (e) {
      currentItemsAmount = {};
    }
    try {
      currentTicketItemsCount = monthlyStats.totalItemsSold;
    } catch (e) {
      currentTicketItemsCount = 0;
    }
    try {
      salesCountbyCategory = monthlyStats.salesCountbyCategory;
    } catch (e) {
      salesCountbyCategory = {};
    }
    try {
      currentSalesbyOrderType = monthlyStats.salesbyOrderType;
    } catch (e) {
      currentSalesbyOrderType = {};
    }

    return FutureBuilder(
        future: currentValuesBuilt,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
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

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: IconButton(
                                  onPressed: () {
                                    bloc.removeAllFromCart();
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.arrow_back),
                                  iconSize: 20.0),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Text(
                                'Nueva venta',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 28),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: 900,
                          padding: EdgeInsets.all(40),
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
                              //Heading
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Negocio
                                  Text(
                                    'Café Galia',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24),
                                  ),
                                  Spacer(),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              //Invoice and client
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Invoice
                                  Expanded(
                                    child: Container(
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                        cursorColor: Colors.grey,
                                        controller: invoiceController,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          label: Text(
                                            'Nro de referencia',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.black45),
                                          ),
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(12.0),
                                            borderSide: new BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(12.0),
                                            borderSide: new BorderSide(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 40),
                                  //Client
                                  Expanded(
                                    child: Container(
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                        cursorColor: Colors.grey,
                                        focusNode: _clientNode,
                                        controller: clientController,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          label: Text(
                                            'Cliente',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.black45),
                                          ),
                                          errorStyle: TextStyle(
                                              color: Colors.redAccent[700],
                                              fontSize: 12),
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(12.0),
                                            borderSide: new BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(12.0),
                                            borderSide: new BorderSide(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        onFieldSubmitted: (term) {
                                          _clientNode.unfocus();
                                          // FocusScope.of(context).requestFocus(_tlfNode);
                                        },
                                        onChanged: (val) {
                                          setState(() {
                                            clientName = val;
                                            clientController.text = val;
                                            clientController.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                                        offset: clientController
                                                            .text.length));
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              //Date and status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Fecha',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.black45),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          padding: EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              Text(
                                                DateFormat('dd/MM/yyyy')
                                                    .format(selectedIvoiceDate),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 20,
                                                width: 20,
                                                child: IconButton(
                                                  splashRadius: 1,
                                                  onPressed: () async {
                                                    DateTime pickedDate =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate: DateTime
                                                                    .now()
                                                                .subtract(
                                                                    Duration(
                                                                        days:
                                                                            10)),
                                                            lastDate:
                                                                DateTime.now(),
                                                            builder: ((context,
                                                                child) {
                                                              return Theme(
                                                                  data: Theme.of(
                                                                          context)
                                                                      .copyWith(
                                                                    colorScheme:
                                                                        ColorScheme
                                                                            .light(
                                                                      primary:
                                                                          Colors
                                                                              .black, // header background color
                                                                      onPrimary:
                                                                          Colors
                                                                              .white, // header text color
                                                                      onSurface:
                                                                          Colors
                                                                              .black, // body text color
                                                                    ),
                                                                    textButtonTheme:
                                                                        TextButtonThemeData(
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        foregroundColor:
                                                                            Colors.black, // button text color
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: child);
                                                            }));
                                                    setState(() {
                                                      if (pickedDate != null) {
                                                        selectedIvoiceDate =
                                                            pickedDate;
                                                      }
                                                    });
                                                  },
                                                  padding: EdgeInsets.all(0),
                                                  tooltip:
                                                      'Seleccionar fecha de la venta',
                                                  iconSize: 18,
                                                  icon: Icon(
                                                      Icons.calendar_month),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                                  SizedBox(width: 40),
                                  Expanded(
                                      child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.black45),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: DropdownButton(
                                            isExpanded: true,
                                            underline: SizedBox(),
                                            hint: Text(
                                              'Cobrado',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.black),
                                            value: saleStatus,
                                            items: saleStatusList.map((i) {
                                              return new DropdownMenuItem(
                                                value: i,
                                                child: new Text(i),
                                              );
                                            }).toList(),
                                            onChanged: (x) {
                                              setState(() {
                                                saleStatus = x;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 25),
                              //Lista de items
                              Text(
                                'Items',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(height: 20),
                              ListView.builder(
                                  key: redrawObject,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data["Items"].length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //Product
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              width: 400,
                                              height: 50,
                                              child: TextFormField(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                                cursorColor: Colors.grey,
                                                textInputAction:
                                                    TextInputAction.next,
                                                initialValue: snapshot
                                                    .data["Items"][i]['Name'],
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  label: Text('Descripción'),
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                  errorStyle: TextStyle(
                                                      color:
                                                          Colors.redAccent[700],
                                                      fontSize: 12),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(12.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(12.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          //Price
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: 100,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                                autofocus: true,
                                                cursorColor: Colors.grey,
                                                textInputAction:
                                                    TextInputAction.next,
                                                inputFormatters: [
                                                  CurrencyTextInputFormatter(
                                                    name: '\$',
                                                    locale: 'en',
                                                    decimalDigits: 2,
                                                  ),
                                                ],
                                                initialValue: (snapshot
                                                                .data["Items"]
                                                            [i]['Price'] >
                                                        0)
                                                    ? '\$${snapshot.data["Items"][i]['Price']}'
                                                    : null,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  hintText: '\$0.00',
                                                  label: Text('Precio'),
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                  errorStyle: TextStyle(
                                                      color:
                                                          Colors.redAccent[700],
                                                      fontSize: 12),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(12.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(12.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                onFieldSubmitted: (term) {
                                                  // _nameNode.unfocus();
                                                  // FocusScope.of(context).requestFocus(_tlfNode);
                                                },
                                                onChanged: (val) {
                                                  bloc.editPrice(
                                                      i,
                                                      double.tryParse(
                                                          (val.substring(1))
                                                              .replaceAll(
                                                                  ',', '')));
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          //Qty
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: 75,
                                              child: TextFormField(
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                                textAlign: TextAlign.center,
                                                autofocus: true,
                                                cursorColor: Colors.grey,
                                                textInputAction:
                                                    TextInputAction.next,
                                                initialValue: snapshot
                                                    .data["Items"][i]
                                                        ['Quantity']
                                                    .toString(),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  label: Text('Cantidad'),
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                  errorStyle: TextStyle(
                                                      color:
                                                          Colors.redAccent[700],
                                                      fontSize: 12),
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(12.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(12.0),
                                                    borderSide: new BorderSide(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                                onFieldSubmitted: (term) {
                                                  // _nameNode.unfocus();
                                                  // FocusScope.of(context).requestFocus(_tlfNode);
                                                },
                                                onChanged: (val) {
                                                  bloc.editQuantity(
                                                      i, int.parse(val));
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          //Total
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              padding: EdgeInsets.all(12),
                                              child: Text(
                                                formatCurrency.format(
                                                    snapshot.data["Items"][i]
                                                        ['Total Price']),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          //Detele
                                          IconButton(
                                              onPressed: () {
                                                bloc.removeFromCart(
                                                    snapshot.data["Items"][i]);

                                                final random = Random();
                                                const availableChars =
                                                    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                                final randomString = List.generate(
                                                    10,
                                                    (index) => availableChars[
                                                        random.nextInt(
                                                            availableChars
                                                                .length)]).join();
                                                setState(() {
                                                  redrawObject =
                                                      ValueKey(randomString);
                                                });
                                              },
                                              icon: Icon(Icons.delete))
                                        ],
                                      ),
                                    );
                                  }),

                              //Boton de Agregar Items (cuadrado con +) => Lleva a seleccionar productos
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    for (var x = 0; x < 3; x++) {
                                      _controllers
                                          .add(new TextEditingController());
                                    }

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StreamProvider<
                                                  CategoryList>.value(
                                              initialData: null,
                                              value: DatabaseService()
                                                  .categoriesList(userProfile
                                                      .activeBusiness),
                                              child: SelectItemDialog(
                                                  userProfile));
                                        });
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    child: Center(
                                        child: Icon(
                                      Icons.add,
                                      color: Colors.black87,
                                      size: 30,
                                    )),
                                  ),
                                ),
                              ),
                              //Spacer

                              //Impuesto + boton para editar
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text
                                    Text(
                                      'Subtotal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    SizedBox(width: 25),
                                    //Amount
                                    Text(
                                      formatCurrency.format(subTotal),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              //Discount
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //Button
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return DiscountDialog();
                                            });
                                      },
                                      icon: Icon(Icons.edit),
                                      splashRadius: 5,
                                    ),
                                    SizedBox(width: 15),
                                    //Text
                                    Text(
                                      'Descuento',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    SizedBox(width: 25),
                                    //Amount
                                    Text(
                                      formatCurrency.format(discount),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              //Total
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text
                                    Text(
                                      'TOTAL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                    SizedBox(width: 25),
                                    //Amount
                                    Text(
                                      formatCurrency.format(total),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 50),
                              //Confirm Button
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Schedule
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ScheduleSaleDialog(
                                                    widget.currentBusiness,
                                                    total,
                                                    discount,
                                                    tax,
                                                    subTotal,
                                                    bloc.ticketItems['Items'],
                                                    clientName,
                                                    clearControllers);
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: Center(
                                            child: Text('Agendar venta'),
                                          ),
                                        )),
                                    SizedBox(width: 25),
                                    //Confirm and create new
                                    OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                        ),
                                        onPressed: () {
                                          double newSalesAmount = 0;
                                          //Date variables
                                          var year =
                                              DateTime.now().year.toString();
                                          var month =
                                              DateTime.now().month.toString();

                                          ////////////////////////Update Accounts (sales and categories)
                                          try {
                                            newSalesAmount =
                                                snap.data['Ventas'] +
                                                    total.toDouble();
                                          } catch (e) {
                                            newSalesAmount = total.toDouble();
                                          }
                                          // if (snap.data['Ventas'] == null ||
                                          //     snap.data['Ventas'] < 1) {
                                          //   newSalesAmount = total.toDouble();
                                          // } else {
                                          //   newSalesAmount =
                                          //       snap.data['Ventas'] +
                                          //           total.toDouble();
                                          // }

                                          //Set Categories Variables
                                          orderCategories = {};
                                          final cartList =
                                              bloc.ticketItems['Items'];

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
                                                          cartList[i]
                                                              ["Quantity"]));
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

                                          // //Create Sale
                                          DatabaseService().createOrder(
                                              userProfile.activeBusiness,
                                              year,
                                              month,
                                              selectedIvoiceDate,
                                              subTotal,
                                              discount,
                                              tax,
                                              total,
                                              snapshot.data['Items'],
                                              orderName,
                                              'Efectivo',
                                              clientName,
                                              {
                                                'Name': orderName,
                                                'Address': '',
                                                'Phone': 0,
                                                'email': '',
                                              },
                                              invoiceNo,
                                              '',
                                              false);

                                          /////Save Sales and Order Categories to database
                                          DatabaseService().saveOrderType(
                                              userProfile.activeBusiness,
                                              orderCategories);

                                          // /////////////////////////// MONTH STATS ///////////////////////////

                                          //Sales Count
                                          if (currentSalesCount == null ||
                                              currentSalesCount < 1) {
                                            newSalesCount = 1;
                                          } else {
                                            newSalesCount =
                                                currentSalesCount + 1;
                                          }

                                          //Set Categories Variables
                                          orderStats = {};

                                          //Items Sold
                                          if (currentTicketItemsCount == null ||
                                              currentTicketItemsCount < 1) {
                                            newTicketItemsCount =
                                                cartList.length;
                                          } else {
                                            newTicketItemsCount =
                                                currentTicketItemsCount +
                                                    cartList.length;
                                          }

                                          ////////////////////////////Add amounts by category/account

                                          //Logic to add up categories totals in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (salesCountbyCategory.containsKey(
                                                '${cartList[i]["Category"]}')) {
                                              //Add to existing category amount
                                              salesCountbyCategory.update(
                                                  '${cartList[i]["Category"]}',
                                                  (value) =>
                                                      value +
                                                      (cartList[i]["Price"] *
                                                          cartList[i]
                                                              ["Quantity"]));
                                            } else {
                                              //Add new category with amount
                                              salesCountbyCategory[
                                                      '${cartList[i]["Category"]}'] =
                                                  cartList[i]["Price"] *
                                                      cartList[i]["Quantity"];
                                            }
                                          }

                                          ////////////////////////////Add by item count

                                          //Logic to add up item count  in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (currentItemsCount.containsKey(
                                                '${cartList[i]["Name"]}')) {
                                              //Add to existing category amount
                                              currentItemsCount.update(
                                                  '${cartList[i]["Name"]}',
                                                  (value) =>
                                                      value +
                                                      cartList[i]["Quantity"]);
                                            } else {
                                              //Add new category with amount
                                              currentItemsCount[
                                                      '${cartList[i]["Name"]}'] =
                                                  cartList[i]["Quantity"];
                                            }
                                          }

                                          //Logic to add up item Amount  in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (currentItemsAmount.containsKey(
                                                '${cartList[i]["Name"]}')) {
                                              //Add to existing category amount
                                              currentItemsAmount.update(
                                                  '${cartList[i]["Name"]}',
                                                  (value) =>
                                                      value +
                                                      (cartList[i]["Price"] *
                                                          cartList[i]
                                                              ["Quantity"]));
                                            } else {
                                              //Add new category with amount
                                              currentItemsAmount[
                                                      '${cartList[i]["Name"]}'] =
                                                  (cartList[i]["Price"] *
                                                      cartList[i]["Quantity"]);
                                            }
                                          }

                                          orderStats['Total Sales'] =
                                              newSalesAmount;
                                          orderStats['Total Sales Count'] =
                                              newSalesCount;
                                          orderStats['Total Items Sold'] =
                                              newTicketItemsCount;
                                          orderStats['Sales Count by Product'] =
                                              currentItemsCount;
                                          orderStats[
                                                  'Sales Amount by Product'] =
                                              currentItemsAmount;
                                          orderStats[
                                                  'Sales Count by Category'] =
                                              salesCountbyCategory;

                                          //Save Details to Firestore Historic
                                          DatabaseService().saveOrderStats(
                                              userProfile.activeBusiness,
                                              orderStats);

                                          /////////////////Clear Variables
                                          bloc.removeAllFromCart();
                                          _controllers = [];
                                          setState(() {
                                            invoiceNo = '00' +
                                                (DateTime.now().day)
                                                    .toString() +
                                                (DateTime.now().month)
                                                    .toString() +
                                                (DateTime.now().year)
                                                    .toString() +
                                                (DateTime.now().hour)
                                                    .toString() +
                                                (DateTime.now().minute)
                                                    .toString() +
                                                (DateTime.now().millisecond)
                                                    .toString();

                                            selectedIvoiceDate = DateTime.now();
                                            clientName = '';
                                            invoiceController =
                                                new TextEditingController(
                                                    text: invoiceNo);
                                            clientController.text = '';
                                          });

                                          //Start Over
                                          Timer timer = Timer(
                                              Duration(milliseconds: 1500), () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          });
                                          showDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return Center(
                                                  child: Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      child: Container(
                                                        height: 200,
                                                        width: 300,
                                                        padding:
                                                            EdgeInsets.all(30),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            //Text
                                                            Text(
                                                              "La venta se registró con éxito!",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 30),
                                                            //Icom
                                                            Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.green,
                                                              size: 65,
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                );
                                              }).then((value) {
                                            // dispose the timer in case something else has triggered the dismiss.
                                            timer?.cancel();
                                            timer = null;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: Center(
                                            child: Text(
                                                'Confirmar y crear otra venta'),
                                          ),
                                        )),
                                    SizedBox(width: 25),
                                    //Confirm and close
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.hovered))
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
                                          var year =
                                              DateTime.now().year.toString();
                                          var month =
                                              DateTime.now().month.toString();

                                          ////////////////////////Update Accounts (sales and categories)
                                          try {
                                            newSalesAmount =
                                                snap.data['Ventas'] +
                                                    total.toDouble();
                                          } catch (e) {
                                            newSalesAmount = total.toDouble();
                                          }

                                          //Set Categories Variables
                                          orderCategories = {};
                                          final cartList =
                                              bloc.ticketItems['Items'];

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
                                                          cartList[i]
                                                              ["Quantity"]));
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

                                          // //Create Sale
                                          DatabaseService().createOrder(
                                              userProfile.activeBusiness,
                                              year,
                                              month,
                                              selectedIvoiceDate,
                                              subTotal,
                                              discount,
                                              tax,
                                              total,
                                              snapshot.data['Items'],
                                              orderName,
                                              (saleStatus == 'Venta por cobrar')
                                                  ? 'Por Cobrar'
                                                  : 'Efectivo',
                                              clientName,
                                              {
                                                'Name': orderName,
                                                'Address': '',
                                                'Phone': 0,
                                                'email': '',
                                              },
                                              invoiceNo,
                                              '',
                                              false);

                                          /////Save Sales and Order Categories to database
                                          DatabaseService().saveOrderType(
                                              userProfile.activeBusiness,
                                              orderCategories);

                                          // /////////////////////////// MONTH STATS ///////////////////////////

                                          //Sales Count
                                          if (currentSalesCount == null ||
                                              currentSalesCount < 1) {
                                            newSalesCount = 1;
                                          } else {
                                            newSalesCount =
                                                currentSalesCount + 1;
                                          }

                                          //Set Categories Variables
                                          orderStats = {};

                                          //Items Sold
                                          if (currentTicketItemsCount == null ||
                                              currentTicketItemsCount < 1) {
                                            newTicketItemsCount =
                                                cartList.length;
                                          } else {
                                            newTicketItemsCount =
                                                currentTicketItemsCount +
                                                    cartList.length;
                                          }

                                          ////////////////////////////Add amounts by category/account

                                          //Logic to add up categories totals in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (salesCountbyCategory.containsKey(
                                                '${cartList[i]["Category"]}')) {
                                              //Add to existing category amount
                                              salesCountbyCategory.update(
                                                  '${cartList[i]["Category"]}',
                                                  (value) =>
                                                      value +
                                                      (cartList[i]["Price"] *
                                                          cartList[i]
                                                              ["Quantity"]));
                                            } else {
                                              //Add new category with amount
                                              salesCountbyCategory[
                                                      '${cartList[i]["Category"]}'] =
                                                  cartList[i]["Price"] *
                                                      cartList[i]["Quantity"];
                                            }
                                          }

                                          ////////////////////////////Add by item count

                                          //Logic to add up item count  in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (currentItemsCount.containsKey(
                                                '${cartList[i]["Name"]}')) {
                                              //Add to existing category amount
                                              currentItemsCount.update(
                                                  '${cartList[i]["Name"]}',
                                                  (value) =>
                                                      value +
                                                      cartList[i]["Quantity"]);
                                            } else {
                                              //Add new category with amount
                                              currentItemsCount[
                                                      '${cartList[i]["Name"]}'] =
                                                  cartList[i]["Quantity"];
                                            }
                                          }

                                          //Logic to add up item Amount  in current ticket
                                          for (var i = 0;
                                              i < cartList.length;
                                              i++) {
                                            //Check if the map contains the key
                                            if (currentItemsAmount.containsKey(
                                                '${cartList[i]["Name"]}')) {
                                              //Add to existing category amount
                                              currentItemsAmount.update(
                                                  '${cartList[i]["Name"]}',
                                                  (value) =>
                                                      value +
                                                      (cartList[i]["Price"] *
                                                          cartList[i]
                                                              ["Quantity"]));
                                            } else {
                                              //Add new category with amount
                                              currentItemsAmount[
                                                      '${cartList[i]["Name"]}'] =
                                                  (cartList[i]["Price"] *
                                                      cartList[i]["Quantity"]);
                                            }
                                          }

                                          //Logic to add up item sales by order type
                                          //Check if the map contains the key
                                          if (currentSalesbyOrderType
                                              .containsKey('Independiente')) {
                                            //Add to existing category amount
                                            currentSalesbyOrderType.update(
                                                'Independiente',
                                                (value) => value + total);
                                          } else {
                                            //Add new category with amount
                                            currentSalesbyOrderType[
                                                'Independiente'] = (total);
                                          }

                                          orderStats['Total Sales'] =
                                              newSalesAmount;
                                          orderStats['Total Sales Count'] =
                                              newSalesCount;
                                          orderStats['Total Items Sold'] =
                                              newTicketItemsCount;
                                          orderStats['Sales Count by Product'] =
                                              currentItemsCount;
                                          orderStats[
                                                  'Sales Amount by Product'] =
                                              currentItemsAmount;
                                          orderStats[
                                                  'Sales Count by Category'] =
                                              salesCountbyCategory;
                                          orderStats['Sales by Order Type'] =
                                              currentSalesbyOrderType;

                                          //Save Details to Firestore Historic
                                          DatabaseService().saveOrderStats(
                                              userProfile.activeBusiness,
                                              orderStats);

                                          /////////////////Clear Variables
                                          bloc.removeAllFromCart();
                                          _controllers = [];
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: Center(
                                            child: Text('Confirmar y volver'),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                        SizedBox(height: 50)
                      ],
                    ),
                  );
                });
          } else {
            return Container();
          }
        });
  }
}
