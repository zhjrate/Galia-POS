import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denario/PnL/PnlMargins.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PnL extends StatefulWidget {
  final List pnlAccountGroups;
  final Map<dynamic, dynamic> pnlMapping;
  final int pnlMonth;
  final int pnlYear;

  PnL({this.pnlAccountGroups, this.pnlMapping, this.pnlMonth, this.pnlYear});

  @override
  _PnLState createState() => _PnLState();
}

class _PnLState extends State<PnL> {
  final formatCurrency = new NumberFormat.simpleCurrency();

  double totalVentas;
  double totalCostodeVentas;
  double totalGastosdeEmpleados;
  double totalGastosdelLocal;
  double totalOtrosGastos;

  Future currentValue() async {
    var firestore = FirebaseFirestore.instance;

    var docRef = firestore
        .collection('ERP')
        .doc('VTam7iYZhiWiAFs3IVRBaLB5s3m2')
        .collection((widget.pnlYear).toString())
        .doc((widget.pnlMonth).toString())
        .get();
    return docRef;
  }

  // @override
  // void initState() {
  //   currentValuesBuilt = currentValue();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: currentValue(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            try {
              totalVentas = snapshot.data['Ventas'];
            } catch (e) {
              totalVentas = 0;
            }
            try {
              totalCostodeVentas = snapshot.data['Costo de Ventas'];
            } catch (e) {
              totalCostodeVentas = 0;
            }
            try {
              totalGastosdeEmpleados = snapshot.data['Gastos de Empleados'];
            } catch (e) {
              totalGastosdeEmpleados = 0;
            }
            try {
              totalGastosdelLocal = snapshot.data['Gastos del Local'];
            } catch (e) {
              totalGastosdelLocal = 0;
            }
            try {
              totalOtrosGastos = snapshot.data['Otros Gastos'];
            } catch (e) {
              totalOtrosGastos = 0;
            }

            final double grossMargin =
                ((totalVentas - totalCostodeVentas) / totalVentas) * 100;
            final double gross = totalVentas - totalCostodeVentas;

            final double operatingMargin = ((totalVentas -
                        totalCostodeVentas -
                        totalGastosdeEmpleados -
                        totalGastosdelLocal) /
                    totalVentas) *
                100;
            final double operating = totalVentas -
                totalCostodeVentas -
                totalGastosdeEmpleados -
                totalGastosdelLocal;

            final double profitMargin = ((totalVentas -
                        totalCostodeVentas -
                        totalGastosdeEmpleados -
                        totalGastosdelLocal -
                        totalOtrosGastos) /
                    totalVentas) *
                100;

            final double profit = totalVentas -
                totalCostodeVentas -
                totalGastosdeEmpleados -
                totalGastosdelLocal -
                totalOtrosGastos;

            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Margins and Graphs
                    PnlMargins(
                      grossMargin: grossMargin,
                      gross: gross,
                      operatingMargin: operatingMargin,
                      operating: operating,
                      profitMargin: profitMargin,
                      profit: profit,
                      snapshot: snapshot,
                    ),
                    //PnL Card
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.all(15),
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.pnlAccountGroups.length,
                        itemBuilder: (context, i) {
                          int categoryAmount;

                          try {
                            categoryAmount =
                                snapshot.data['${widget.pnlAccountGroups[i]}'];
                          } catch (e) {
                            categoryAmount = 0;
                          }

                          //List of Group of Accounts (High Level Mapping)
                          return Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Account Group Text
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        widget.pnlAccountGroups[i],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    //Sub Accounts
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.28,
                                      padding: EdgeInsets.all(5),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: widget
                                              .pnlMapping[
                                                  '${widget.pnlAccountGroups[i]}']
                                              .length,
                                          itemBuilder: (context, x) {
                                            int itemAmount;

                                            try {
                                              itemAmount = snapshot.data[
                                                  '${widget.pnlMapping[widget.pnlAccountGroups[i]][x]}'];
                                            } catch (e) {
                                              itemAmount = 0;
                                            }

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(children: [
                                                //Cuenta
                                                Text(
                                                    '${widget.pnlMapping[widget.pnlAccountGroups[i]][x]}'),
                                                Spacer(),
                                                //Monto
                                                Text(
                                                    '${formatCurrency.format(itemAmount)}'),
                                              ]),
                                            );
                                          }),
                                    ),
                                    SizedBox(height: 15),
                                    //Total of Account Group
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(children: [
                                        //Cuenta
                                        Text(
                                          'Total de ${widget.pnlAccountGroups[i]}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Spacer(),
                                        //Monto
                                        Text(
                                            '${formatCurrency.format(categoryAmount)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800)),
                                      ]),
                                    )
                                  ]));
                        },
                        //List of Accounts inside group (PnL Mapping)
                      ),
                    ),
                  ]),
            );
          } else {
            return Center();
          }
        });
  }
}
