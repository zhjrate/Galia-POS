import 'package:denario/Models/Mapping.dart';
import 'package:denario/PnL/PnL.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PnlDesk extends StatefulWidget {
  @override
  _PnlDeskState createState() => _PnlDeskState();
}

class _PnlDeskState extends State<PnlDesk> {
  int pnlYear;
  int pnlMonth;

  @override
  void initState() {
    pnlYear = DateTime.now().year;
    pnlMonth = DateTime.now().month;
    super.initState();
  }

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
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title + Date
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Title
                  Text(
                    'Estado de resultados',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Month
                        Container(
                          padding: EdgeInsets.all(5),
                          child: DropdownButton<String>(
                            value: pnlMonth.toString(),
                            //elevation: 5,
                            style: TextStyle(color: Colors.black),
                            items: <String>[
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9',
                              '10',
                              '11',
                              '12',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text(
                              pnlMonth.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                pnlMonth = int.parse(value);
                              });
                            },
                          ),
                        ),
                        Divider(
                            indent: 10,
                            endIndent: 10,
                            color: Colors.grey,
                            thickness: 0.5),
                        //Year
                        Container(
                          padding: EdgeInsets.all(5),
                          child: DropdownButton<String>(
                            value: pnlYear.toString(),
                            //elevation: 5,
                            style: TextStyle(color: Colors.black),
                            items: <String>[
                              '2021',
                              '2022',
                              '2023',
                              '2024',
                              '2025',
                              '2026',
                              '2027',
                              '2028',
                              '2029',
                              '2030',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: Text(
                              pnlYear.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                pnlYear = int.parse(value);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //PnL
            PnL(
                pnlAccountGroups: pnlAccountGroups,
                pnlMapping: pnlMapping,
                pnlMonth: pnlMonth,
                pnlYear: pnlYear)
          ],
        ),
      ),
    );
  }
}
