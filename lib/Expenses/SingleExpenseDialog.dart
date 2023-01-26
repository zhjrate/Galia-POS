import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Expenses/ConfirmDeleteExpense.dart';
import 'package:denario/Models/DailyCash.dart';
import 'package:denario/Models/Expenses.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SingleExpenseDialog extends StatefulWidget {
  final String businessID;
  final Expenses expense;
  final CashRegister registerStatus;
  SingleExpenseDialog(this.expense, this.businessID, this.registerStatus);

  @override
  _SingleExpenseDialogState createState() => _SingleExpenseDialogState();
}

class _SingleExpenseDialogState extends State<SingleExpenseDialog> {
  final formatCurrency = new NumberFormat.simpleCurrency();
  bool editMethod = false;
  bool paymentMethodEdited = false;
  String paymentType;
  List availablePaymentTypes = [
    'Efectivo',
    'MercadoPago',
    'Tarjeta',
    'Por pagar'
  ];

  @override
  void initState() {
    paymentType = widget.expense.paymentType;
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
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.7,
          constraints: BoxConstraints(minHeight: 350, minWidth: 300),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Go Back
              Row(
                children: [
                  (widget.expense.reversed)
                      ? SizedBox()
                      : IconButton(
                          tooltip: 'Eliminar venta',
                          padding: EdgeInsets.all(2),
                          splashRadius: 18,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmDeleteExpense(
                                      widget.businessID,
                                      widget.expense,
                                      widget.registerStatus,
                                      dailyTransactions);
                                });
                          },
                          icon: Icon(Icons.delete),
                          iconSize: 20.0),
                  SizedBox(width: 5),
                  Container(
                      child: Text(
                    'Creado: ${DateFormat.MMMd().format(widget.expense.creationDate)}',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  )),
                  Spacer(),
                  Container(
                    alignment: Alignment(1.0, 0.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                        iconSize: 20.0),
                  ),
                ],
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
                      '${DateFormat.MMMd().format(widget.expense.date)} - ${DateFormat('HH:mm:ss').format(widget.expense.date)}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    )),
                    Spacer(),
                    //Name
                    Container(
                        child: Text(
                      widget.expense.vendor,
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
                'Gasto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.expense.items.length,
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
                                  child: Text((widget.expense.items[i].qty == 1)
                                      ? widget.expense.items[i].product
                                      : widget.expense.items[i].product +
                                          ' (${formatCurrency.format(widget.expense.items[i].price)} x ${widget.expense.items[i].qty})'),
                                ),
                                //Amount
                                Spacer(),
                                Text(
                                    '${formatCurrency.format(widget.expense.items[i].total)}'),
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
                    (widget.expense.paymentType == 'Por pagar' &&
                            editMethod == false)
                        ? // Pay Payable
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
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Center(
                                    child: Text('Marcar pagado'),
                                  ),
                                )),
                          )
                        : (editMethod)
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
                                '${widget.expense.paymentType}',
                                style: TextStyle(fontWeight: FontWeight.normal),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ))
                        : SizedBox(),

                    SizedBox(width: 10),
                    (widget.expense.usedCashfromRegister)
                        ? Tooltip(
                            message:
                                'Usó dinero de caja (${formatCurrency.format(widget.expense.amountFromRegister)})',
                            child: Icon(
                              Icons.fax,
                              color: Colors.grey,
                              size: 18,
                            ),
                          )
                        : SizedBox(),
                    Spacer(),
                    //Total
                    Container(
                        child: Text(
                      '${formatCurrency.format(widget.expense.total)}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            DatabaseService().markExpensePaid(
                                widget.businessID,
                                widget.expense.expenseID,
                                widget.expense.date.year.toString(),
                                widget.expense.date.month.toString(),
                                paymentType);

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
