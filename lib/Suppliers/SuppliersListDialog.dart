import 'package:denario/Models/Supplier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuppliersListDialog extends StatelessWidget {
  final selectVendor;
  const SuppliersListDialog(this.selectVendor, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suppliers = Provider.of<List<Supplier>>(context);

    if (suppliers == null) {
      return Container();
    }

    return SingleChildScrollView(
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            width: 600,
            height: MediaQuery.of(context).size.height * 0.65,
            padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20),
            child: Column(children: [
              //Go back
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 150,
                  alignment: Alignment(1.0, 0.0),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                      iconSize: 20.0),
                ),
              ),
              //Title
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 150,
                  child: Text(
                    "Proveedores",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(
                indent: 1,
                endIndent: 1,
                color: Colors.grey,
                thickness: 0.5,
              ),
              SizedBox(height: 20),
              //List of  Suppliers
              Expanded(
                  child: (suppliers == null)
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, i) {
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 35,
                                  color: Colors.grey[300],
                                ));
                          })
                      : (suppliers.length > 0)
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: suppliers.length,
                              itemBuilder: (context, i) {
                                return TextButton(
                                  onPressed: () {
                                    selectVendor(suppliers[i]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //Name
                                          Container(
                                            width: 150,
                                            child: Text(suppliers[i].name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          ),
                                          Spacer(),
                                          //Cost Type (from List)
                                          Container(
                                            width: 150,
                                            child: Text(
                                              (suppliers[i]
                                                          .costTypeAssociated
                                                          .length >
                                                      0)
                                                  ? suppliers[i]
                                                      .costTypeAssociated[0]
                                                  : 'Sin costo asociado',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                          Spacer(),
                                          //Phone
                                          Container(
                                            width: 150,
                                            child: Text(
                                              (suppliers[i].phone != null &&
                                                      suppliers[i].phone != 0)
                                                  ? suppliers[i]
                                                      .phone
                                                      .toString()
                                                  : 'Teléfono sin agregar',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ]),
                                  ),
                                );
                              })
                          : Center(
                              child: Text('No hay proveedores para mostrar'),
                            ))
            ]),
          )),
    );
  }
}
