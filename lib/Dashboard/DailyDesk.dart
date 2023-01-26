import 'package:denario/Dashboard/DailyCashBalancing.dart';
import 'package:denario/Dashboard/DailySales.dart';
import 'package:flutter/material.dart';

class DailyDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1100) {
      return SingleChildScrollView(
        child: Container(
            width: double.infinity,
            height: (MediaQuery.of(context).size.height > 500)
                ? MediaQuery.of(context).size.height
                : 500,
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
                        borderRadius: new BorderRadius.circular(12.0),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.grey[350],
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                          )
                        ],
                      ),
                      height: (MediaQuery.of(context).size.height > 500)
                          ? MediaQuery.of(context).size.height
                          : 500,
                      child: DailyCashBalancing()),
                ),
                SizedBox(width: 15),
                //Daily Sales
                Expanded(
                    child: Container(
                  height: (MediaQuery.of(context).size.height > 500)
                      ? MediaQuery.of(context).size.height
                      : 500,
                  child: Container(child: DailySales()),
                )),
              ],
            )),
      );
    }
    return SingleChildScrollView(
      child: Container(
          width: double.infinity,
          height: (MediaQuery.of(context).size.height > 900)
              ? MediaQuery.of(context).size.height
              : 900,
          padding: EdgeInsets.all(30),
          child: Column(
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
                  height: 500,
                  child: DailyCashBalancing()),
              SizedBox(height: 15),
              //Daily Sales
              Container(height: 300, child: DailySales()),
            ],
          )),
    );
  }
}
