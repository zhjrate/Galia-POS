import 'package:flutter/material.dart';

class PnlMargins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Gross Margin
          Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Text
                  Text(
                    'Gross Margin',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  //Margin
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //Number
                        Text(
                          '51',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 26),
                        ),
                        SizedBox(width: 5),
                        //%
                        Text(
                          '%',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ),
                      ]),
                ]),
          ),
          SizedBox(width: 40),
          //Op. Margin
          Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Text
                  Text(
                    'Operating Margin',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  //Margin
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //Number
                        Text(
                          '45',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 26),
                        ),
                        SizedBox(width: 5),
                        //%
                        Text(
                          '%',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ),
                      ]),
                ]),
          ),
          SizedBox(width: 40),
          //Profit Margin
          Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Text
                  Text(
                    'Profit Margin',
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  //Margin
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //Number
                        Text(
                          '18',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 26),
                        ),
                        SizedBox(width: 5),
                        //%
                        Text(
                          '%',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        ),
                      ]),
                ]),
          ),
        ],
      ),
    );
  }
}
