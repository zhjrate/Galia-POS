import 'package:denario/Models/DailyCash.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailySalesGraph extends StatefulWidget {
  final List<DailyTransactions> salesGraphDataList;
  DailySalesGraph(this.salesGraphDataList);

  @override
  State<StatefulWidget> createState() => DailySalesGraphState();
}

class DailySalesGraphState extends State<DailySalesGraph> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List<DailyTransactions> salesGraphValues;

  Map minSale;
  Map maxSale;

  int min;
  int max;
  int avg;

  @override
  void initState() {
    salesGraphValues = widget.salesGraphDataList;
    setState(() {
      DailyTransactions minSale =
          salesGraphValues.reduce((a, b) => a.sales < b.sales ? a : b);
      DailyTransactions maxSale =
          salesGraphValues.reduce((a, b) => a.sales > b.sales ? a : b);

      min = minSale.sales.round();
      max = maxSale.sales.round();
      avg = ((min + max) / 2).round();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: LineChart(mainData()));
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                if (salesGraphValues.length > 0) {
                  return salesGraphValues[0].openDate.day.toString();
                }
                return '';

              case 1:
                if (salesGraphValues.length > 1) {
                  return salesGraphValues[1].openDate.day.toString();
                }
                return '';
              case 2:
                if (salesGraphValues.length > 2) {
                  return salesGraphValues[2].openDate.day.toString();
                }
                return '';
              case 3:
                if (salesGraphValues.length > 3) {
                  return salesGraphValues[3].openDate.day.toString();
                }
                return '';
              case 4:
                if (salesGraphValues.length > 4) {
                  return salesGraphValues[4].openDate.day.toString();
                }
                return '';
              case 5:
                if (salesGraphValues.length > 5) {
                  return salesGraphValues[5].openDate.day.toString();
                }
                return '';
              case 6:
                if (salesGraphValues.length > 6) {
                  return salesGraphValues[6].openDate.day.toString();
                }
                return '';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: false,
          //   getTextStyles: (value) => const TextStyle(
          //     color: Color(0xff67727d),
          //     fontWeight: FontWeight.bold,
          //     fontSize: 12,
          //   ),
          //   getTitles: (value) {
          //     switch (value.toInt()) {
          //       case 1:
          //         return '${minSale['Sales']}k';
          //       case 2:
          //         return '${(maxSale['Sales'] + minSale['Sales']) / 2}k';
          //       case 5:
          //         return '${maxSale['Sales']}k';
          //     }
          //     return '';
          //   },
          //   reservedSize: 28,
          //   margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: max.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0,
                (salesGraphValues.length > 0) ? salesGraphValues[0].sales : 0),
            FlSpot(1,
                (salesGraphValues.length > 1) ? salesGraphValues[1].sales : 0),
            FlSpot(2,
                (salesGraphValues.length > 2) ? salesGraphValues[2].sales : 0),
            FlSpot(3,
                (salesGraphValues.length > 3) ? salesGraphValues[3].sales : 0),
            FlSpot(4,
                (salesGraphValues.length > 4) ? salesGraphValues[4].sales : 0),
            FlSpot(5,
                (salesGraphValues.length > 5) ? salesGraphValues[5].sales : 0),
            FlSpot(6,
                (salesGraphValues.length > 6) ? salesGraphValues[6].sales : 0),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
