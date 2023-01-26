import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Tables.dart';
import 'package:denario/POS/CreateTableDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TablesViewDesktop extends StatefulWidget {
  final String businessID;
  final PageController tableController;
  TablesViewDesktop(this.businessID, this.tableController);
  @override
  _TablesViewDesktopState createState() => _TablesViewDesktopState();
}

class _TablesViewDesktopState extends State<TablesViewDesktop> {
  bool productExists = false;
  int itemIndex;
  final formatCurrency = new NumberFormat.simpleCurrency();
  @override
  Widget build(BuildContext context) {
    final tables = Provider.of<List<Tables>>(context);

    if (tables == null) {
      return Center();
    }

    return StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.ticketItems,
        builder: (context, snapshot) {
          return GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (MediaQuery.of(context).size.width > 1100) ? 8 : 4,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 1,
            ),
            scrollDirection: Axis.vertical,
            itemCount: tables.length + 1,
            itemBuilder: (context, i) {
              if (i < tables.length) {
                return ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: (tables[i].isOpen)
                        ? MaterialStateProperty.all<Color>(Colors.greenAccent)
                        : MaterialStateProperty.all<Color>(Colors.white),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered))
                          return Colors.black12;
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed))
                          return Colors.black26;
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    if (tables[i].isOpen) {
                      //retrieve order
                      bloc.retrieveOrder(
                          tables[i].table,
                          tables[i].paymentType,
                          tables[i].orderDetail,
                          tables[i].discount,
                          tables[i].tax,
                          Color(tables[i].orderColor),
                          true,
                          'Mesa ${tables[i].table}',
                          false,
                          'Mesa',
                          (tables[i].client['Name'] == '' ||
                                  tables[i].client['Name'] == null)
                              ? false
                              : true,
                          tables[i].client);
                    } else {
                      //create order with table name
                      bloc.retrieveOrder(
                          tables[i].table,
                          tables[i].paymentType,
                          tables[i].orderDetail,
                          tables[i].discount,
                          tables[i].tax,
                          Color(tables[i].orderColor),
                          false,
                          'Mesa ${tables[i].table}',
                          false,
                          'Mesa',
                          false, {});

                      // bloc.changeOrderName(tables[i].table);
                      // bloc.changeTableStatus(false);
                    }
                    widget.tableController.animateToPage(1,
                        duration: Duration(milliseconds: 250),
                        curve: Curves.easeIn);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            tables[i].table, //product[index].product,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        (tables[i].isOpen)
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'Total: ${formatCurrency.format(tables[i].total)}',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              } else {
                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    //Dialog to create table
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CreateTableDialog(widget.businessID);
                        });
                  },
                  child: Center(
                      child: Icon(
                    Icons.add,
                    color: Colors.black87,
                    size: 30,
                  )),
                );
              }
            },
          );
        });
  }
}
