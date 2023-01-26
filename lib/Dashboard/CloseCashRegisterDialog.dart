import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CloseCashRegisterDialog extends StatefulWidget {
  final String currentRegister;
  CloseCashRegisterDialog({this.currentRegister});

  @override
  _CloseCashRegisterDialogState createState() =>
      _CloseCashRegisterDialogState();
}

class _CloseCashRegisterDialogState extends State<CloseCashRegisterDialog> {
  double closeAmount = 0;
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
          child: Container(
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
                      "Monto en caja al cierre",
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
                      setState(() => closeAmount = double.tryParse(
                          (val.substring(1)).replaceAll(',', '')));
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
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onPressed: () {
                        DatabaseService().closeCashRegister(
                            userProfile.activeBusiness,
                            closeAmount,
                            widget.currentRegister);
                        DatabaseService().recordOpenedRegister(
                            userProfile.activeBusiness, false, '');

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "CERRAR CAJA",
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
        ),
      ),
    );
  }
}
