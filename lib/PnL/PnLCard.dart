import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PnLCard extends StatefulWidget {
  final List pnlAccountGroups;
  final Map<dynamic, dynamic> pnlMapping;
  final AsyncSnapshot<dynamic> snapshot;

  const PnLCard(this.pnlAccountGroups, this.pnlMapping, this.snapshot,
      {Key key})
      : super(key: key);

  @override
  State<PnLCard> createState() => _PnLCardState();
}

class _PnLCardState extends State<PnLCard> {
  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.grey[350],
            offset: Offset(0.0, 0.0),
            blurRadius: 10.0,
          )
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.pnlAccountGroups.length,
        itemBuilder: (context, i) {
          double categoryAmount;

          try {
            categoryAmount =
                widget.snapshot.data['${widget.pnlAccountGroups[i]}'];
          } catch (e) {
            categoryAmount = 0;
          }

          return ExpansionTile(
            iconColor: Colors.greenAccent,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.pnlAccountGroups[i],
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Spacer(),
                  //Monto
                  Text('${formatCurrency.format(categoryAmount)}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                ],
              ),
            ),
            children: [
              //Sub Accounts
              Container(
                width: MediaQuery.of(context).size.width * 0.28,
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget
                        .pnlMapping['${widget.pnlAccountGroups[i]}'].length,
                    itemBuilder: (context, x) {
                      double itemAmount;

                      try {
                        itemAmount = widget.snapshot.data[
                            '${widget.pnlMapping[widget.pnlAccountGroups[i]][x]}'];
                      } catch (e) {
                        itemAmount = 0;
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          //Cuenta
                          Text(
                              '${widget.pnlMapping[widget.pnlAccountGroups[i]][x]}'),
                          Spacer(),
                          //Monto
                          Text('${formatCurrency.format(itemAmount)}'),
                        ]),
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
