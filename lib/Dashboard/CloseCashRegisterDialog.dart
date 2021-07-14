import 'package:denario/Backend/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CloseCashRegisterDialog extends StatefulWidget {
  final String currentRegister;
  CloseCashRegisterDialog({this.currentRegister});

  @override
  _CloseCashRegisterDialogState createState() =>
      _CloseCashRegisterDialogState();
}

class _CloseCashRegisterDialogState extends State<CloseCashRegisterDialog> {
  int closeAmount;
  final controller = PageController(initialPage: 0);
  final int totalPages = 2;

  FocusNode nameNode;
  FocusNode amountNode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.35,
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
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    height: 75,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: TextFormField(
                      autofocus: true,
                      focusNode: amountNode,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 40),
                      validator: (val) => val.isEmpty
                          ? "No olvides agregar un monto inicial"
                          : null,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration.collapsed(
                        hintText: "0",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                      onChanged: (val) {
                        setState(() => closeAmount = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  //Button
                  Container(
                    height: 35.0,
                    child: RaisedButton(
                      color: Colors.black,
                      onPressed: () {
                        DatabaseService().closeCashRegister(
                            closeAmount, widget.currentRegister);
                        DatabaseService().recordOpenedRegister(false, '');

                        Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.all(0.0),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                        alignment: Alignment.center,
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
