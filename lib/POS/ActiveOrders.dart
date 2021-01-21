import 'dart:math';


import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/SavedOrders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveOrders extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final savedOrders = Provider.of<List<SavedOrders>>(context);

    if(savedOrders == null){
      return SizedBox();
    }

    return Expanded(
      child: Container(
        height: 50,
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: savedOrders.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: InkWell(
                  onTap: (){
                    bloc.retrieveOrder(
                      savedOrders[i].orderName,
                      savedOrders[i].paymentType,
                      savedOrders[i].orderDetail,
                      savedOrders[i].subTotal,
                      savedOrders[i].discount,
                      savedOrders[i].tax,
                      savedOrders[i].total,
                    );
                    
                    DatabaseService().deleteOrder(savedOrders[i].id);
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(savedOrders[i].orderColor)),
                    child: Center(child: Text(
                      (savedOrders[i].orderName == '') ? '' : savedOrders[i].orderName[0],
                      style: TextStyle(
                        color: Colors.white, fontSize: 14),
                    )),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
