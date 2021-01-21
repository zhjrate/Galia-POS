import 'package:flutter/material.dart';

import 'POS/POS_Mobile.dart';


class HomeMobile extends StatefulWidget {

  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int pageIndex = 0;

  final tabs = [
    POSMobile(),
  ];

  Widget screenNavigator (String screenName, IconData screenIcon){
    return FlatButton(
      hoverColor: Colors.black26,
      height: 50,
      onPressed: (){},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Icon
            Icon(screenIcon, color: Colors.white, size: 25),
            SizedBox(width: 8),
            //Text
            Text(screenName,
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  void openDrawer () {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
              color: Colors.black87,
              height: double.infinity,
              width: 75,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    screenNavigator('POS', Icons.blur_circular),
                    SizedBox(height: 20),
                    screenNavigator('Dashboard', Icons.bar_chart),
                    SizedBox(height: 20),
                    screenNavigator('Gastos', Icons.multiline_chart),
                    SizedBox(height: 20),
                    screenNavigator('PnL', Icons.data_usage)
                  ])
              )
            ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: openDrawer,
          icon: Icon(Icons.menu, color: Colors.black, size: 25)
        ),
        actions: [
          Row(children: [
            //User Image
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey
              ),
            ),
            SizedBox(width: 8),
            //Logout
            FlatButton(
              child: Text('Salir'),
              onPressed: (){}
            ),
            SizedBox(width: 8),
          ],)
        ],
      ),
      body: tabs[pageIndex],
    );
  }
}
