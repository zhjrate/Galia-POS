import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/POS/DiscountDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoreTicketPopUp extends StatefulWidget {
  final CategoryList categoriesProvider;

  MoreTicketPopUp({this.categoriesProvider});

  @override
  _MoreTicketPopUpState createState() => _MoreTicketPopUpState();
}

class _MoreTicketPopUpState extends State<MoreTicketPopUp> {
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
  bool fixedDiscount;

  @override
  void initState() {
    categoriesList = widget.categoriesProvider.categoryList;
    selectedCategory = categoriesList.first;
    fixedDiscount = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        tooltip: 'Mostrar opciones',
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
                    return DiscountDialog();
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
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
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
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
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
                      return SingleChildScrollView(
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Container(
                            width: 350,
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 25),
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
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 5),
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
                                Row(
                                  children: [
                                    Text(
                                      "Descripción:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      cursorColor: Colors.grey,
                                      focusNode: newItemdescriptionNode,
                                      controller:
                                          _newItemdescriptionTextController,
                                      decoration: InputDecoration(
                                        hintText: 'Item',
                                        focusColor: Colors.black,
                                        hintStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14),
                                        errorStyle: TextStyle(
                                            color: Colors.redAccent[700],
                                            fontSize: 12),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(12.0),
                                          borderSide: new BorderSide(
                                            color: Colors.grey[350],
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
                                      onFieldSubmitted: (x) {
                                        newItemPriceNode.nextFocus();
                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          newItemdescription = val;
                                        });
                                      },
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                //Category
                                Row(
                                  children: [
                                    Text(
                                      'Categoría',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      hint: Text(
                                        selectedCategory,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                      ),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.grey[700]),
                                      value: selectedCategory,
                                      items: categoriesList.map((x) {
                                        return new DropdownMenuItem(
                                          value: x,
                                          child: new Text(x),
                                        );
                                      }).toList(),
                                      onChanged: (x) {
                                        setState(() {
                                          selectedCategory = x;
                                        });
                                      },
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                //Price
                                Row(
                                  children: [
                                    Text(
                                      'Precio',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black45),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    cursorColor: Colors.grey,
                                    focusNode: newItemPriceNode,
                                    controller: _newItemPriceTextController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                                      TextInputFormatter.withFunction(
                                        (oldValue, newValue) =>
                                            newValue.copyWith(
                                          text: newValue.text
                                              .replaceAll(',', '.'),
                                        ),
                                      ),
                                    ],
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Agrega un precio";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      prefixIcon: Icon(
                                        Icons.attach_money,
                                        color: Colors.grey,
                                      ),
                                      focusColor: Colors.black,
                                      hintStyle: TextStyle(
                                          color: Colors.black45, fontSize: 14),
                                      errorStyle: TextStyle(
                                          color: Colors.redAccent[700],
                                          fontSize: 12),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0),
                                        borderSide: new BorderSide(
                                          color: Colors.grey[350],
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
                                    onChanged: (val) {
                                      setState(() {
                                        newItemPrice = double.parse(val);
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                //Button
                                Container(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                    ),
                                    onPressed: () {
                                      bloc.addToCart({
                                        'Name': newItemdescription,
                                        'Category': selectedCategory,
                                        'Price': newItemPrice,
                                        'Quantity': 1,
                                        'Total Price': newItemPrice,
                                        'Options': []
                                      });

                                      setState(() {
                                        _newItemdescriptionTextController
                                            .clear();
                                        _newItemPriceTextController.clear();
                                        _newItemPriceTextController.clear();

                                        newItemdescription = '';
                                        newItemPrice = 0;
                                      });
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
