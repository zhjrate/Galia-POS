import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Dashboard/SalesDetailsView.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Sales.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/No%20POS%20Sales/NewSaleScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesDetailsFilters extends StatefulWidget {
  final String currentBusiness;
  final CashRegister registerStatus;
  SalesDetailsFilters(this.currentBusiness, this.registerStatus);

  @override
  State<SalesDetailsFilters> createState() => _SalesDetailsFiltersState();
}

class _SalesDetailsFiltersState extends State<SalesDetailsFilters> {
  DateTime initDate;
  DateTime endDate;
  String paymentType;
  bool filtered;
  List paymentTypes = [];

  @override
  void initState() {
    initDate = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0)
        .subtract(Duration(days: 1));
    endDate = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 23, 59, 59);
    filtered = false;

    for (var i = 0; i < widget.registerStatus.paymentTypes.length; i++) {
      paymentTypes.add(widget.registerStatus.paymentTypes[i]['Type']);
    }

    paymentTypes.insert(0, 'Todos');
    paymentTypes.add('Por Cobrar');
    paymentType = 'Todos';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width:
          (MediaQuery.of(context).size.width > 1100) ? double.infinity : 1100,
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
                  icon: Icon(Icons.arrow_back)),
              SizedBox(width: 25),
              Text(
                'Historial de ventas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Container(
                height: 50,
                child: Tooltip(
                  message: 'Registrar o agendar nueva venta',
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      final User user = FirebaseAuth.instance.currentUser;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                    providers: [
                                      StreamProvider<UserData>.value(
                                          initialData: null,
                                          value: DatabaseService().userProfile(
                                              user.uid.toString())),
                                      StreamProvider<MonthlyStats>.value(
                                        value: DatabaseService()
                                            .monthlyStatsfromSnapshot(
                                                widget.currentBusiness),
                                        initialData: null,
                                      )
                                    ],
                                    child: Scaffold(
                                        body: NewSaleScreen(
                                            widget.currentBusiness)),
                                  )));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 16),
                            SizedBox(width: 10),
                            Text('Nueva venta')
                          ]),
                    ),
                  ),
                ),
              )
            ]),
          ),
          SizedBox(height: 20),
          //Filters
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey[350],
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Fecha
                Container(
                  width: 150,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[350]),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(initDate),
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
                                initialDate: initDate,
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 730)),
                                lastDate: DateTime.now(),
                                builder: ((context, child) {
                                  return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors
                                              .black, // header background color
                                          onPrimary:
                                              Colors.white, // header text color
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
                                initDate = pickedDate;
                                filtered = true;
                              }
                            });
                          },
                          padding: EdgeInsets.all(0),
                          tooltip: 'Selecciona un fecha inicial',
                          iconSize: 18,
                          icon: Icon(Icons.calendar_month),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                    width: 150,
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[350]),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(12),
                    child: //(DateTime.now().difference(initDate).inDays > 1)
                        // ?
                        Row(
                      children: [
                        Text(
                          (endDate == null)
                              ? 'Hasta fecha'
                              : DateFormat('dd/MM/yyyy').format(endDate),
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
                                  initialDate: DateTime.now(),
                                  firstDate: initDate,
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
                                  endDate = pickedDate
                                      .add(Duration(hours: 23, minutes: 59));
                                  filtered = true;
                                }
                              });
                            },
                            padding: EdgeInsets.all(0),
                            tooltip: 'Selecciona un fecha final',
                            iconSize: 18,
                            icon: Icon(Icons.calendar_month),
                          ),
                        )
                      ],
                    )
                    // : Row(
                    //     children: [
                    //       Text(
                    //         'Hasta fecha',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 16,
                    //             color: Colors.grey),
                    //       ),
                    //       Spacer(),
                    //       Container(
                    //         height: 20,
                    //         width: 20,
                    //         child: IconButton(
                    //           splashRadius: 1,
                    //           color: Colors.grey,
                    //           onPressed: () {},
                    //           padding: EdgeInsets.all(0),
                    //           tooltip: 'Selecciona un fecha final',
                    //           iconSize: 18,
                    //           icon: Icon(Icons.calendar_month),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    ),
                SizedBox(width: 20),

                //Medio de pago
                Container(
                  width: 250,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[350]),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButton(
                    isExpanded: true,
                    underline: SizedBox(),
                    hint: Text(
                      'Método de pago',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black),
                    value: paymentType,
                    items: paymentTypes.map((i) {
                      return new DropdownMenuItem(
                        value: i,
                        child: new Text(i),
                      );
                    }).toList(),
                    onChanged: (x) {
                      setState(() {
                        paymentType = x;
                        filtered = true;
                      });
                    },
                  ),
                ),

                Spacer(),
                //Boton de filtrar
                Container(
                  height: 40,
                  width: 40,
                  child: Tooltip(
                    message: 'Quitar filtros',
                    child: OutlinedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(5)),
                        alignment: Alignment.center,
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white70),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors.grey.shade300;
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed))
                              return Colors.white;
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          paymentType = 'Todos';
                          initDate = DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  0,
                                  0,
                                  0)
                              .subtract(Duration(days: 1));
                          endDate = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              23,
                              59,
                              59);
                          filtered = false;
                        });
                      },
                      child: Center(
                          child: Icon(
                        Icons.filter_alt_off_outlined,
                        color: Colors.black,
                        size: 18,
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Titles
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Fecha
                Container(
                    width: 50,
                    child: Text(
                      'Fecha',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    )),
                //Hora
                Container(
                    width: 75,
                    child: Text(
                      'Hora',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    )),

                //Nombre
                Container(
                    width: 120,
                    child: Text(
                      'Cliente',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    )),

                //Payment Type
                Container(
                    width: 120,
                    child: Center(
                      child: Text(
                        'Medio de pago',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                //Total
                Container(
                    width: 70,
                    child: Center(
                      child: Text(
                        'Total',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                //More Button
                SizedBox(width: 45)
              ],
            ),
          ),
          Divider(
            indent: 1,
            endIndent: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          //Historical Details
          Expanded(
              child: (filtered)
                  ? StreamProvider<List<Sales>>.value(
                      initialData: null,
                      value: DatabaseService().filteredSalesList(
                          widget.currentBusiness,
                          initDate,
                          endDate,
                          paymentType),
                      child: SalesDetailsView(
                          widget.currentBusiness, widget.registerStatus))
                  : StreamProvider<List<Sales>>.value(
                      initialData: null,
                      value:
                          DatabaseService().salesList(widget.currentBusiness),
                      child: SalesDetailsView(
                          widget.currentBusiness, widget.registerStatus)))
        ],
      ),
    ));
  }
}
