import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:denario/Models/Supplier.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/Suppliers/NewSupplier.dart';
import 'package:denario/Suppliers/SupplierDetails.dart';
import 'package:denario/Suppliers/SupplierSearchBar.dart';
import 'package:denario/Suppliers/SuppliersListDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SuppliersDesk extends StatefulWidget {
  const SuppliersDesk({Key key}) : super(key: key);

  @override
  State<SuppliersDesk> createState() => _SuppliersDeskState();
}

class _SuppliersDeskState extends State<SuppliersDesk> {
  String vendorName;
  String selectedVendor = '';
  bool showSearchOptions = false;
  TextEditingController searchController = new TextEditingController();

  void selectVendor(Supplier vendor) {
    setState(() {
      selectedVendor = vendor.name;
      searchController.text = vendor.name;
      showSearchOptions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserData>(context);
    final categoriesProvider = Provider.of<CategoryList>(context);
    final highLevelMapping = Provider.of<HighLevelMapping>(context);

    return Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              //Info
              Column(children: [
                SizedBox(height: 75),
                StreamProvider<Supplier>.value(
                    value: DatabaseService().supplierfromSnapshot(
                        userProfile.activeBusiness, selectedVendor),
                    initialData: null,
                    child: SupplierDetails(
                        selectedVendor,
                        userProfile.activeBusiness,
                        categoriesProvider,
                        highLevelMapping))
              ]),
              //Search and NEW
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Search bar
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 400,
                        height: 45,
                        child: TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          cursorColor: Colors.grey,
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(2),
                              iconSize: 14,
                              splashRadius: 15,
                              onPressed: () {
                                setState(() {
                                  showSearchOptions = false;
                                  searchController.text = '';
                                });
                              },
                              icon: Icon(Icons.close),
                              color: Colors.black,
                            ),
                            hintText: 'Buscar',
                            focusColor: Colors.black,
                            hintStyle:
                                TextStyle(color: Colors.black45, fontSize: 14),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              borderSide: new BorderSide(
                                color: Colors.grey[350],
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                              borderSide: new BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              vendorName = value;
                              if (value != '') {
                                showSearchOptions = true;
                              } else {
                                showSearchOptions = false;
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 5),
                      (showSearchOptions)
                          ? StreamProvider<List<Supplier>>.value(
                              value: DatabaseService().suppliersList(
                                  userProfile.activeBusiness,
                                  vendorName.toLowerCase()),
                              initialData: null,
                              child: SupplierSearchBar(selectVendor),
                            )
                          : SizedBox()
                    ],
                  ),
                  SizedBox(width: 20),
                  //Watch Entire List of Suppliers
                  IconButton(
                      tooltip: 'Ver lista de proveedores',
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: ((context) =>
                                StreamProvider<List<Supplier>>.value(
                                  value: DatabaseService().allSuppliersList(
                                      userProfile.activeBusiness),
                                  initialData: null,
                                  child: SuppliersListDialog(selectVendor),
                                )));
                      },
                      icon: Icon(
                        Icons.list_rounded,
                        color: Colors.black,
                      )),
                  Spacer(),
                  //New Supplier
                  Container(
                    height: 45,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.greenAccent),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.green[300];
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed))
                                return Colors.lightGreenAccent;
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewSupplier(
                                      userProfile.activeBusiness,
                                      categoriesProvider,
                                      highLevelMapping)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Nuevo proveedor',
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
