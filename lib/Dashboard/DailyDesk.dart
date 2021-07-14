import 'package:denario/Dashboard/DailyCashBalancing.dart';
import 'package:denario/Dashboard/DailySales.dart';
import 'package:flutter/material.dart';

class DailyDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Cash Register Balancing
            Container(
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
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.8,
                child: DailyCashBalancing()),
            Spacer(),
            //Daily Sales
            Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.height * 0.8,
                child: DailySales()),
          ],
        ),
      ),
    );
  }
}
