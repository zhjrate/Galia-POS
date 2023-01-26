import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrossMarginGraph extends StatefulWidget {
  final List pnlAccountGroups;
  final Map<dynamic, dynamic> pnlMapping;
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
  GrossMarginGraph(
      {this.pnlAccountGroups,
      this.pnlMapping,
      this.cafeVentas,
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
  State<StatefulWidget> createState() => GrossMarginGraphState();
}

class GrossMarginGraphState extends State<GrossMarginGraph> {
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
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          //Title
          Text(
            'Gross Margin by Category',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          const SizedBox(
            height: 38,
          ),
          //Graph
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BarChart(
                BarChartData(
                  maxY: 500000,
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      // getTextStyles: (value) => const TextStyle(
                      //     color: Color(0xff7589a2),
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 12),
                      //margin: 20,
                      getTitlesWidget: (double value, meta) {
                        List<String> titles = [
                          "Café",
                          "Postres",
                          "Panadería",
                          "Platos",
                          "Bebidas",
                          "Promos",
                          "Otros"
                        ];

                        Widget text = Text(
                          titles[value.toInt()],
                          style: const TextStyle(
                            color: Color(0xff7589a2),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        );

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8, //margin top
                          child: text,
                        );
                      },
                    )),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    // leftTitles: AxisTitles(
                    //   sideTitles: SideTitles(
                    //     showTitles: true,
                    //     reservedSize: 5,
                    //     getTitlesWidget: (value, meta) {
                    //       const style = TextStyle(
                    //         color: Color(0xff7589a2),
                    //         fontWeight: FontWeight.normal,
                    //         fontSize: 14,
                    //       );
                    //       String text;

                    //       if (value == 10000) {
                    //         text = '10k';
                    //       } else if (value == 50000) {
                    //         text = '50K';
                    //       } else if (value == 150000) {
                    //         text = '150K';
                    //       } else if (value == 300000) {
                    //         text = '300K';
                    //       } else {
                    //         return Container();
                    //       }

                    //       return SideTitleWidget(
                    //         axisSide: meta.axisSide,
                    //         space: 0,
                    //         child: Container(
                    //             width: 50, child: Text(text, style: style)),
                    //       );
                    //     },
                    //   ),
                    // )
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
        toY: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }
}
