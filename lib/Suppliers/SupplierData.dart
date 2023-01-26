import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:denario/Models/Supplier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';

class SupplierData extends StatefulWidget {
  final String currentBusiness;
  final Supplier vendor;
  final CategoryList categories;
  final HighLevelMapping highLevelMapping;
  const SupplierData(
      this.currentBusiness, this.vendor, this.categories, this.highLevelMapping,
      {Key key})
      : super(key: key);

  @override
  State<SupplierData> createState() => _SupplierDataState();
}

class _SupplierDataState extends State<SupplierData> {
  bool edit = false;

  String name = '';
  int id = 0;
  String email = '';
  int phone = 0;
  String address = '';
  String description = '';
  String category = '';
  bool categoryEdited;
  List costTypes = [];
  List availableCostTypes = [
    'Costo de Ventas',
    'Gastos de Empleados',
    'Gastos del Local',
    'Otros Gastos',
  ];
  String account = '';
  List dropdownAccounts = [];

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
    if (widget.vendor.predefinedCategory == '' ||
        widget.vendor.predefinedCategory == null) {
      category = widget.categories.categoryList.first;
      categoryEdited = false;
    } else {
      category = widget.vendor.predefinedCategory;
      categoryEdited = false;
    }
    costTypes = widget.vendor.costTypeAssociated;
    if ((costTypes.contains('Costo de Ventas') && costTypes.length > 1) ||
        (!costTypes.contains('Costo de Ventas') && costTypes.length > 0)) {
      var otherCost = costTypes.firstWhere((x) => x != 'Costo de Ventas');

      widget.highLevelMapping.pnlMapping[otherCost]
          .forEach((x) => dropdownAccounts.add(x));
      account = dropdownAccounts.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Info
        Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              (edit)
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          edit = false;
                        });
                      },
                      child: Text(
                        'Dejar de editar',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ))
                  : Tooltip(
                      message: 'Editar datos',
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              edit = true;
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.black,
                          )),
                    )
            ],
          ),
        ),
        SizedBox(height: 20),
        //Nombre
        Text(
          'Nombre',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 45,
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 14),
            cursorColor: Colors.grey,
            enabled: (edit) ? true : false,
            key: Key(widget.vendor.name),
            initialValue: widget.vendor.name,
            decoration: InputDecoration(
              focusColor: Colors.black,
              hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
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
                name = value;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        //CUIT
        Text(
          'CUIT',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 45,
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 14),
            cursorColor: Colors.grey,
            enabled: (edit) ? true : false,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            key: Key(widget.vendor.id.toString()),
            initialValue: widget.vendor.id.toString(),
            decoration: InputDecoration(
              focusColor: Colors.black,
              hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
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
                id = int.parse(value);
              });
            },
          ),
        ),
        SizedBox(height: 20),
        //Mail
        Text(
          'email',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 45,
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 14),
            cursorColor: Colors.grey,
            enabled: (edit) ? true : false,
            key: Key(widget.vendor.email),
            initialValue: widget.vendor.email,
            decoration: InputDecoration(
              focusColor: Colors.black,
              hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
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
                email = value;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        //TLF
        Text(
          'Número de celular',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 14),
            cursorColor: Colors.grey,
            enabled: (edit) ? true : false,
            key: Key(widget.vendor.phone.toString()),
            initialValue: widget.vendor.phone.toString(),
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "El número debe tener 10 caracteres)";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              focusColor: Colors.black,
              hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
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
                setState(() => phone = int.parse('11' + value));
              });
            },
          ),
        ),
        SizedBox(height: 20),
        //Direccion
        Text(
          'Dirección',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black45),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 45,
          child: TextFormField(
            style: TextStyle(color: Colors.black, fontSize: 14),
            cursorColor: Colors.grey,
            enabled: (edit) ? true : false,
            initialValue: widget.vendor.address,
            key: Key(widget.vendor.address),
            decoration: InputDecoration(
              focusColor: Colors.black,
              hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
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
        //Tipos de costos asociados
        SizedBox(height: 20),
        (!edit)
            ? Row(
                children: [
                  Text(
                    'Tipos de costos asociados',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black45),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 35,
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.vendor.costTypeAssociated.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      widget.vendor.costTypeAssociated[i],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Text(
                    'Tipos de costos asociados',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black45),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      // height: 35,
                      width: double.infinity,
                      child: Tags(
                          itemCount: availableCostTypes.length,
                          itemBuilder: (int i) {
                            return ItemTags(
                                padding: EdgeInsets.all(12),
                                key: Key(i.toString()),
                                index: i,
                                active:
                                    (costTypes.contains(availableCostTypes[i]))
                                        ? true
                                        : false,
                                title: availableCostTypes[i],
                                textColor: Colors.black,
                                textActiveColor: Colors.black,
                                color: Colors.white,
                                activeColor: Colors.greenAccent,
                                onPressed: (item) {
                                  if (costTypes
                                      .contains(availableCostTypes[i])) {
                                    setState(() {
                                      costTypes.remove(availableCostTypes[i]);
                                    });
                                  } else {
                                    setState(() {
                                      costTypes.add(availableCostTypes[i]);

                                      dropdownAccounts = [];
                                      if ((costTypes.contains(
                                                  'Costo de Ventas') &&
                                              costTypes.length > 1) ||
                                          (!costTypes.contains(
                                                  'Costo de Ventas') &&
                                              costTypes.length >= 1)) {
                                        var otherCost = costTypes.firstWhere(
                                            (x) => x != 'Costo de Ventas');

                                        widget.highLevelMapping
                                            .pnlMapping[otherCost]
                                            .forEach(
                                                (x) => dropdownAccounts.add(x));
                                        account = dropdownAccounts.first;
                                      }
                                    });
                                  }
                                });
                          }),
                    ),
                  )
                ],
              ),
        SizedBox(height: 10),
        //Predefined Category and Description
        (edit && costTypes.contains('Costo de Ventas'))
            ? SizedBox(height: 25)
            : SizedBox(),
        (edit && costTypes.contains('Costo de Ventas'))
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Text(
                    'Categoría predeterminada',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black45),
                  ),
                  SizedBox(height: 10),
                  //Dropdown categories
                  Container(
                    decoration: (edit)
                        ? BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12.0),
                          )
                        : BoxDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: (edit) ? 12 : 0),
                    child: (edit)
                        ? DropdownButton(
                            isExpanded: true,
                            underline: SizedBox(),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.grey[700]),
                            value: category,
                            items: widget.categories.categoryList.map((x) {
                              return new DropdownMenuItem(
                                value: x,
                                child: new Text(x),
                                onTap: () {
                                  setState(() {
                                    category = x;
                                    categoryEdited = true;
                                  });
                                },
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                category = newValue;
                                categoryEdited = true;
                              });
                            },
                          )
                        : TextFormField(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            cursorColor: Colors.grey,
                            enabled: false,
                            key: Key(widget.vendor.predefinedCategory),
                            initialValue: widget.vendor.predefinedCategory,
                            decoration: InputDecoration(
                              focusColor: Colors.black,
                              hintStyle: TextStyle(
                                  color: Colors.black45, fontSize: 14),
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
                                name = value;
                              });
                            },
                          ),
                  ),
                ],
              )
            : SizedBox(),
        ((edit &&
                    costTypes.contains('Costo de Ventas') &&
                    costTypes.length > 1) ||
                (edit &&
                    !costTypes.contains('Costo de Ventas') &&
                    costTypes.length >= 1))
            ? SizedBox(height: 25)
            : SizedBox(),
        ((edit &&
                    costTypes.contains('Costo de Ventas') &&
                    costTypes.length > 1) ||
                (edit &&
                    !costTypes.contains('Costo de Ventas') &&
                    costTypes.length >= 1))
            ? Container(
                child: Row(
                  children: [
                    //Predefined Account
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Title
                          Text(
                            'Cuenta predeterminada',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.black45),
                          ),
                          SizedBox(height: 10),
                          //Dropdown Accounts
                          Container(
                            decoration: (edit)
                                ? BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12.0),
                                  )
                                : BoxDecoration(),
                            padding: EdgeInsets.symmetric(
                                horizontal: (edit) ? 12 : 0),
                            child: (edit)
                                ? DropdownButton(
                                    isExpanded: true,
                                    underline: SizedBox(),
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
                                  )
                                : TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    cursorColor: Colors.grey,
                                    enabled: false,
                                    key: Key(widget.vendor.predefinedAccount),
                                    initialValue:
                                        widget.vendor.predefinedAccount,
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
                                        name = value;
                                      });
                                    },
                                  ),
                          ),
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
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            cursorColor: Colors.grey,
                            textInputAction: TextInputAction.next,
                            enabled: (edit) ? true : false,
                            key: Key(widget.vendor.initialExpenseDescription),
                            initialValue:
                                widget.vendor.initialExpenseDescription,
                            decoration: InputDecoration(
                              hintText: 'Insumos',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
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
        (edit) ? SizedBox(height: 20) : SizedBox(),
        (edit)
            ? ElevatedButton(
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
                  DatabaseService().editSupplierData(
                      widget.currentBusiness,
                      widget.vendor.docID,
                      (name != '') ? name : widget.vendor.name,
                      (name != '')
                          ? setSearchParam(name.toLowerCase())
                          : setSearchParam(widget.vendor.name.toLowerCase()),
                      (id != 0) ? id : widget.vendor.id,
                      (email != '') ? email : widget.vendor.email,
                      (phone != 0) ? phone : widget.vendor.phone,
                      (address != '') ? address : widget.vendor.address,
                      costTypes,
                      (categoryEdited)
                          ? category
                          : widget.vendor.predefinedCategory,
                      (description != '')
                          ? description
                          : widget.vendor.initialExpenseDescription,
                      account);
                  setState(() {
                    edit = false;
                  });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Center(
                    child: Text('Guardar cambios'),
                  ),
                ))
            : Container()
      ],
    );
  }
}
