import 'package:denario/Dashboard/DailyCashBalancing.dart';
import 'package:denario/Dashboard/DailySales.dart';
import 'package:flutter/material.dart';

class DailyDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        height: 700,
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Cash Register Balancing
            Expanded(
              child: Container(
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
                  height: 650,
                  child: DailyCashBalancing()),
            ),
            SizedBox(width: 15),
            //Daily Sales
            Expanded(
              child: Container(height: 650, child: DailySales()),
            ),
          ],
        ),
      ),
    );
  }
}
