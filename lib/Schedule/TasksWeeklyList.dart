import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/ScheduledSales.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/Schedule/SingleScheduledDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskWeeklyList extends StatelessWidget {
  final String activeBusiness;
  TaskWeeklyList(this.activeBusiness);

  @override
  Widget build(BuildContext context) {
    final scheduledSales = Provider.of<List<ScheduledSales>>(context);

    if (scheduledSales == null || scheduledSales.length < 1) {
      return Container();
    }

    return Container(
        child: ListView.builder(
      itemCount: scheduledSales.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        List itemsList = [];

        scheduledSales[index].orderDetail.forEach((x) {
          itemsList.add('${x['Quantity']}x ${x['Name']}');
        });

        return Padding(
          padding: EdgeInsets.only(top: 8),
          child: IntrinsicHeight(
            child: TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StreamProvider<MonthlyStats>.value(
                        initialData: null,
                        value: DatabaseService()
                            .monthlyStatsfromSnapshot(activeBusiness),
                        child: SingleScheduledDialog(
                          order: scheduledSales[index],
                          businessID: activeBusiness,
                        ),
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Time
                  Text(
                    DateFormat('HH:mm').format((scheduledSales[index].dueDate)),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  //Divider
                  VerticalDivider(
                    indent: 2,
                    endIndent: 2,
                    thickness: 1.5,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 5),
                  //Task
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          width: double.infinity,
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Text(
                                  scheduledSales[index].orderName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10),
                                Text('(${itemsList.length} items)',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ));
  }
}
