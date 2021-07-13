import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Expenses/ExpenseInput.dart';
import 'package:denario/Expenses/ExpenseList.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesDesk extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            //Expense Input
            MultiProvider(              
              providers: [
                StreamProvider<CategoryList>.value(value: DatabaseService().categoriesList),
                StreamProvider<AccountsList>.value(value: DatabaseService().accountsList)
              ],
              child: ExpenseInput()
            ),
            SizedBox(height: 30),
            //Expense List
             MultiProvider(              
              providers: [
                StreamProvider<List<Expenses>>.value(value: DatabaseService().expenseList()),
              ],
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //ExpenseList
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        //Title
                        Text('Gastos del mes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18
                          ),
                        ),
                        SizedBox(height: 15),
                        //Expenses List
                        ExpenseList()
                      ]),
                    SizedBox(height: 20),
                    //Graph
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        //Title
                        Text('Gastos del mes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18
                          ),
                        ),
                        SizedBox(height: 15),
                        //Expenses List
                        ExpenseList()
                      ]),
                ],),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
