import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/auth.dart';
import 'package:denario/Dashboard/DailyDesk.dart';
import 'package:denario/Expenses/ExpensesDesk.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/PnL/PnlDesk.dart';
import 'package:denario/Wrapper.dart';
import 'package:denario/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'POS/POS_Desk.dart';

class HomeDesk extends StatefulWidget {
  @override
  _HomeDeskState createState() => _HomeDeskState();
}

class _HomeDeskState extends State<HomeDesk> {
  final _auth = AuthService();
  int pageIndex = 0;

  final tabs = [
    POSDesk(),
    Navigator(onGenerateRoute: (routeSettings) {
      return MaterialPageRoute(builder: (context) => DailyDesk());
    }),
    ExpensesDesk(),
    PnlDesk(),
  ];

  Widget screenNavigator(String screenName, IconData screenIcon, int index) {
    return FlatButton(
      hoverColor: Colors.black26,
      height: 50,
      onPressed: () {
        setState(() {
          pageIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon
            Icon(screenIcon, color: Colors.white, size: 25),
            SizedBox(height: 5),
            //Text
            Text(
              screenName,
              style: TextStyle(color: Colors.white, fontSize: 9),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registerStatus = Provider.of<CashRegister>(context);

    if (registerStatus == null) {
      return Container();
    }

    return MultiProvider(
      providers: [
        StreamProvider<DailyTransactions>.value(
            initialData: null,
            value: DatabaseService()
                .dailyTransactions(registerStatus.registerName)),
        StreamProvider<List<DailyTransactions>>.value(
            initialData: null, value: DatabaseService().dailyTransactionsList())
      ],
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Center(
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/Denario Tag.png'))),
              ),
            ),
            actions: [
              Row(
                children: [
                  //User Image
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                  ),
                  SizedBox(width: 8),
                  //Logout
                  TextButton(
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Wrapper()));
                      },
                      child: Text(
                        'Salir',
                        style: TextStyle(color: Colors.grey),
                      )),
                  SizedBox(width: 8),
                ],
              )
            ],
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Navigation Bar
                Container(
                    color: Colors.black87,
                    height: double.infinity,
                    width: 75,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              screenNavigator('POS', Icons.blur_circular, 0),
                              SizedBox(height: 20),
                              screenNavigator('Daily', Icons.bar_chart, 1),
                              SizedBox(height: 20),
                              screenNavigator(
                                  'Gastos', Icons.multiline_chart, 2),
                              SizedBox(height: 20),
                              screenNavigator('PnL', Icons.data_usage, 3)
                            ]))),
                //Dynamic Body
                Expanded(
                  child: Container(
                    child: tabs[pageIndex],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
