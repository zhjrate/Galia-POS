import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:denario/Backend/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../Backend/Ticket.dart';

class ScheduleSaleDialog extends StatefulWidget {
  final double total;
  final dynamic items;

  final double subTotal;
  final double discount;
  final double tax;
  final String businessID;
  final String orderName;
  final clearControllers;

  ScheduleSaleDialog(this.businessID, this.total, this.discount, this.tax,
      this.subTotal, this.items, this.orderName, this.clearControllers);

  @override
  State<ScheduleSaleDialog> createState() => _ScheduleSaleDialogState();
}

class _ScheduleSaleDialogState extends State<ScheduleSaleDialog> {
  DateTime selectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 00);
  String orderName;
  int phone = 0;
  String email = '';
  double initialPayment = 0;
  String invoiceNo;
  String address;
  bool delivery = false;
  String note = '';
  final FocusNode _clientNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _initialPaymentNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _noteNode = FocusNode();
  TextEditingController clientController;
  final _formKey = GlobalKey<FormState>();

  void openSchedule() async {
    DateTime pickedDate = await showDatePicker(
        context: context,
        helpText: 'Día de retiro',
        confirmText: 'Guardar',
        cancelText: 'Cancelar',
        initialDate: DateTime.now().add(Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 150)),
        builder: ((context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.black, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, // button text color
                  ),
                ),
              ),
              child: child);
        }));
    setState(() {
      if (pickedDate != null) {
        selectedDate =
            DateTime(pickedDate.year, pickedDate.month, pickedDate.day, 10);
      }
    });
  }

  void openTime() async {
    TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        helpText: 'Horario de retiro',
        confirmText: 'Guardar',
        cancelText: 'Cancelar',
        hourLabelText: 'Hora',
        minuteLabelText: 'Minuto',
        initialTime: TimeOfDay(hour: 10, minute: 00),
        builder: ((context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.black, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black, // button text color
                  ),
                ),
              ),
              child: child);
        }));
    setState(() {
      if (pickedTime != null) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, pickedTime.hour, pickedTime.minute);
      }
    });
  }

  @override
  void initState() {
    invoiceNo = '00' +
        (DateTime.now().day).toString() +
        (DateTime.now().month).toString() +
        (DateTime.now().year).toString() +
        (DateTime.now().hour).toString() +
        (DateTime.now().minute).toString() +
        (DateTime.now().millisecond).toString();

    orderName = widget.orderName;
    clientController = new TextEditingController(text: orderName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 550,
            width: 650,
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Close
                  Container(
                    alignment: Alignment(1.0, 0.0),
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                        iconSize: 20.0),
                  ),
                  //Titulo
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Center(
                        child: Text(
                      'Agendar venta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    )),
                  ]),
                  SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Nombre (inicializar con el nombre de la pantalla anterior)
                            Container(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                cursorColor: Colors.grey,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return "Agregá un nombre";
                                  } else {
                                    return null;
                                  }
                                },
                                focusNode: _clientNode,
                                controller: clientController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  label: Text(
                                    'Cliente',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black45),
                                  ),
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
                                onFieldSubmitted: (term) {
                                  _clientNode.unfocus();
                                  openSchedule();
                                },
                                onChanged: (val) {
                                  setState(() {
                                    orderName = val;
                                    clientController.text = val;
                                    clientController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                clientController.text.length));
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            //Fecha
                            Text(
                              'Agendar para:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Row(
                                children: [
                                  //Fecha
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(selectedDate),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            child: IconButton(
                                              splashRadius: 1,
                                              onPressed: openSchedule,
                                              padding: EdgeInsets.all(0),
                                              tooltip: 'Seleccionar fecha',
                                              iconSize: 18,
                                              icon: Icon(Icons.calendar_month),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  //Time
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Text(
                                            DateFormat('HH:mm')
                                                .format(selectedDate),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            child: IconButton(
                                              splashRadius: 1,
                                              onPressed: openTime,
                                              padding: EdgeInsets.all(0),
                                              tooltip: 'Horario',
                                              iconSize: 18,
                                              icon: Icon(Icons.av_timer),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            // Tlf y mail
                            Text(
                              'Contacto',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: Row(
                                children: [
                                  //Telefono
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      focusNode: phoneNode,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      autofocus: true,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(8),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      cursorColor: Colors.grey,
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 2, 10),
                                            child: Text(('(11) '))),
                                        hintText: 'Whatsapp',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(12.0),
                                          borderSide: new BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        errorBorder: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(12.0),
                                          borderSide: new BorderSide(
                                            color: Colors.red,
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
                                      onFieldSubmitted: (val) {
                                        phoneNode.unfocus();
                                        _emailNode.requestFocus();
                                      },
                                      onChanged: (val) {
                                        setState(() =>
                                            phone = int.parse('11' + val));
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  //Mail
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      cursorColor: Colors.grey,
                                      focusNode: _emailNode,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        hintText: 'email',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        prefixIcon: Icon(
                                          Icons.mail_outline,
                                          color: Colors.grey,
                                        ),
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
                                      onFieldSubmitted: (term) {
                                        _emailNode.unfocus();
                                        _initialPaymentNode.requestFocus();
                                      },
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            //Initail Payment
                            Row(
                              children: [
                                Text(
                                  'Delivery',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black45),
                                ),
                                (delivery)
                                    ? IconButton(
                                        iconSize: 14,
                                        splashRadius: 5,
                                        padding: EdgeInsets.all(0),
                                        onPressed: () {
                                          setState(() {
                                            delivery = false;
                                          });
                                        },
                                        icon: Icon(Icons.check_box_outlined))
                                    : SizedBox(),
                                Spacer(),
                                Text(
                                  'Pago inicial/seña:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                            SizedBox(height: (delivery) ? 0 : 10),
                            Row(
                              children: [
                                //Delivery
                                Expanded(
                                    child: (delivery)
                                        ? TextFormField(
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                            validator: (val) =>
                                                (delivery && val.isEmpty)
                                                    ? "Agrega una dirección"
                                                    : null,
                                            cursorColor: Colors.grey,
                                            focusNode: _addressNode,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                              hintText: 'Dirección',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                              prefixIcon: Icon(
                                                Icons.location_pin,
                                                color: Colors.grey,
                                              ),
                                              errorStyle: TextStyle(
                                                  color: Colors.redAccent[700],
                                                  fontSize: 12),
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        12.0),
                                                borderSide: new BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        12.0),
                                                borderSide: new BorderSide(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            onFieldSubmitted: (term) {
                                              _addressNode.unfocus();
                                              _initialPaymentNode
                                                  .requestFocus();
                                            },
                                            onChanged: (val) {
                                              setState(() => address = val);
                                            },
                                          )
                                        : Container(
                                            alignment: Alignment.topLeft,
                                            width: 75,
                                            child: IconButton(
                                                splashRadius: 10,
                                                onPressed: () {
                                                  setState(() {
                                                    delivery = true;
                                                  });
                                                },
                                                icon: Icon(Icons
                                                    .check_box_outline_blank)),
                                          )),
                                SizedBox(width: 10),
                                //Initial Pay
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    focusNode: _initialPaymentNode,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    autofocus: true,
                                    initialValue: '\$0.00',
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "El monto no debe estar vacío";
                                      } else {
                                        return null;
                                      }
                                    },
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(
                                        name: '\$',
                                        locale: 'en',
                                        decimalDigits: 2,
                                      ),
                                    ],
                                    cursorColor: Colors.grey,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.attach_money,
                                        color: Colors.grey,
                                      ),
                                      hintText: 'Pago inicial',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0),
                                        borderSide: new BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      errorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0),
                                        borderSide: new BorderSide(
                                          color: Colors.red,
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
                                    onFieldSubmitted: (val) {
                                      _initialPaymentNode.unfocus();
                                    },
                                    onChanged: (val) {
                                      setState(() => initialPayment =
                                          double.tryParse((val.substring(1))
                                              .replaceAll(',', '')));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            //Nota
                            Text(
                              'Nota',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black45),
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: TextFormField(
                                maxLines: 4,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                cursorColor: Colors.grey,
                                focusNode: _noteNode,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: 'Agrega una nota',
                                  hintStyle: TextStyle(fontSize: 14),
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
                                onFieldSubmitted: (term) {
                                  _noteNode.unfocus();
                                },
                                onChanged: (val) {
                                  setState(() {
                                    note = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Delivery / Takeaway => Si es delivery agregar direccion
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //Agendar
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
                              if (_formKey.currentState.validate()) {
                                DatabaseService().scheduleSale(
                                    widget.businessID,
                                    invoiceNo,
                                    widget.subTotal,
                                    widget.discount,
                                    widget.tax,
                                    widget.total,
                                    widget.items,
                                    orderName,
                                    selectedDate,
                                    {
                                      'Name': orderName,
                                      'Address': address,
                                      'Phone': phone,
                                      'email': email,
                                    },
                                    initialPayment,
                                    (widget.total - initialPayment),
                                    note);
                                /////////////////Clear Variables
                                bloc.removeAllFromCart();
                                widget.clearControllers();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Center(
                                child: Text('Agendar venta'),
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
