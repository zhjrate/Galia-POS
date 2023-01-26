import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CounterViewDesktop extends StatefulWidget {
  final String businessID;
  final PageController tableController;
  const CounterViewDesktop(this.businessID, this.tableController);

  @override
  State<CounterViewDesktop> createState() => _CounterViewDesktopState();
}

class _CounterViewDesktopState extends State<CounterViewDesktop> {
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final savedOrders = Provider.of<List<SavedOrders>>(context);

    if (savedOrders == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Saved Orders
        Expanded(
            flex: 4,
            child: Container(
              child: GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (MediaQuery.of(context).size.width > 1100) ? 4 : 3,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  childAspectRatio:
                      (MediaQuery.of(context).size.width > 1100) ? 0.75 : 1,
                ),
                scrollDirection: Axis.vertical,
                itemCount: savedOrders.length,
                itemBuilder: (context, i) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
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
                      //create order with table name
                      bloc.retrieveOrder(
                          savedOrders[i].orderName,
                          savedOrders[i].paymentType,
                          savedOrders[i].orderDetail,
                          savedOrders[i].discount,
                          savedOrders[i].tax,
                          Color(savedOrders[i].orderColor),
                          true,
                          savedOrders[i].id,
                          true,
                          savedOrders[i].orderType,
                          (savedOrders[i].client['Name'] == '' ||
                                  savedOrders[i].client['Name'] == null)
                              ? false
                              : true,
                          savedOrders[i].client);
                      widget.tableController.animateToPage(1,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.easeIn);
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                        child: Column(
                          children: [
                            //Name of order + time
                            (savedOrders[i].orderName == '')
                                ? Container()
                                : Text(
                                    '${savedOrders[i].orderName}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(
                                height:
                                    (savedOrders[i].orderName == '') ? 0 : 10),
                            //Items
                            (savedOrders[i].orderDetail == null ||
                                    savedOrders[i].orderDetail == [])
                                ? SizedBox()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        (savedOrders[i].orderDetail.length > 5)
                                            ? 5
                                            : savedOrders[i].orderDetail.length,
                                    itemBuilder: (context, x) {
                                      if ((savedOrders[i].orderDetail.length >
                                              5) &&
                                          x == 4) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '...',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            //Product and qty
                                            Expanded(
                                              flex: 10,
                                              child: Text(
                                                '${savedOrders[i].orderDetail[x]['Name']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            //Total
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                  'x${savedOrders[i].orderDetail[x]['Quantity']}',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                            Spacer(),
                            (savedOrders[i].orderType == 'Delivery')
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      //Icon
                                      IconButton(
                                          tooltip: 'Delivery',
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.directions_bike_outlined,
                                            color: Colors.greenAccent,
                                          ))
                                    ],
                                  )
                                : Container()
                          ],
                        )),
                  );
                },
              ),
            )),
        SizedBox(width: 20),

        //Button to add new
        Expanded(
            flex: 1,
            child: Container(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                onPressed: () {
                  bloc.retrieveOrder('', '', [], 0, 0, Colors.white, false, '',
                      true, 'Mostrador', false, {});
                  widget.tableController.animateToPage(1,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeIn);
                },
                child: Center(
                    child: Text('Crear nuevo',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400))),
              ),
            ))
      ],
    );
  }
}
