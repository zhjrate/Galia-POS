import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Expenses/ExpenseInput.dart';
import 'package:denario/Expenses/ExpenseList.dart';
import 'package:denario/Expenses/ExpenseSummary.dart';
import 'package:denario/Expenses/ExpensesHistory.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:denario/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpensesDesk extends StatefulWidget {
  final String rol;
  ExpensesDesk(this.rol);
  @override
  State<ExpensesDesk> createState() => _ExpensesDeskState();
}

class _ExpensesDeskState extends State<ExpensesDesk> {
  DateTime selectedIvoiceDate;

  void resetDate() {
    setState(() {
      selectedIvoiceDate = DateTime.now();
    });
  }

  @override
  void initState() {
    selectedIvoiceDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserData>(context);
    final categoriesProvider = Provider.of<CategoryList>(context);
    final highlevelMapping = Provider.of<HighLevelMapping>(context);

    if (categoriesProvider == null || highlevelMapping == null) {
      return Container();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Fecha
                  Text(
                    'Registrar gasto',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                    width: 175,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(selectedIvoiceDate),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        Spacer(),
                        Container(
                          height: 20,
                          width: 20,
                          child: IconButton(
                            splashRadius: 1,
                            onPressed: () async {
                              DateTime pickedDate = await showDatePicker(
                                  context: context,
                                  helpText: 'Fecha del gasto',
                                  confirmText: 'Guardar',
                                  cancelText: 'Cancelar',
                                  initialDate: DateTime.now(),
                                  firstDate: (widget.rol == 'Dueñ@')
                                      ? DateTime.now()
                                          .subtract(Duration(days: 60))
                                      : DateTime(DateTime.now().year,
                                          DateTime.now().month, 1),
                                  lastDate: DateTime.now(),
                                  builder: ((context, child) {
                                    return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: Colors
                                                .black, // header background color
                                            onPrimary: Colors
                                                .white, // header text color
                                            onSurface:
                                                Colors.black, // body text color
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors
                                                  .black, // button text color
                                            ),
                                          ),
                                        ),
                                        child: child);
                                  }));
                              setState(() {
                                if (pickedDate != null) {
                                  selectedIvoiceDate = pickedDate;
                                }
                              });
                            },
                            padding: EdgeInsets.all(0),
                            tooltip: 'Seleccionar fecha del gasto',
                            iconSize: 18,
                            icon: Icon(Icons.calendar_month),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //Expense Input
            MultiProvider(
                providers: [
                  StreamProvider<CategoryList>.value(
                      initialData: null,
                      value: DatabaseService()
                          .categoriesList(userProfile.activeBusiness)),
                  StreamProvider<AccountsList>.value(
                      initialData: null,
                      value: DatabaseService()
                          .accountsList(userProfile.activeBusiness))
                ],
                child: ExpenseInput(
                    userProfile.activeBusiness,
                    selectedIvoiceDate,
                    resetDate,
                    categoriesProvider,
                    highlevelMapping)),
            SizedBox(height: 30),
            //Expense List
            MultiProvider(
              providers: [
                StreamProvider<List<Expenses>>.value(
                    initialData: null,
                    value: DatabaseService().expenseList(
                        userProfile.activeBusiness,
                        DateTime.now().month.toString(),
                        DateTime.now().year.toString())),
                StreamProvider<CashRegister>.value(
                    initialData: null,
                    value: DatabaseService()
                        .cashRegisterStatus(userProfile.activeBusiness)),
              ],
              child: Container(
                  height:
                      (MediaQuery.of(context).size.width > 1100) ? 500 : 1000,
                  width: double.infinity,
                  child: (MediaQuery.of(context).size.width > 1100)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //ExpenseList
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(12.0),
                                  boxShadow: <BoxShadow>[
                                    new BoxShadow(
                                      color: Colors.grey[350],
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                    )
                                  ],
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Title
                                      Row(children: [
                                        Text(
                                          'Gastos del mes',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            tooltip: 'Ver todos los gastos',
                                            iconSize: 16,
                                            splashRadius: 0.2,
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExpensesHistory(userProfile
                                                            .activeBusiness))),
                                            icon: Icon(
                                              Icons.list,
                                              color: Colors.black,
                                              size: 24,
                                            ))
                                      ]),
                                      SizedBox(height: 15),
                                      //Expenses List
                                      Expanded(
                                          child: ExpenseList(
                                              userProfile.activeBusiness))
                                    ]),
                              ),
                            ),
                            SizedBox(width: 20),
                            //Graph
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(12.0),
                                  boxShadow: <BoxShadow>[
                                    new BoxShadow(
                                      color: Colors.grey[350],
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 10.0,
                                    )
                                  ],
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //Title
                                      Text(
                                        'Resumen de Gastos',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 15),
                                      //Expenses List
                                      ExpenseSummary(userProfile.activeBusiness)
                                    ]),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //ExpenseList
                            Container(
                              height: 500,
                              width: double.infinity,
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(12.0),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.grey[350],
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                  )
                                ],
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Title
                                    Text(
                                      'Gastos del mes',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(height: 15),
                                    //Expenses List
                                    ExpenseList(userProfile.activeBusiness)
                                  ]),
                            ),
                            SizedBox(height: 20),
                            //Graph
                            Container(
                              height: 400,
                              width: double.infinity,
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(12.0),
                                boxShadow: <BoxShadow>[
                                  new BoxShadow(
                                    color: Colors.grey[350],
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 10.0,
                                  )
                                ],
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Title
                                    Text(
                                      'Resumen de Gastos',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(height: 15),
                                    //Expenses List
                                    ExpenseSummary(userProfile.activeBusiness)
                                  ]),
                            ),
                          ],
                        )),
            ),
          ]),
        ),
      ),
    );
  }
}
