import 'package:denario/Models/DailyCash.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailySalesGraph extends StatefulWidget {
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
  Widget build(BuildContext context) {
    final dailyTransactionsList = Provider.of<List<DailyTransactions>>(context);
    salesGraphValues = dailyTransactionsList;

    if (salesGraphValues == null) {
      return Container();
    } else if (salesGraphValues.length == 0) {
      min = 0;
      max = 100;
      avg = 50;
    } else {
      DailyTransactions minSale =
          salesGraphValues.reduce((a, b) => a.sales < b.sales ? a : b);
      DailyTransactions maxSale =
          salesGraphValues.reduce((a, b) => a.sales > b.sales ? a : b);

      min = minSale.sales.round();
      max = maxSale.sales.round();
      avg = ((min + max) / 2).round();
    }

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
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(
                color: Color(0xff68737d),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              String text;
              switch (value.toInt()) {
                case 0:
                  if (salesGraphValues.length > 0) {
                    text = '${salesGraphValues[0].openDate.day}';
                  } else {
                    text = '';
                  }
                  break;
                case 1:
                  if (salesGraphValues.length > 1) {
                    text = '${salesGraphValues[1].openDate.day}';
                  } else {
                    text = '';
                  }
                  break;
                case 2:
                  if (salesGraphValues.length > 2) {
                    text = '${salesGraphValues[2].openDate.day}';
                  } else {
                    text = '';
                  }
                  break;
                case 3:
                  if (salesGraphValues.length > 3) {
                    text = '${salesGraphValues[3].openDate.day}';
                  } else {
                    text = '';
                  }
                  break;
                case 4:
                  if (salesGraphValues.length > 4) {
                    text = '${salesGraphValues[4].openDate.day}';
                  } else {
                    text = '';
                  }
                  break;
                case 5:
                  if (salesGraphValues.length > 5) {
                    text = '${salesGraphValues[5].openDate.day}';
                  } else {
                    text = '';
                  }
                  break;
                case 6:
                  if (salesGraphValues.length > 6) {
                    text = '${salesGraphValues[6].openDate.day}';
                  } else {
                    text = '';
                  }
                  break;
                default:
                  return Container();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(text, style: style, textAlign: TextAlign.left),
              );
            },
          )),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: Color(0xff68737d),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                );
                String text;

                switch (value.toInt()) {
                  case 1:
                    text = '${minSale['Sales']}k';
                    break;
                  case 2:
                    text = '${(maxSale['Sales'] + minSale['Sales']) / 2}k';
                    break;
                  case 5:
                    text = '${maxSale['Sales']}k';
                    break;
                  default:
                    return Container();
                }

                text = '';
                return Text(text, style: style, textAlign: TextAlign.left);
              },
              reservedSize: 28,
              // margin: 12,
            ),
          )),
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
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
    );
  }
}
