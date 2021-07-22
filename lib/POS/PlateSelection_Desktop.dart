import 'package:cached_network_image/cached_network_image.dart';
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
        crossAxisCount: (MediaQuery.of(context).size.width > 1100) ? 4 : 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 5.0,
        childAspectRatio: 1,
      ),
      scrollDirection: Axis.vertical,
      itemCount: product.length,
      itemBuilder: (context, i) {
        return InkWell(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          hoverColor: Colors.black26,
          onTap: () => bloc.addToCart({
            'Name': product[i].product,
            'Category': product[i].category,
            'Price': product[i].price,
            'Quantity': 1,
            'Total Price': product[i].price
          }),
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                ///Image
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: CachedNetworkImage(
                          imageUrl: product[i].image, fit: BoxFit.cover)),
                ),

                ///Text
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ///Product
                        Expanded(
                          child: Container(
                            child: Text(
                              product[i].product, //product[index].product,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        Spacer(),

                        ///Price
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "\$${product[i].price}", //'\$120' + //product[index].price.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
