import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoreTicketPopUp extends StatefulWidget {
  final CategoryList categoriesProvider;

  MoreTicketPopUp({this.categoriesProvider});

  @override
  _MoreTicketPopUpState createState() => _MoreTicketPopUpState();
}

class _MoreTicketPopUpState extends State<MoreTicketPopUp> {
  var _discountTextController = TextEditingController();
  var _newItemdescriptionTextController = TextEditingController();
  var _newItemPriceTextController = TextEditingController();

  double discount = 0;
  double tax = 0;
  String newItemdescription = '';
  String newItemCategory = '';
  double newItemPrice = 0;
  FocusNode newItemdescriptionNode;
  FocusNode newItemPriceNode;
  int categoryInt = 0;
  String selectedCategory;
  List categoriesList;

  @override
  void initState() {
    categoriesList = widget.categoriesProvider.categoriesList;
    selectedCategory = categoriesList.last.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Center(
              child: Icon(
            Icons.more_horiz,
            color: Colors.black,
            size: 18,
          )),
        ),
        onSelected: (value) {
          switch (value) {
            case 0:
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        height: 250,
                        width: 250,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
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
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, right: 5),
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
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    cursorColor: Theme.of(context).accentColor,
                                    decoration: InputDecoration.collapsed(
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
                                          discount = double.tryParse(val);
                                          bloc.setDiscountAmount(discount);
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
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                      child: Text('Guardar',
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
              break;
            case 1:
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Container(
                        height: 200,
                        width: 250,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
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
                              SizedBox(
                                height: 10,
                              ),
                              //Text
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, right: 5),
                                child: Text(
                                  "Impuesto Aplicable",
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
                              //Buttons
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //0%
                                    Container(
                                      width: 100,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            tax = 0;
                                            bloc.setTaxAmount(tax);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                            child: Text('0%',
                                                style: TextStyle(
                                                    color: Colors.black))),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    //21%
                                    Container(
                                      width: 100,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        color: Colors.black,
                                        onPressed: () {
                                          setState(() {
                                            tax = 0.21;
                                            bloc.setTaxAmount(tax);
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                            child: Text('21%',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
              break;
            case 2:
              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Container(
                          width: 350,
                          constraints:
                              BoxConstraints(minHeight: 300, maxHeight: 400),
                          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
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
                              SizedBox(
                                height: 10,
                              ),
                              //Text
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, right: 5),
                                child: Text(
                                  "Agregar Item",
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
                              //Product Text
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Text
                                      Text(
                                        "Descripción:",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      //Form
                                      Container(
                                        width: 70,
                                        child: Center(
                                          child: TextFormField(
                                            autofocus: true,
                                            focusNode: newItemdescriptionNode,
                                            controller:
                                                _newItemdescriptionTextController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.right,
                                            cursorColor: Colors.black,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: 'Item',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                            onFieldSubmitted: (x) {
                                              newItemPriceNode.nextFocus();
                                            },
                                            onChanged: (val) {
                                              setState(() {
                                                newItemdescription = val;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              //Category
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Text
                                      Text(
                                        "Categoría:",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      //Category
                                      DropdownButton(
                                        hint: Text(
                                          selectedCategory,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: Colors.grey[700]),
                                        ),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.grey[700]),
                                        value: selectedCategory,
                                        items: categoriesList.map((x) {
                                          return new DropdownMenuItem(
                                            value: x.category,
                                            child: new Text(x.category),
                                          );
                                        }).toList(),
                                        onChanged: (x) {
                                          setState(() {
                                            selectedCategory = x;
                                          });
                                        },
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              //Price
                              Container(
                                width: double.infinity,
                                height: 50,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Text
                                      Text(
                                        "Precio:",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(),
                                      //Amount
                                      Container(
                                        width: 70,
                                        child: Center(
                                          child: TextFormField(
                                            focusNode: newItemPriceNode,
                                            controller:
                                                _newItemPriceTextController,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.right,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.black,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: '\$0',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                            onChanged: (val) {
                                              setState(() {
                                                newItemPrice =
                                                    double.parse(val);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              //Button
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: Colors.black,
                                  onPressed: () {
                                    bloc.addToCart({
                                      'Name': newItemdescription,
                                      'Category': newItemCategory,
                                      'Price': newItemPrice,
                                      'Quantity': 1,
                                      'Total Price': newItemPrice
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                      child: Text('Guardar',
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  });
              break;
          }
        },
        itemBuilder: (context) => [
              //Discount
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(width: 10),
                    Text("Descuento")
                  ],
                ),
              ),
              //Tax
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.splitscreen,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(width: 10),
                    Text("Impuesto")
                  ],
                ),
              ),
              //Custom item
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(width: 10),
                    Text("Agregar item")
                  ],
                ),
              ),
            ]);
  }
}
