import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog({Key key}) : super(key: key);

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  bool fixedDiscount;
  double discount;

  double totalAmount(snapshot) {
    double total = 0;
    snapshot.data['Items'].forEach((x) {
      total = total + (x['Price'] * x['Quantity']);
    });

    return total;
  }

  @override
  void initState() {
    discount = 0;
    fixedDiscount = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.ticketItems,
        builder: (context, snapshot) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              width: 350,
              height: 350,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                          iconSize: 20.0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Title
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 5),
                      child: Text(
                        "Aplica un descuento",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Fixed or percentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Fixed
                        Container(
                          width: 75,
                          height: 45,
                          child: Tooltip(
                            message: 'Monto fijo',
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (fixedDiscount)
                                    ? Colors.greenAccent
                                    : Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  fixedDiscount = true;
                                });
                                bloc.setDiscountAmount(0);
                              },
                              child: Center(
                                  child: Text('\$',
                                      style: TextStyle(color: Colors.black))),
                            ),
                          ),
                        ),
                        //%
                        Container(
                          width: 75,
                          height: 45,
                          child: Tooltip(
                            message: 'Porcentual',
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (fixedDiscount)
                                    ? Colors.white
                                    : Colors.greenAccent,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8)),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  fixedDiscount = false;
                                  discount = 0;
                                });
                                bloc.setDiscountAmount(0);
                              },
                              child: Center(
                                  child: Text('%',
                                      style: TextStyle(color: Colors.black))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    //Amount
                    (fixedDiscount)
                        ? Container(
                            width: 150,
                            child: Center(
                              child: TextFormField(
                                key: ValueKey(1),
                                autofocus: true,
                                inputFormatters: [
                                  CurrencyTextInputFormatter(
                                    name: '\$',
                                    locale: 'en',
                                    decimalDigits: 2,
                                  ),
                                ],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onFieldSubmitted: ((value) {
                                  Navigator.pop(context);
                                }),
                                decoration: InputDecoration(
                                  label: Text(''),
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent[700],
                                      fontSize: 12),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(12.0),
                                    borderSide: new BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(12.0),
                                    borderSide: new BorderSide(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                cursorColor: Colors.grey,
                                initialValue: (discount > 0)
                                    ? discount.toString()
                                    : '\$0.00',
                                onChanged: (val) {
                                  if (val == null || val == '') {
                                    setState(() {
                                      discount = 0;
                                    });
                                  } else {
                                    setState(() {
                                      discount = double.tryParse(
                                          (val.substring(1))
                                              .replaceAll(',', ''));
                                      bloc.setDiscountAmount(discount);
                                    });
                                  }
                                },
                              ),
                            ),
                          )
                        : Container(
                            width: 150,
                            child: Center(
                              child: TextFormField(
                                key: ValueKey(2),
                                initialValue:
                                    snapshot.data['Discount'].toString(),
                                autofocus: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  suffixText: '%',
                                  suffixStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  label: Text(''),
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  errorStyle: TextStyle(
                                      color: Colors.redAccent[700],
                                      fontSize: 12),
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(12.0),
                                    borderSide: new BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(12.0),
                                    borderSide: new BorderSide(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                cursorColor: Colors.grey,
                                onFieldSubmitted: ((value) {
                                  Navigator.pop(context);
                                }),
                                onChanged: (val) {
                                  setState(() {
                                    discount = totalAmount(snapshot) *
                                        (double.tryParse((val)) / 100);
                                  });

                                  bloc.setDiscountAmount(discount);
                                },
                              ),
                            ),
                          ),
                    (fixedDiscount)
                        ? Container()
                        : SizedBox(
                            height: 15,
                          ),
                    (fixedDiscount)
                        ? Container()
                        : Text(
                            'Descuento: \$${snapshot.data['Discount']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    //Button
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Text('Guardar',
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
