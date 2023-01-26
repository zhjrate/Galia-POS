import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/Models/User.dart';
import 'package:denario/No%20POS%20Sales/ProductSelection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectItemDialog extends StatefulWidget {
  final UserData userProfile;
  SelectItemDialog(this.userProfile);

  @override
  State<SelectItemDialog> createState() => _SelectItemDialogState();
}

class _SelectItemDialogState extends State<SelectItemDialog> {
  bool categoryisSelected = false;
  String selectedCategory = '';
  String product = '';
  int price = 0;

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryList>(context);

    if (categoriesProvider == null) {
      return Dialog();
    }

    List categories = categoriesProvider.categoryList;

    if (!categoryisSelected) {
      return SingleChildScrollView(
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: EdgeInsets.all(20),
                height: 500,
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    //Text
                    Text(
                      "Selecciona una Categoría",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 30),
                    //lIST OF Categories
                    Expanded(
                      child: Container(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 15.0,
                              childAspectRatio: 3,
                            ),
                            scrollDirection: Axis.vertical,
                            itemCount: categories.length,
                            itemBuilder: (context, i) {
                              return ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedCategory = categories[i];
                                      categoryisSelected = true;
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
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
                                  child: Center(
                                    child: Text(
                                      categories[i],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ));
                            }),
                      ),
                    )
                  ],
                ),
              )));
    } else {
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                            splashRadius: 5,
                            iconSize: 20.0),
                        Spacer(),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                            splashRadius: 5,
                            iconSize: 20.0),
                      ],
                    ),
                    //Text
                    Text(
                      'Producto/Servicio',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black45),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: TextFormField(
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            cursorColor: Colors.grey,
                            autofocus: true,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
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
                              setState(() => product = val);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              bloc.addToCart({
                                'Name': product,
                                'Category': selectedCategory,
                                'Price': 0,
                                'Quantity': 1,
                                'Total Price': 0
                              });
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 50,
                              child: Center(
                                  child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 30,
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    //lIST OF Products
                    Expanded(
                        child: Container(
                            child: StreamProvider<List<Products>>.value(
                                initialData: [],
                                value: DatabaseService().productList(
                                    selectedCategory,
                                    widget.userProfile.activeBusiness),
                                child: ProductSelection()))),
                  ],
                ),
              )));
    }
  }
}
