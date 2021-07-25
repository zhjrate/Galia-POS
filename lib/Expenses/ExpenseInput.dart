import 'package:denario/Expenses/RegisterExpenseDialog.dart';
import 'package:denario/Models/Categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseInput extends StatefulWidget {
  @override
  _ExpenseInputState createState() => _ExpenseInputState();
}

class _ExpenseInputState extends State<ExpenseInput> {
  final dateFormat = new DateFormat('dd/MMMM');

  int qty = 1;
  double price = 100;
  String costType = '';

  Widget costSelection(
      String type, IconData icon, Color color, String category, String vendor) {
    return InkWell(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          costType = type;
          selectedCategory = category;
          selectedVendor = vendor;
        });
      },
      child: Column(children: [
        //Circle
        Container(
            width: 75,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[200],
                  offset: new Offset(5.0, 5.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Center(child: Icon(icon, color: color, size: 35))),
        SizedBox(height: 15),
        //Name
        Text(type, style: TextStyle(fontSize: 14, color: Colors.grey[700]))
      ]),
    );
  }

  //Form variables
  String selectedCategory = 'Café';
  int categoryInt = 0;
  String selectedAccount = '';
  String selectedVendor = 'Caxambú';
  List<String> categoryList = [];
  List<String> categoriesVendors = [];
  String expenseDescription = '';

  String costAccount = '';
  int accountInt = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryList>(context);
    final accountsProvider = Provider.of<AccountsList>(context);

    if (categoriesProvider == null || accountsProvider == null) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        costSelection('', Icons.circle, Colors.grey[200], '', ''),
        SizedBox(width: 35),
        costSelection('', Icons.circle, Colors.grey[200], '', ''),
        SizedBox(width: 35),
        costSelection('', Icons.circle, Colors.grey[200], '', ''),
        SizedBox(width: 35),
        costSelection('', Icons.circle, Colors.grey[200], '', ''),
      ]);
    } else if (costType == '') {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        costSelection('Costo de Ventas', Icons.attach_money, Colors.red, 'Café',
            'Caxambú'),
        SizedBox(width: 35),
        costSelection('Gastos del Local', Icons.store, Colors.blue,
            'Alquiler del Local', 'Locador'),
        SizedBox(width: 35),
        costSelection('Gastos de Empleados', Icons.people, Colors.green,
            'Alimentación y Entretenimiento', 'Mercado'),
        SizedBox(width: 35),
        costSelection('Otros Gastos', Icons.account_balance_wallet,
            Colors.purple, 'Servicios Profesionales', 'Contador'),
      ]);
    } else if (costType == 'Costo de Ventas') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Back
            InkWell(
              onTap: () {
                setState(() {
                  costType = '';
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios,
                      color: Colors.black, size: 18)),
            ),
            //Category
            Column(
              children: [
                Text(
                  'Category',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
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
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedCategory,
                  items: categoriesProvider.categoriesList.map((x) {
                    return new DropdownMenuItem(
                      value: x.category,
                      child: new Text(x.category),
                      onTap: () {
                        setState(() {
                          categoryInt =
                              categoriesProvider.categoriesList.indexOf(x);
                          selectedVendor = x.vendors[0];
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ],
            ),
            //Vendor
            Column(
              children: [
                Text(
                  'Vendedor',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                DropdownButton(
                  hint: Text(
                    selectedVendor,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.grey[700]),
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedVendor,
                  items: categoriesProvider.categoriesList[categoryInt].vendors
                      .map((i) {
                    return new DropdownMenuItem(
                      value: i,
                      child: new Text(i),
                    );
                  }).toList(),
                  onChanged: (x) {
                    setState(() {
                      selectedVendor = x;
                    });
                  },
                ),
              ],
            ),
            //Description
            Column(
              children: [
                Text(
                  'Descripción',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 175,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      // validator: (val) => val.isEmpty
                      //     ? "No olvides agregar una descripción"
                      //     : null,
                      inputFormatters: [LengthLimitingTextInputFormatter(25)],
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "Gasto",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => expenseDescription = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Qty
            Column(
              children: [
                Text(
                  'Cantidad',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 40,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "1",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => qty = int.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Price
            Column(
              children: [
                Text(
                  'Precio',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 70,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[0-9]+[.]?[0-9]*"))
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "100",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => price = double.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Total
            Column(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      '${NumberFormat.simpleCurrency().format(qty * price)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            //Payment Method
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return RegisterExpenseDialog(
                        costType,
                        selectedVendor,
                        'Costo de Ventas',
                        'Costos de $selectedCategory',
                        expenseDescription,
                        qty,
                        price,
                        qty * price,
                      );
                    });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_circle_outline,
                      color: Colors.black, size: 50)),
            ),
          ],
        ),
      );
    } else if (costType == 'Gastos de Empleados') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Back
            InkWell(
              onTap: () {
                setState(() {
                  costType = '';
                  expenseDescription = '';
                  qty = 1;
                  price = 100;
                  selectedCategory = 'Café';
                  categoryInt = 0;
                  accountInt = 0;
                  selectedAccount = '';
                  selectedVendor = 'Caxambú';
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios,
                      color: Colors.black, size: 18)),
            ),
            //Account
            Column(
              children: [
                Text(
                  'Cuenta',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
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
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedCategory,
                  items: accountsProvider.gastosdeEmpleados.map((x) {
                    return new DropdownMenuItem(
                      value: x.category,
                      child: new Text(x.category),
                      onTap: () {
                        setState(() {
                          categoryInt =
                              accountsProvider.gastosdeEmpleados.indexOf(x);
                          selectedVendor = x.vendors[0];
                          expenseDescription = x.productDescription;
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ],
            ),
            //Vendor
            Column(
              children: [
                Text(
                  'Vendedor',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                DropdownButton(
                  hint: Text(
                    selectedVendor,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.grey[700]),
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedVendor,
                  items: accountsProvider.gastosdeEmpleados[categoryInt].vendors
                      .map((i) {
                    return new DropdownMenuItem(
                      value: i,
                      child: new Text(i),
                    );
                  }).toList(),
                  onChanged: (x) {
                    setState(() {
                      selectedVendor = x;
                    });
                  },
                ),
              ],
            ),
            //Description
            Column(
              children: [
                Text(
                  'Descripción',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 175,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) => val.isEmpty
                          ? "No olvides agregar una descripción"
                          : null,
                      inputFormatters: [LengthLimitingTextInputFormatter(25)],
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: expenseDescription,
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => expenseDescription = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Qty
            Column(
              children: [
                Text(
                  'Cantidad',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 40,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "1",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => qty = int.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Price
            Column(
              children: [
                Text(
                  'Precio',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 70,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[0-9]+[.]?[0-9]*"))
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "100",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => price = double.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Total
            Column(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      '${NumberFormat.simpleCurrency().format(qty * price)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            //Payment Method
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return RegisterExpenseDialog(
                        costType,
                        selectedVendor,
                        selectedAccount,
                        selectedCategory,
                        expenseDescription,
                        qty,
                        price,
                        qty * price,
                      );
                    });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_circle_outline,
                      color: Colors.black, size: 50)),
            ),
          ],
        ),
      );
    } else if (costType == 'Gastos del Local') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Back
            InkWell(
              onTap: () {
                setState(() {
                  costType = '';
                  expenseDescription = '';
                  qty = 1;
                  price = 100;
                  selectedCategory = 'Café';
                  categoryInt = 0;
                  accountInt = 0;
                  selectedAccount = '';
                  selectedVendor = 'Caxambú';
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios,
                      color: Colors.black, size: 18)),
            ),
            //Account
            Column(
              children: [
                Text(
                  'Cuenta',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
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
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedCategory,
                  items: accountsProvider.gastosdelLocal.map((x) {
                    return new DropdownMenuItem(
                      value: x.category,
                      child: new Text(x.category),
                      onTap: () {
                        setState(() {
                          categoryInt =
                              accountsProvider.gastosdelLocal.indexOf(x);
                          selectedVendor = x.vendors[0];
                          expenseDescription = x.productDescription;
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ],
            ),
            //Vendor
            Column(
              children: [
                Text(
                  'Vendedor',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                DropdownButton(
                  hint: Text(
                    selectedVendor,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.grey[700]),
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedVendor,
                  items: accountsProvider.gastosdelLocal[categoryInt].vendors
                      .map((i) {
                    return new DropdownMenuItem(
                      value: i,
                      child: new Text(i),
                    );
                  }).toList(),
                  onChanged: (x) {
                    setState(() {
                      selectedVendor = x;
                    });
                  },
                ),
              ],
            ),
            //Description
            Column(
              children: [
                Text(
                  'Descripción',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 175,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) => val.isEmpty
                          ? "No olvides agregar una descripción"
                          : null,
                      inputFormatters: [LengthLimitingTextInputFormatter(25)],
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: expenseDescription,
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => expenseDescription = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Qty
            Column(
              children: [
                Text(
                  'Cantidad',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 40,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "1",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => qty = int.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Price
            Column(
              children: [
                Text(
                  'Precio',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 70,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[0-9]+[.]?[0-9]*"))
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "100",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => price = double.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Total
            Column(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      '${NumberFormat.simpleCurrency().format(qty * price)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            //Payment Method
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return RegisterExpenseDialog(
                        costType,
                        selectedVendor,
                        selectedAccount,
                        selectedCategory,
                        expenseDescription,
                        qty,
                        price,
                        qty * price,
                      );
                    });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_circle_outline,
                      color: Colors.black, size: 50)),
            ),
          ],
        ),
      );
    } else if (costType == 'Otros Gastos') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Back
            InkWell(
              onTap: () {
                setState(() {
                  costType = '';
                  expenseDescription = '';
                  qty = 1;
                  price = 100;
                  selectedCategory = 'Café';
                  categoryInt = 0;
                  accountInt = 0;
                  selectedAccount = '';
                  selectedVendor = 'Caxambú';
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios,
                      color: Colors.black, size: 18)),
            ),
            //Account
            Column(
              children: [
                Text(
                  'Cuenta',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
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
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedCategory,
                  items: accountsProvider.otrosGastos.map((x) {
                    return new DropdownMenuItem(
                      value: x.category,
                      child: new Text(x.category),
                      onTap: () {
                        setState(() {
                          categoryInt = accountsProvider.otrosGastos.indexOf(x);
                          selectedVendor = x.vendors[0];
                          expenseDescription = x.productDescription;
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ],
            ),
            //Vendor
            Column(
              children: [
                Text(
                  'Vendedor',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                DropdownButton(
                  hint: Text(
                    selectedVendor,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.grey[700]),
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedVendor,
                  items: accountsProvider.otrosGastos[categoryInt].vendors
                      .map((i) {
                    return new DropdownMenuItem(
                      value: i,
                      child: new Text(i),
                    );
                  }).toList(),
                  onChanged: (x) {
                    setState(() {
                      selectedVendor = x;
                    });
                  },
                ),
              ],
            ),
            //Description
            Column(
              children: [
                Text(
                  'Descripción',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 175,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) => val.isEmpty
                          ? "No olvides agregar una descripción"
                          : null,
                      inputFormatters: [LengthLimitingTextInputFormatter(25)],
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: expenseDescription,
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => expenseDescription = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Qty
            Column(
              children: [
                Text(
                  'Cantidad',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 40,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "1",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => qty = int.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Price
            Column(
              children: [
                Text(
                  'Precio',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 70,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[0-9]+[.]?[0-9]*"))
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "100",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => price = double.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Total
            Column(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      '${NumberFormat.simpleCurrency().format(qty * price)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            //Payment Method
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return RegisterExpenseDialog(
                        costType,
                        selectedVendor,
                        selectedAccount,
                        selectedCategory,
                        expenseDescription,
                        qty,
                        price,
                        qty * price,
                      );
                    });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_circle_outline,
                      color: Colors.black, size: 50)),
            ),
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Back
            InkWell(
              onTap: () {
                setState(() {
                  costType = '';
                  expenseDescription = '';
                  qty = 1;
                  price = 100;
                  selectedCategory = 'Café';
                  categoryInt = 0;
                  accountInt = 0;
                  selectedAccount = '';
                  selectedVendor = 'Caxambú';
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios,
                      color: Colors.black, size: 18)),
            ),
            //Account
            Column(
              children: [
                Text(
                  'Cuenta',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
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
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedCategory,
                  items: accountsProvider.otrosGastos.map((x) {
                    return new DropdownMenuItem(
                      value: x.category,
                      child: new Text(x.category),
                      onTap: () {
                        setState(() {
                          categoryInt = accountsProvider.otrosGastos.indexOf(x);
                          selectedVendor = x.vendors[0];
                          expenseDescription = x.productDescription;
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
              ],
            ),
            //Vendor
            Column(
              children: [
                Text(
                  'Vendedor',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                DropdownButton(
                  hint: Text(
                    selectedVendor,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Colors.grey[700]),
                  ),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.grey[700]),
                  value: selectedVendor,
                  items: accountsProvider.otrosGastos[categoryInt].vendors
                      .map((i) {
                    return new DropdownMenuItem(
                      value: i,
                      child: new Text(i),
                    );
                  }).toList(),
                  onChanged: (x) {
                    setState(() {
                      selectedVendor = x;
                    });
                  },
                ),
              ],
            ),
            //Description
            Column(
              children: [
                Text(
                  'Descripción',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 175,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) => val.isEmpty
                          ? "No olvides agregar una descripción"
                          : null,
                      inputFormatters: [LengthLimitingTextInputFormatter(25)],
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: expenseDescription,
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => expenseDescription = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Qty
            Column(
              children: [
                Text(
                  'Cantidad',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 40,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "1",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => qty = int.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Price
            Column(
              children: [
                Text(
                  'Precio',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  width: 40,
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                      validator: (val) =>
                          val.contains(',') ? "Usa punto" : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r"[0-9]+[.]?[0-9]*"))
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration.collapsed(
                        hintText: "100",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => price = double.parse(val));
                      },
                    ),
                  ),
                ),
              ],
            ),
            //Total
            Column(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[400]),
                ),
                SizedBox(height: 15),
                Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      '${NumberFormat.simpleCurrency().format(qty * price)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            //Payment Method
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return RegisterExpenseDialog(
                        costType,
                        selectedVendor,
                        selectedAccount,
                        selectedCategory,
                        expenseDescription,
                        qty,
                        price,
                        qty * price,
                      );
                    });
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_circle_outline,
                      color: Colors.black, size: 50)),
            ),
          ],
        ),
      );
    }
  }
}
