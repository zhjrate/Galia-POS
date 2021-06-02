import 'package:denario/Models/Mapping.dart';
import 'package:denario/PnL/PnL.dart';
import 'package:denario/PnL/PnlMargins.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PnlDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final highLevelMapping = Provider.of<HighLevelMapping>(context);

    if (highLevelMapping == null) {
      return Center();
    }

    final List pnlAccountGroups = highLevelMapping.pnlAccountGroups;
    final Map<dynamic, dynamic> pnlMapping = highLevelMapping.pnlMapping;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title + Date
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Title
                  Text(
                    'Estado de resultados',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Spacer(),
                  //Month selection
                  Container(
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
                    child: Text(
                      '05 - 2021',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            //Margins
            PnlMargins(),
            //PnL
            PnL(pnlAccountGroups: pnlAccountGroups, pnlMapping: pnlMapping)
            //Bar Graph
          ],
        ),
      ),
    );
  }
}
