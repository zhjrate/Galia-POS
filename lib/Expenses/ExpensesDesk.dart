import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Expenses/ExpenseInput.dart';
import 'package:denario/Expenses/ExpenseList.dart';
import 'package:denario/Expenses/ExpenseSummary.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            //Expense Input
            MultiProvider(providers: [
              StreamProvider<CategoryList>.value(
                  initialData: null, value: DatabaseService().categoriesList),
              StreamProvider<AccountsList>.value(
                  initialData: null, value: DatabaseService().accountsList)
            ], child: ExpenseInput()),
            SizedBox(height: 30),
            //Expense List
            MultiProvider(
              providers: [
                StreamProvider<List<Expenses>>.value(
                    initialData: null, value: DatabaseService().expenseList()),
              ],
              child: Container(
                  height:
                      (MediaQuery.of(context).size.width > 1100) ? 700 : 1000,
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
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
                  child: (MediaQuery.of(context).size.width > 1100)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //ExpenseList
                            Expanded(
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
                                    ExpenseList()
                                  ]),
                            ),
                            SizedBox(width: 20),
                            //Graph
                            Expanded(
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
                                    ExpenseSummary()
                                  ]),
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
                                    ExpenseList()
                                  ]),
                            ),
                            SizedBox(height: 20),
                            //Graph
                            Container(
                              height: 400,
                              width: double.infinity,
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
                                    ExpenseSummary()
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
