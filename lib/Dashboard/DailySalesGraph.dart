import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class DailySalesGraph extends StatefulWidget {
  final double cafeVentas;
  final double cafeCostos;
  final double postresVentas;
  final double postresCostos;
  final double panVentas;
  final double panCostos;
  final double platosVentas;
  final double platosCostos;
  final double bebidasVentas;
  final double bebidasCostos;
  final double promosVentas;
  final double otrosCostos;
  DailySalesGraph(
      {this.cafeVentas,
      this.cafeCostos,
      this.postresVentas,
      this.postresCostos,
      this.panVentas,
      this.panCostos,
      this.platosVentas,
      this.platosCostos,
      this.bebidasVentas,
      this.bebidasCostos,
      this.promosVentas,
      this.otrosCostos});

  @override
  State<StatefulWidget> createState() => DailySalesGraphState();
}

class DailySalesGraphState extends State<DailySalesGraph> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();

    final barGroup1 = makeGroupData(0, widget.cafeVentas, widget.cafeCostos);
    final barGroup2 =
        makeGroupData(1, widget.postresVentas, widget.postresCostos);
    final barGroup3 = makeGroupData(2, widget.panVentas, widget.panCostos);
    final barGroup4 =
        makeGroupData(3, widget.platosVentas, widget.platosCostos);
    final barGroup5 =
        makeGroupData(4, widget.bebidasVentas, widget.bebidasCostos);
    final barGroup6 = makeGroupData(5, widget.promosVentas, 0);
    final barGroup7 = makeGroupData(6, 0, widget.otrosCostos);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'Gross Margin by Category',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          const SizedBox(
            height: 38,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BarChart(
                BarChartData(
                  maxY: 300000,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      margin: 20,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'Café';
                          case 1:
                            return 'Postres';
                          case 2:
                            return 'Panadería';
                          case 3:
                            return 'Platos';
                          case 4:
                            return 'Bebidas';
                          case 5:
                            return 'Promos';
                          case 6:
                            return 'Otros';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                          color: Color(0xff7589a2),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      margin: 32,
                      reservedSize: 14,
                      getTitles: (value) {
                        if (value == 10000) {
                          return '10K';
                        } else if (value == 50000) {
                          return '50K';
                        } else if (value == 150000) {
                          return '150K';
                        } else if (value == 300000) {
                          return '300K';
                        } else {
                          return '';
                        }
                      },
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }
}
