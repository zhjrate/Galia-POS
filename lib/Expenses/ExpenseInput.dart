import 'package:denario/Expenses/RegisterExpenseDialog.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Mapping.dart';
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
  double price = 0;
  String costType = '';

  Widget costSelection(
    String type,
    IconData icon,
    Color color,
    String category,
    String vendor,
    String description,
    AccountsList accountsProvider,
  ) {
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
          expenseHintDescription = description;
        });

        accountsProvider.accountsMapping[costType]
            .forEach((x) => dropdownCategories.add(x['Category']));

        accountsProvider.accountsMapping[costType][categoryInt]['Vendors']
            .forEach((y) => dropdownVendors.add(y));
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

  Widget showRegisterExpenseDalog(
      CashRegister registerStatus, DailyTransactions dailyTransactions) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return RegisterExpenseDialog(
                  costType,
                  selectedVendor,
                  selectedAccount,
                  (costType == 'Costo de Ventas')
                      ? 'Costos de $selectedCategory'
                      : selectedCategory,
                  expenseDescription,
                  qty,
                  price,
                  qty * price,
                  registerStatus,
                  dailyTransactions,
                  clearVariables);
            });
      },
      child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_circle_outline, color: Colors.black, size: 50)),
    );
  }

  //Form variables
  String selectedCategory = '';
  int categoryInt = 0;
  String selectedAccount = '';
  String selectedVendor = '';
  List<String> categoryList = [];
  List<String> categoriesVendors = [];
  String expenseDescription = '';
  String expenseHintDescription = '';

  String costAccount = '';
  int accountInt = 0;
  List dropdownCategories = [];
  List dropdownVendors = [];

  void clearVariables() {
    setState(() {
      costType = '';
      selectedCategory = 'Café';
      categoryInt = 0;
      selectedAccount = '';
      selectedVendor = 'Caxambú';
      categoryList = [];
      categoriesVendors = [];
      expenseDescription = '';

      costAccount = '';
      accountInt = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final highLevelMapping = Provider.of<HighLevelMapping>(context);
    final categoriesProvider = Provider.of<CategoryList>(context);
    final accountsProvider = Provider.of<AccountsList>(context);
    final registerStatus = Provider.of<CashRegister>(context);
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    if (highLevelMapping == null ||
        registerStatus == null ||
        dailyTransactions == null) {
      return Container();
    }

    if (categoriesProvider == null || accountsProvider == null) {
      return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        costSelection(
            '', Icons.circle, Colors.grey[200], '', '', '', accountsProvider),
        SizedBox(width: 35),
        costSelection(
            '', Icons.circle, Colors.grey[200], '', '', '', accountsProvider),
        SizedBox(width: 35),
        costSelection(
            '', Icons.circle, Colors.grey[200], '', '', '', accountsProvider),
        SizedBox(width: 35),
        costSelection(
            '', Icons.circle, Colors.grey[200], '', '', '', accountsProvider),
      ]);
    } else if (costType == '') {
      return Container(
        height: 120,
        width: double.infinity,
        child: Center(
          child: ListView.builder(
              itemCount: highLevelMapping.expenseGroups.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                IconData iconSelected;
                Color colorSelected;

                if (highLevelMapping.expenseGroups[i] == 'Costo de Ventas') {
                  iconSelected = Icons.attach_money;
                  colorSelected = Colors.red;
                } else if (highLevelMapping.expenseGroups[i] ==
                    'Gastos del Local') {
                  iconSelected = Icons.store;
                  colorSelected = Colors.blue;
                } else if (highLevelMapping.expenseGroups[i] ==
                    'Gastos de Empleados') {
                  iconSelected = Icons.people;
                  colorSelected = Colors.green;
                } else if (highLevelMapping.expenseGroups[i] ==
                    'Gastos de Empleados') {
                  iconSelected = Icons.people;
                  colorSelected = Colors.green;
                } else {
                  iconSelected = Icons.account_balance_wallet;
                  colorSelected = Colors.purple;
                }

                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: costSelection(
                        highLevelMapping.expenseGroups[i],
                        iconSelected,
                        colorSelected,
                        highLevelMapping.expenseInputMapping[
                            highLevelMapping.expenseGroups[i]]['Category'],
                        highLevelMapping.expenseInputMapping[
                            highLevelMapping.expenseGroups[i]]['Vendor'],
                        highLevelMapping.expenseInputMapping[
                            highLevelMapping.expenseGroups[i]]['Description'],
                        accountsProvider));
              }),
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
                  price = 0;
                  selectedCategory = '';
                  categoryInt = 0;
                  accountInt = 0;
                  selectedAccount = '';
                  selectedVendor = '';
                  dropdownCategories = [];
                  dropdownVendors = [];
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
                  (costType == 'Costo de Ventas') ? 'Categoría' : 'Cuenta',
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
                  items: dropdownCategories.map((x) {
                    return new DropdownMenuItem(
                      value: x,
                      child: new Text(x),
                      onTap: () {
                        setState(() {
                          categoryInt = dropdownCategories.indexOf(x);
                          selectedCategory = dropdownCategories[categoryInt];

                          dropdownVendors = accountsProvider
                              .accountsMapping[costType][categoryInt]['Vendors']
                              .toList();

                          selectedVendor = dropdownVendors[0];
                          expenseHintDescription =
                              accountsProvider.accountsMapping[costType]
                                  [categoryInt]['Description'];
                          expenseDescription =
                              accountsProvider.accountsMapping[costType]
                                  [categoryInt]['Description'];
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
                  items: dropdownVendors.map((i) {
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
                        hintText: expenseHintDescription,
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
                        hintText: "0",
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
            showRegisterExpenseDalog(registerStatus, dailyTransactions)
          ],
        ),
      );
    }
  }
}
