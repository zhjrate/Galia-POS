import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';

class NewSupplier extends StatefulWidget {
  final String activeBusiness;
  final CategoryList categories;
  final HighLevelMapping highLevelMapping;
  const NewSupplier(this.activeBusiness, this.categories, this.highLevelMapping,
      {Key key})
      : super(key: key);

  @override
  State<NewSupplier> createState() => _NewSupplierState();
}

class _NewSupplierState extends State<NewSupplier> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  int id = 0;
  String email = '';
  int phone = 0;
  String address = '';
  String description = '';
  String category = '';
  String account = '';
  List costTypeTags = [
    'Costo de Ventas',
    'Gastos de Empleados',
    'Gastos del Local',
    'Otros Gastos',
  ];
  List selectedTags = [];
  List dropdownAccounts = [];
  var costTypes = [];

  var random = new Random();

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  @override
  void initState() {
    category = widget.categories.categoryList.first;

    costTypes = widget.highLevelMapping.expenseGroups;
    var otherCost = costTypes.firstWhere((x) => x != 'Costo de Ventas');
    widget.highLevelMapping.pnlMapping[otherCost]
        .forEach((x) => dropdownAccounts.add(x));
    account = dropdownAccounts.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Title
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0),
                SizedBox(
                  width: 25,
                ),
                Text(
                  'Alta de proveedor',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          //Form
          Container(
            width: 750,
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Name && ID
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Nombre
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nombre*',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black45),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    cursorColor: Colors.grey,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Agrega un nombre";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
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
                                    onChanged: (value) {
                                      setState(() {
                                        name = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        //CUIT
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CUIT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black45),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      focusColor: Colors.black,
                                      hintStyle: TextStyle(
                                          color: Colors.black45, fontSize: 14),
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
                                    onChanged: (value) {
                                      setState(() {
                                        id = int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  //Mail && Phone
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Mail
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'email',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black45),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      focusColor: Colors.black,
                                      hintStyle: TextStyle(
                                          color: Colors.black45, fontSize: 14),
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
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        //Phone
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Número de celular',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black45),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(8),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 2, 10),
                                          child: Text(('(11) '))),
                                      focusColor: Colors.black,
                                      hintStyle: TextStyle(
                                          color: Colors.black45, fontSize: 14),
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
                                    onChanged: (value) {
                                      setState(() =>
                                          phone = int.parse('11' + value));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  //Direccion
                  Text(
                    'Dirección',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black45),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        hintStyle:
                            TextStyle(color: Colors.black45, fontSize: 14),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          borderSide: new BorderSide(
                            color: Colors.grey[350],
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                          borderSide: new BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          address = value;
                        });
                      },
                    ),
                  ),
                  //Cost Type Selection
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo de gastos asociados a este proveedor',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black45),
                      ),
                      SizedBox(width: 10),
                      Tooltip(
                        message: 'Servirá como atajo al registrar gastos',
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                      width: double.infinity,
                      child: Tags(
                          itemCount: costTypeTags.length,
                          itemBuilder: (int i) {
                            return ItemTags(
                                padding: EdgeInsets.all(12),
                                key: Key(i.toString()),
                                index: i,
                                title: costTypeTags[i],
                                textColor: Colors.white,
                                textActiveColor: Colors.black,
                                color: Colors.greenAccent[400],
                                activeColor: Colors.white,
                                onPressed: (item) {
                                  if (!item.active) {
                                    setState(() {
                                      selectedTags.add(item.title);
                                    });
                                  } else {
                                    setState(() {
                                      selectedTags.remove(item.title);
                                    });
                                  }

                                  if ((!selectedTags
                                              .contains('Costo de Ventas') &&
                                          selectedTags.length >= 1) ||
                                      (selectedTags
                                              .contains('Costo de Ventas') &&
                                          selectedTags.length > 1)) {
                                    setState(() {
                                      account = widget.highLevelMapping
                                          .pnlMapping[costTypeTags[i]][0];
                                      dropdownAccounts = [];
                                    });
                                    widget.highLevelMapping
                                        .pnlMapping[costTypeTags[i]]
                                        .forEach(
                                            (x) => dropdownAccounts.add(x));
                                  }
                                });
                          })),
                  //Predefined Category
                  (selectedTags.contains('Costo de Ventas'))
                      ? SizedBox(height: 25)
                      : SizedBox(),
                  (selectedTags.contains('Costo de Ventas'))
                      ? Container(
                          child: Row(
                            children: [
                              //Predefined Category
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Title
                                    Row(
                                      children: [
                                        Text(
                                          'Categoría predeterminada',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.black45),
                                        ),
                                        SizedBox(width: 10),
                                        Tooltip(
                                          message:
                                              'Se cargará de forma predeterminada al crear gastos con este proveedor',
                                          child: Icon(
                                            Icons.info_outline_rounded,
                                            size: 14,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    //Dropdown categories
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
                                            widget.categories.categoryList[0],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Colors.grey[700]),
                                          ),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.grey[700]),
                                          value: category,
                                          items: widget.categories.categoryList
                                              .map((x) {
                                            return new DropdownMenuItem(
                                              value: x,
                                              child: new Text(x),
                                              onTap: () {
                                                setState(() {
                                                  category = x;
                                                });
                                              },
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              category = newValue;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              //Predefined Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Descripción de gastos predeterminada',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black45),
                                    ),
                                    SizedBox(height: 10),
                                    //Description
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      cursorColor: Colors.grey,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: 'Insumos',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
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
                                      onChanged: (val) {
                                        setState(() => description = val);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  //Predefined Account and Description
                  ((selectedTags.contains('Costo de Ventas') &&
                              selectedTags.length > 1) ||
                          (!selectedTags.contains('Costo de Ventas') &&
                              selectedTags.length >= 1))
                      ? SizedBox(height: 25)
                      : SizedBox(),
                  ((selectedTags.contains('Costo de Ventas') &&
                              selectedTags.length > 1) ||
                          (!selectedTags.contains('Costo de Ventas') &&
                              selectedTags.length >= 1))
                      ? Container(
                          child: Row(
                            children: [
                              //Predefined Account
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Title
                                    Row(
                                      children: [
                                        Text(
                                          'Cuenta predeterminada',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.black45),
                                        ),
                                        SizedBox(width: 10),
                                        Tooltip(
                                          message:
                                              'Se cargará de forma predeterminada al crear gastos con este proveedor',
                                          child: Icon(
                                            Icons.info_outline_rounded,
                                            size: 14,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    //Dropdown categories
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
                                          hint: (dropdownAccounts.length > 0)
                                              ? Text(
                                                  dropdownAccounts
                                                      .first, //widget.categories.categoryList[0],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Colors.grey[700]),
                                                )
                                              : Text(''),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Colors.grey[700]),
                                          value: account,
                                          items: dropdownAccounts.map((x) {
                                            return new DropdownMenuItem(
                                              value: x,
                                              child: new Text(x),
                                              onTap: () {
                                                setState(() {
                                                  account = x;
                                                });
                                              },
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              account = newValue;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              //Predefined Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Descripción predeterminada',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black45),
                                    ),
                                    SizedBox(height: 10),
                                    //Description
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      cursorColor: Colors.grey,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: 'Gasto recurrente',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
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
                                      onChanged: (val) {
                                        setState(() => description = val);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  //Button
                  SizedBox(height: 35),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors.grey;
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed))
                              return Colors.grey.shade300;
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          int min =
                              10000; //min and max values act as your 6 digit range
                          int max = 99999;
                          var rNum = min + random.nextInt(max - min);

                          DatabaseService().createSupplier(
                              widget.activeBusiness,
                              name,
                              setSearchParam(name.toLowerCase()),
                              id,
                              email,
                              (phone == 0) ? 1100000000 : phone,
                              address,
                              category,
                              description,
                              account,
                              selectedTags,
                              rNum);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Center(
                          child: Text('Crear'),
                        ),
                      )),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      )),
    );
  }
}
