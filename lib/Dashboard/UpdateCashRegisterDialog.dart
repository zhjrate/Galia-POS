import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UpdateCashRegisterDialog extends StatefulWidget {
  final String currentRegister;
  final String transactionType;
  final double transactionAmount;
  final double currentTransactions;

  UpdateCashRegisterDialog(
      {this.currentRegister,
      this.transactionType,
      this.transactionAmount,
      this.currentTransactions});

  @override
  _UpdateCashRegisterDialogState createState() =>
      _UpdateCashRegisterDialogState();
}

class _UpdateCashRegisterDialogState extends State<UpdateCashRegisterDialog> {
  double amount;
  String motive;
  Map registerTransactionDetails = {};
  final controller = PageController(initialPage: 0);
  final int totalPages = 2;

  FocusNode nameNode;
  FocusNode amountNode;

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserData>(context);
    return SingleChildScrollView(
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.35,
          constraints: BoxConstraints(minHeight: 350, minWidth: 200),
          child: PageView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                //Amount
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Go Back
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close),
                              iconSize: 20.0),
                        ),
                        //Ttitle
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Registrar ${widget.transactionType}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        //Amount
                        TextFormField(
                          autofocus: true,
                          focusNode: amountNode,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 40),
                          initialValue: '\$0.00',
                          validator: (val) =>
                              val.isEmpty ? "Agrega un monto válido" : null,
                          inputFormatters: <TextInputFormatter>[
                            CurrencyTextInputFormatter(
                              name: '\$',
                              locale: 'en',
                              decimalDigits: 2,
                            ),
                          ],
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              borderSide: new BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              borderSide: new BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              amount = double.tryParse(
                                  (val.substring(1)).replaceAll(',', ''));
                              registerTransactionDetails['Amount'] = amount;
                              registerTransactionDetails['Type'] =
                                  widget.transactionType;
                              registerTransactionDetails['Motive'] =
                                  widget.transactionType;
                            });
                          },
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        //Button
                        Container(
                          height: 35.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: Size(300, 50),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            onPressed: () {
                              controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                              amountNode.unfocus();
                              nameNode.requestFocus();
                            },
                            child: Text(
                              "SIGUIENTE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),

                //Comment
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Go Back
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close),
                              iconSize: 20.0),
                        ),
                        //Ttitle
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Motivo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        //Motive
                        TextFormField(
                          focusNode: nameNode,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 24),
                          autofocus: true,
                          maxLines: 2,
                          validator: (val) => val.isEmpty
                              ? "No olvides agregar un motivo"
                              : null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(45)
                          ],
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            label: Text('Motivo'),
                            labelStyle:
                                TextStyle(color: Colors.grey, fontSize: 12),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              borderSide: new BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              borderSide: new BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              motive = val;
                              registerTransactionDetails['Motive'] = motive;
                            });
                          },
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        //Button
                        Container(
                          height: 35.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: Size(300, 50),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            onPressed: () {
                              double totalTransactionAmount =
                                  widget.transactionAmount + amount;
                              double totalTransactions = 0.0;

                              if (widget.transactionType == 'Egresos') {
                                totalTransactions =
                                    widget.currentTransactions - amount;
                              } else {
                                totalTransactions =
                                    widget.currentTransactions + amount;
                              }

                              registerTransactionDetails['Time'] =
                                  DateTime.now();

                              DatabaseService().updateCashRegister(
                                  userProfile.activeBusiness,
                                  widget.currentRegister,
                                  widget.transactionType,
                                  totalTransactionAmount,
                                  totalTransactions,
                                  registerTransactionDetails);

                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "REGISTRAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
