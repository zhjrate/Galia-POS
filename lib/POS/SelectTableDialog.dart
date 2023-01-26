import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Tables.dart';
import 'package:denario/Models/User.dart';
import 'package:flutter/material.dart';

class SelectTableDialog extends StatefulWidget {
  final UserData userProfile;
  final TextEditingController orderNameController;
  final List<Tables> tables;
  SelectTableDialog(this.userProfile, this.orderNameController, this.tables);

  @override
  State<SelectTableDialog> createState() => _SelectTableDialogState();
}

class _SelectTableDialogState extends State<SelectTableDialog> {
  @override
  Widget build(BuildContext context) {
    if (widget.tables == null) {
      return Dialog();
    } else if (widget.tables.length == 0) {
      return SingleChildScrollView(
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: EdgeInsets.all(20),
                height: 500,
                width: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Text
                    Text(
                      'Ups!... No hay ninguna mesa para seleccionar',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Puedes agregar desde la vista de "mesas" disponible en la parte superior derecha de la pantalla inicial',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black45),
                    ),
                    SizedBox(height: 50),
                    Container(
                      width: 250,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Center(
                              child: Text('Volver',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)))),
                    )
                  ],
                ),
              )));
    }

    return SingleChildScrollView(
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 500,
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                          splashRadius: 5,
                          iconSize: 20.0),
                    ],
                  ),
                  SizedBox(height: 10),
                  //Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Abrir mesa',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  //lIST OF Products
                  Expanded(
                      child: Container(
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: 1,
                              ),
                              scrollDirection: Axis.vertical,
                              itemCount: widget.tables.length,
                              itemBuilder: (context, i) {
                                return ElevatedButton(
                                    onPressed: () {
                                      if (widget.tables[i].isOpen) {
                                        //retrieve order
                                        bloc.retrieveOrder(
                                            widget.tables[i].table,
                                            widget.tables[i].paymentType,
                                            widget.tables[i].orderDetail,
                                            widget.tables[i].discount,
                                            widget.tables[i].tax,
                                            Color(widget.tables[i].orderColor),
                                            true,
                                            'Mesa ${widget.tables[i].table}',
                                            false,
                                            'Mesa',
                                            (widget.tables[i].client['Name'] ==
                                                        '' ||
                                                    widget.tables[i]
                                                            .client['Name'] ==
                                                        null)
                                                ? false
                                                : true,
                                            widget.tables[i].client);
                                      } else {
                                        bloc.changeOrderType('Mesa');
                                        bloc.changeOrderName(
                                            '${widget.tables[i].table}');
                                        bloc.changeTableStatus(false);
                                        widget.orderNameController.text =
                                            widget.tables[i].table;
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: (widget.tables[i].isOpen)
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.greenAccent)
                                          : MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states
                                              .contains(MaterialState.hovered))
                                            return Colors.black12;
                                          if (states.contains(
                                                  MaterialState.focused) ||
                                              states.contains(
                                                  MaterialState.pressed))
                                            return Colors.black26;
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                    ),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.tables[i].table,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ]));
                              }))),
                ],
              ),
            )));
  }
}
