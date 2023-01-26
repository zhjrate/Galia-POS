import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveOrders extends StatelessWidget {
  final TextEditingController orderNameController;
  ActiveOrders(this.orderNameController);
  @override
  Widget build(BuildContext context) {
    final savedOrders = Provider.of<List<SavedOrders>>(context);

    if (savedOrders == null || savedOrders.length == 0) {
      return SizedBox();
    }

    return Column(children: [
      //Saved Orders
      Container(
        height: 40,
        width: double.infinity,
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: savedOrders.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Tooltip(
                  message: savedOrders[i].orderName,
                  child: InkWell(
                    onTap: () {
                      bloc.retrieveOrder(
                          savedOrders[i].orderName,
                          savedOrders[i].paymentType,
                          savedOrders[i].orderDetail,
                          savedOrders[i].discount,
                          savedOrders[i].tax,
                          Color(savedOrders[i].orderColor),
                          true,
                          savedOrders[i].id,
                          (savedOrders[i].isTable) ? false : true,
                          savedOrders[i].orderType,
                          (savedOrders[i].client['Name'] == '' ||
                                  savedOrders[i].client['Name'] == null)
                              ? false
                              : true,
                          savedOrders[i].client);
                      orderNameController.text = savedOrders[i].orderName;
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(savedOrders[i].orderColor)),
                      child: Center(
                          child: Text(
                        (savedOrders[i].orderName == '')
                            ? ''
                            : savedOrders[i].orderName[0],
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )),
                    ),
                  ),
                ),
              );
            }),
      ),
      SizedBox(height: (savedOrders.length == 0) ? 0 : 3),
      (savedOrders.length == 0)
          ? Container()
          : Divider(thickness: 0.5, indent: 0, endIndent: 0),
    ]);
  }
}
