import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<List<Products>>(context);

    return GridView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          childAspectRatio: 3,
        ),
        scrollDirection: Axis.vertical,
        itemCount: product.length,
        itemBuilder: (context, i) {
          return ElevatedButton(
              onPressed: () {
                bloc.addToCart({
                  'Name': product[i].product,
                  'Category': product[i].category,
                  'Price': product[i].price,
                  'Quantity': 1,
                  'Total Price': product[i].price
                });
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.black12;
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.black26;
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      product[i].product,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "\$${product[i].price}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ]));
        });
  }
}
