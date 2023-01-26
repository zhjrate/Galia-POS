import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Dashboard/ConfirmDeleteOrder.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Sales.dart';
import 'package:denario/Models/Stats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SingleSaleDialog extends StatefulWidget {
  final Sales sale;
  final String businessID;
  final String docID;
  final List paymentTypes;
  final CashRegister registerStatus;

  SingleSaleDialog(this.sale, this.businessID, this.docID, this.paymentTypes,
      this.registerStatus);

  @override
  _SingleSaleDialogState createState() => _SingleSaleDialogState();
}

class _SingleSaleDialogState extends State<SingleSaleDialog> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  bool editMethod = false;
  bool paymentMethodEdited = false;
  String paymentType;
  List availablePaymentTypes = [];

  @override
  void initState() {
    paymentType = widget.sale.paymentType;
    widget.paymentTypes.forEach((x) => availablePaymentTypes.add(x['Type']));
    availablePaymentTypes.add('Por Cobrar');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyTransactions = Provider.of<DailyTransactions>(context);

    return SingleChildScrollView(
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.7,
          constraints: BoxConstraints(minHeight: 350, minWidth: 300),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Go Back
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                //Delete
                (widget.sale.reversed)
                    ? Text('Venta anulada', style: TextStyle(color: Colors.red))
                    : IconButton(
                        tooltip: 'Eliminar venta',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StreamProvider<MonthlyStats>.value(
                                  initialData: null,
                                  value: DatabaseService()
                                      .monthlyStatsfromSnapshot(
                                          widget.businessID),
                                  child: ConfirmDeleteOrder(
                                      widget.businessID,
                                      widget.sale,
                                      widget.registerStatus,
                                      dailyTransactions),
                                );
                              });
                        },
                        icon: Icon(Icons.delete),
                        iconSize: 20.0),
                Spacer(),
                //Close
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    iconSize: 20.0),
              ]),
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
              //Payment Method
              SizedBox(height: 15),
              (widget.sale.paymentType == 'Por Cobrar' && editMethod == false)
                  ? // Pay Recivable
                  Container(
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              editMethod = true;
                            });
                            // DatabaseService().editSalePaymentMethod(
                            //     widget.businessID,
                            //     widget.sale.date.year,
                            //     widget.sale.date.month,
                            //     widget.sale.docID,
                            //     '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Center(
                              child: Text('Marcar cobrado'),
                            ),
                          )),
                    )
                  : Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //Payment Method
                          (editMethod)
                              ? Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: DropdownButton(
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    hint: Text(
                                      paymentType,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.grey[700]),
                                    ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.grey[700]),
                                    value: paymentType,
                                    items: availablePaymentTypes.map((x) {
                                      return new DropdownMenuItem(
                                        value: x,
                                        child: new Text(x),
                                        onTap: () {
                                          setState(() {
                                            paymentType = x;
                                            paymentMethodEdited = true;
                                          });
                                        },
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        paymentType = newValue;
                                        paymentMethodEdited = true;
                                      });
                                    },
                                  ))
                              : Container(
                                  child: Text(
                                  '${widget.sale.paymentType}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                )),
                          SizedBox(width: 5),
                          (editMethod)
                              ? TextButton(
                                  onPressed: (() {
                                    setState(() {
                                      editMethod = false;
                                      paymentMethodEdited = false;
                                    });
                                  }),
                                  child: Text(
                                    'Dejar de Editar',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      editMethod = true;
                                    });
                                    // DatabaseService().editSalePaymentMethod(
                                    //     widget.businessID, widget.docID, '');
                                  },
                                  icon: Icon(Icons.edit, size: 16),
                                  splashRadius: 18,
                                ),
                          Spacer(),
                          //Total
                          Container(
                              child: Text(
                            '${formatCurrency.format(widget.sale.total)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                        ],
                      ),
                    ),
              //Save new payment method
              (paymentMethodEdited) ? SizedBox(height: 15) : SizedBox(),
              (paymentMethodEdited)
                  ? Container(
                      height: 45,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.greenAccent),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.grey[300];
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed))
                                  return Colors.grey[300];
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            DatabaseService().editSalePaymentMethod(
                                widget.businessID,
                                widget.sale.date.year,
                                widget.sale.date.month,
                                widget.docID,
                                paymentType);

                            ///////////////////////////Register in Daily Transactions/////

                            if (widget.sale.cashRegister ==
                                widget.registerStatus.registerName) {
                              //Update sales by medium
                              List salesByMedium =
                                  dailyTransactions.salesByMedium;

                              bool listUpdated = false;

                              for (var map in salesByMedium) {
                                if (map["Type"] == widget.sale.paymentType) {
                                  map['Amount'] =
                                      map['Amount'] - widget.sale.total;
                                } else if ((map["Type"] == paymentType)) {
                                  map['Amount'] =
                                      map['Amount'] + widget.sale.total;
                                  listUpdated = true;
                                }
                              }
                              //If payment method was not in list
                              if (!listUpdated) {
                                salesByMedium.add({
                                  'Type': paymentType,
                                  'Amount': widget.sale.total
                                });
                              }

                              DatabaseService().updateSalesinCashRegister(
                                  widget.businessID,
                                  dailyTransactions.openDate.toString(),
                                  dailyTransactions.sales,
                                  salesByMedium,
                                  dailyTransactions.dailyTransactions);
                            }

                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Text(
                                  'Guardar cambios',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
