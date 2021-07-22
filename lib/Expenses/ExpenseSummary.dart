import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';

class ExpenseSummary extends StatefulWidget {
  @override
  _ExpenseSummaryState createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  Widget indicator(Color color, String text, double size, Color textColor,
      FontWeight weight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style:
                TextStyle(fontSize: 12, fontWeight: weight, color: textColor),
          )
        ],
      ),
    );
  }

  Future currentValuesBuilt;

  double costodeVentas;
  double gastosdeEmpleados;
  double gastosdelLocal;
  double otrosGastos;

  Future currentValue() async {
    var year = DateTime.now().year.toString();
    var month = DateTime.now().month.toString();

    var firestore = FirebaseFirestore.instance;

    var docRef = firestore
        .collection('ERP')
        .doc('VTam7iYZhiWiAFs3IVRBaLB5s3m2')
        .collection(year)
        .doc(month)
        .get();
    return docRef;
  }

  @override
  void initState() {
    currentValuesBuilt = currentValue();
    super.initState();
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return FutureBuilder(
        future: currentValuesBuilt,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            try {
              costodeVentas = snap.data['Costo de Ventas'];
            } catch (e) {
              costodeVentas = 0;
            }

            try {
              gastosdeEmpleados = snap.data['Gastos de Empleados'];
            } catch (e) {
              gastosdeEmpleados = 0;
            }

            try {
              gastosdelLocal = snap.data['Gastos del Local'];
            } catch (e) {
              gastosdelLocal = 0;
            }

            try {
              otrosGastos = snap.data['Otros Gastos'];
            } catch (e) {
              otrosGastos = 0;
            }

            final double totalGastos = (costodeVentas +
                gastosdeEmpleados +
                gastosdelLocal +
                otrosGastos);

            return Container(
              width: double.infinity,
              height: screen.height * 0.5,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  //Legend
                  (screen.width > 1250)
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            indicator(
                              Colors.red[200],
                              'Costo de ventas',
                              touchedIndex == 0 ? 18 : 16,
                              touchedIndex == 0 ? Colors.black : Colors.grey,
                              touchedIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                            ),
                            indicator(
                              Colors.green[200],
                              'Gastos de empleados',
                              touchedIndex == 1 ? 18 : 16,
                              touchedIndex == 1 ? Colors.black : Colors.grey,
                              touchedIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                            ),
                            indicator(
                              Colors.blue[200],
                              'Gastos del local',
                              touchedIndex == 2 ? 18 : 16,
                              touchedIndex == 2 ? Colors.black : Colors.grey,
                              touchedIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                            ),
                            indicator(
                              Colors.purple[200],
                              'Otros gastos',
                              touchedIndex == 3 ? 18 : 16,
                              touchedIndex == 3 ? Colors.black : Colors.grey,
                              touchedIndex == 3
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                            ),
                          ],
                        )
                      : Column(children: [
                          // 1 and 2
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              indicator(
                                Colors.red[200],
                                'Costo de ventas',
                                touchedIndex == 0 ? 18 : 16,
                                touchedIndex == 0 ? Colors.black : Colors.grey,
                                touchedIndex == 0
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                              indicator(
                                Colors.green[200],
                                'Gastos de empleados',
                                touchedIndex == 1 ? 18 : 16,
                                touchedIndex == 1 ? Colors.black : Colors.grey,
                                touchedIndex == 1
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // 3 and 4
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              indicator(
                                Colors.blue[200],
                                'Gastos del local',
                                touchedIndex == 2 ? 18 : 16,
                                touchedIndex == 2 ? Colors.black : Colors.grey,
                                touchedIndex == 2
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                              indicator(
                                Colors.purple[200],
                                'Otros gastos',
                                touchedIndex == 3 ? 18 : 16,
                                touchedIndex == 3 ? Colors.black : Colors.grey,
                                touchedIndex == 3
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ],
                          )
                        ]),
                  const SizedBox(
                    height: 12,
                  ),
                  //Pie
                  Expanded(
                      child: PieChart(
                    PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput
                                  is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch &&
                              pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse
                                .touchedSection.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 5,
                      centerSpaceRadius: (screen.width > 1250) ? 75 : 60,
                      sections: showingSections(
                          costodeVentas,
                          gastosdeEmpleados,
                          gastosdelLocal,
                          otrosGastos,
                          totalGastos),
                    ),
                  )),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

//Sections
  List<PieChartSectionData> showingSections(
      double costodeVentas,
      double gastosdeEmpleados,
      double gastosdelLocal,
      double otrosGastos,
      double totalGastos) {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 14.0 : 1.0;
      final radius = isTouched ? 40.0 : 20.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.red[200],
            value: costodeVentas,
            title:
                '${(costodeVentas / (costodeVentas + gastosdeEmpleados + gastosdelLocal + otrosGastos) * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green[200],
            value: gastosdeEmpleados,
            title:
                '${(gastosdeEmpleados / (costodeVentas + gastosdeEmpleados + gastosdelLocal + otrosGastos) * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blue[200],
            value: gastosdelLocal,
            title:
                '${(gastosdelLocal / (costodeVentas + gastosdeEmpleados + gastosdelLocal + otrosGastos) * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.purple[200],
            value: otrosGastos,
            title:
                '${(otrosGastos / (costodeVentas + gastosdeEmpleados + gastosdelLocal + otrosGastos) * 100).toStringAsFixed(0)}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
