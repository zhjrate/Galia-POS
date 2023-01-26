import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/ScheduledSales.dart';
import 'package:denario/Models/Stats.dart';
import 'package:denario/Schedule/SingleScheduledDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  final String activeBusiness;
  TaskList(this.activeBusiness);

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Time
                Text(
                  DateFormat('HH:mm').format((scheduledSales[index].dueDate)),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                //Divider
                VerticalDivider(
                  indent: 2,
                  endIndent: 2,
                  thickness: 3,
                  color: Colors.grey,
                ),
                //Task
                Expanded(
                  child: Container(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.greenAccent),
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered))
                              return Colors.white;
                            if (states.contains(MaterialState.focused) ||
                                states.contains(MaterialState.pressed))
                              return Colors.grey.shade300;
                            return null; // Defer to the widget's default.
                          },
                        ),
                      ),
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
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Nombre
                              Container(
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
                                    Spacer(),
                                    (scheduledSales[index].pending)
                                        ? Container()
                                        : Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.greenAccent,
                                            ))
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              //Detalles
                              Text(itemsList.join(', '),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              (scheduledSales[index].note != '' &&
                                      scheduledSales[index].note != null)
                                  ? SizedBox(height: 8)
                                  : SizedBox(),
                              (scheduledSales[index].note != '' &&
                                      scheduledSales[index].note != null)
                                  ? Text(scheduledSales[index].note,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic))
                                  : SizedBox()
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
        );
      }),
    ));
  }
}
