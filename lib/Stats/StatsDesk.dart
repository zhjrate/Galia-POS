import 'package:denario/Stats/DaillyStats.dart';
import 'package:denario/Stats/MonthlyStats.dart';
import 'package:flutter/material.dart';

class StatsDesk extends StatefulWidget {
  @override
  _StatsDeskState createState() => _StatsDeskState();
}

class _StatsDeskState extends State<StatsDesk> {
  bool showMonthlyStats;

  @override
  void initState() {
    showMonthlyStats = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: (MediaQuery.of(context).size.height > 950)
            ? MediaQuery.of(context).size.height
            : 1500,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Select Monthly or Daily Stats
            Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Today
                    Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: (showMonthlyStats)
                                ? MaterialStateProperty.all<Color>(Colors.white)
                                : MaterialStateProperty.all<Color>(
                                    Colors.black),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.grey;
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed))
                                  return Colors.grey.shade300;
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showMonthlyStats = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Center(
                              child: Text(
                                'Hoy',
                                style: (showMonthlyStats)
                                    ? TextStyle(color: Colors.black)
                                    : TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(width: 20),
                    //Month
                    Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: (showMonthlyStats)
                                ? MaterialStateProperty.all<Color>(Colors.black)
                                : MaterialStateProperty.all<Color>(
                                    Colors.white),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.grey;
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed))
                                  return Colors.grey.shade300;
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              showMonthlyStats = true;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Center(
                              child: Text(
                                'Mes',
                                style: (showMonthlyStats)
                                    ? TextStyle(color: Colors.white)
                                    : TextStyle(color: Colors.black),
                              ),
                            ),
                          )),
                    ),
                  ]),
            ),
            SizedBox(height: 15),
            //Stats Page
            Expanded(child: (showMonthlyStats) ? MonthStats() : DailyStats()),
          ],
        ),
      ),
    );
  }
}
