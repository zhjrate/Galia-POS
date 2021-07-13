import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final expenses = Provider.of<List<Expenses>>(context);
    final screen = MediaQuery.of(context).size;

    return Container(
      width: screen.width * 0.4,
      child: ListView.builder(
        itemCount: (expenses.length > 6) ? 6 : expenses.length,
        shrinkWrap: true,
        reverse: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          return Container(
            height: 60,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Fecha
                Container(
                  child: Text(
                    DateFormat.MMMd().format(expenses[i].date).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                SizedBox(width:10), 
                //Detail
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      //Desc
                      Container(child: Text('${expenses[i].product}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400
                        ),
                      )),
                      SizedBox(height:5),
                      //Vendor + Cat
                      Container(child: Text(
                        '${expenses[i].vendor} • ${expenses[i].category}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      )),
                    ]
                  ),
                ),
                SizedBox(width:10),
                //Cost Type
                Container(
                  child: Text('${expenses[i].costType}',
                  style: TextStyle(                  
                    fontWeight: FontWeight.w500
                  ),
                )),               
                SizedBox(width:10),
                //Total
                Container(
                  child: Text('\$${expenses[i].total}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                  ))),
              ], 
            ),
          );
        }
      ),
    );
  }
}