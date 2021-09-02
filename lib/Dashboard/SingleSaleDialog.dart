import 'package:denario/Models/Sales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleSaleDialog extends StatefulWidget {
  final Sales sale;

  SingleSaleDialog({this.sale});

  @override
  _SingleSaleDialogState createState() => _SingleSaleDialogState();
}

class _SingleSaleDialogState extends State<SingleSaleDialog> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.7,
          constraints: BoxConstraints(minHeight: 350, minWidth: 300),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Go Back
              Container(
                alignment: Alignment(1.0, 0.0),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    iconSize: 20.0),
              ),
              SizedBox(height: 15),
              //Time and Name
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    //Time and date
                    Container(
                        child: Text(
                      DateFormat.MMMd().format(widget.sale.date).toString() +
                          " - " +
                          DateFormat('HH:mm:ss')
                              .format(widget.sale.date)
                              .toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    )),
                    Spacer(),
                    //Name
                    Container(
                        child: Text(
                      (widget.sale.orderName == '')
                          ? 'Nombre sin agregar'
                          : widget.sale.orderName,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              //Ticket
              Container(
                  child: Text(
                'Ticket',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.sale.soldItems.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Name
                                Container(
                                  constraints: BoxConstraints(maxWidth: 250),
                                  child: Text((widget.sale.soldItems[i].qty ==
                                          1)
                                      ? widget.sale.soldItems[i].product
                                      : widget.sale.soldItems[i].product +
                                          ' (${formatCurrency.format(widget.sale.soldItems[i].price)} x ${widget.sale.soldItems[i].qty})'),
                                ),
                                //Amount
                                Spacer(),
                                Text(
                                    '${formatCurrency.format(widget.sale.soldItems[i].total)}'),
                              ]),
                        );
                      }),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Payment Method
                    Container(
                        child: Text(
                      '${widget.sale.paymentType}',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    )),
                    Spacer(),
                    //Total
                    Container(
                        child: Text(
                      '${formatCurrency.format(widget.sale.total)}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
