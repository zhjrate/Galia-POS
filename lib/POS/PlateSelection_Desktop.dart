import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlateSelectionDesktop extends StatelessWidget {
  final String category;
  PlateSelectionDesktop({this.category});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<List<Products>>(context);

    if (product == null) {
      return Center();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width > 1100) ? 5 : 3,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 15.0,
        childAspectRatio: 1,
      ),
      scrollDirection: Axis.vertical,
      itemCount: product.length,
      itemBuilder: (context, i) {
        return ElevatedButton(
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
          onPressed: () => bloc.addToCart({
            'Name': product[i].product,
            'Category': product[i].category,
            'Price': product[i].price,
            'Quantity': 1,
            'Total Price': product[i].price
          }),
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //product
                Text(
                  product[i].product, //product[index].product,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),

                ///Price
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "\$${product[i].price}", //'\$120' + //product[index].price.toString(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
