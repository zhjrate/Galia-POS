import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Expenses/FilteredExpenseList.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpensesHistory extends StatefulWidget {
  @override
  _ExpensesHistoryState createState() => _ExpensesHistoryState();
}

class _ExpensesHistoryState extends State<ExpensesHistory> {
  int month;
  int year;

  @override
  void initState() {
    month = DateTime.now().month;
    year = DateTime.now().year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Go Back /// Title
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              //Back
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.keyboard_arrow_left_outlined)),
              Spacer(),
              Text('Historial de Gastos'),
              Spacer()
            ]),
          ),
          SizedBox(height: 10),
          //Filters
          Container(
            height: 50,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[200],
                  offset: new Offset(15.0, 15.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Fecha
                  PopupMenuButton<int>(
                      child: Container(
                        child: Row(children: [
                          //Icon
                          Icon(Icons.calendar_today, size: 14),
                          SizedBox(width: 5),
                          //Text
                          Text(
                            'Fecha', //product[index].product,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 5),
                          //Icon
                          Icon(Icons.keyboard_arrow_down, size: 14),
                        ]),
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            setState(() {
                              month = DateTime.now().month;
                              year = DateTime.now().year;
                            });
                            break;
                          case 1:
                            setState(() {
                              month = DateTime(DateTime.now().year,
                                      DateTime.now().month - 1, 1)
                                  .month;
                              year = DateTime(DateTime.now().year,
                                      DateTime.now().month - 1, 1)
                                  .year;
                            });
                            break;
                          case 2:
                            setState(() {
                              month = DateTime(DateTime.now().year,
                                      DateTime.now().month - 2, 1)
                                  .month;
                              year = DateTime(DateTime.now().year,
                                      DateTime.now().month - 2, 1)
                                  .year;
                            });
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                            //Mes Actual
                            PopupMenuItem<int>(
                                value: 0, child: Text("Mes Actual")),
                            //Mes pasado
                            PopupMenuItem<int>(
                                value: 1, child: Text("Mes Anterior")),
                            //Hace 2 meses
                            PopupMenuItem<int>(
                                value: 2, child: Text("Hace 2 Meses")),
                          ]),
                  SizedBox(width: 30),
                  //Buscar
                  InkWell(
                    hoverColor: Colors.grey,
                    onTap: () {},
                    child: Container(
                      child: Row(children: [
                        //Icon
                        Icon(Icons.search, size: 14),
                        SizedBox(width: 5),
                        //Text
                        Text(
                          'Buscar', //product[index].product,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 5),
                        //Icon
                        Icon(Icons.keyboard_arrow_down, size: 14),
                      ]),
                    ),
                  ),

                  //Grupo de cuentas
                  //Cuenta/Categoria
                  //Proveedor
                  //Descripción
                  //Medio de Pago
                ]),
          ),
          //Historical Details
          StreamProvider<List<Expenses>>.value(
            value: DatabaseService()
                .expenseList(month.toString(), year.toString()),
            initialData: null,
            child: FilteredExpenseList(),
          ),
        ],
      ),
    ));
  }
}
