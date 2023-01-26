import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/POS/POSItemDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlateSelectionDesktop extends StatefulWidget {
  final String businessID;
  final String category;
  PlateSelectionDesktop(this.businessID, this.category);

  @override
  _PlateSelectionDesktopState createState() => _PlateSelectionDesktopState();
}

class _PlateSelectionDesktopState extends State<PlateSelectionDesktop> {
  bool productExists = false;
  int itemIndex;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<List<Products>>(context);

    if (product == null) {
      return Center();
    }

    return StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.ticketItems,
        builder: (context, snapshot) {
          return GridView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (MediaQuery.of(context).size.width > 1100) ? 5 : 3,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 1,
            ),
            scrollDirection: Axis.vertical,
            itemCount: product.length,
            itemBuilder: (context, i) {
              return ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
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
                onPressed: () {
                  //If ticket contains product, just add
                  for (var x = 0; x < bloc.ticketItems['Items'].length; x++) {
                    if (product[i].product ==
                            bloc.ticketItems['Items'][x]["Name"] &&
                        bloc.ticketItems['Items'][x]["Options"].isEmpty) {
                      setState(() {
                        productExists = true;
                        itemIndex = x;
                      });
                    }
                  }
                  //Else add new item
                  if (productExists) {
                    bloc.addQuantity(itemIndex);
                  } else {
                    bloc.addToCart({
                      'Name': product[i].product,
                      'Category': product[i].category,
                      'Price': product[i].price,
                      'Quantity': 1,
                      'Total Price': product[i].price,
                      'Options': []
                    });
                  }

                  //Turn false
                  setState(() {
                    productExists = false;
                  });
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return POSItemDialog(
                            widget.businessID,
                            product[i].product,
                            product[i].productOptions,
                            product[i].available,
                            product[i].price.toDouble(),
                            product[i].category,
                            product[i].productID);
                      });
                },
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
                      SizedBox(height: 30),

                      ///Price
                      Text(
                        "\$${product[i].price}", //'\$120' + //product[index].price.toString(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
