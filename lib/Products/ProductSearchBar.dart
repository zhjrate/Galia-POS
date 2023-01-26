import 'package:denario/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSearchBar extends StatelessWidget {
  final selectProduct;
  const ProductSearchBar(this.selectProduct, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Products>>(context);

    if (products == null || products.length < 1) {
      return Container();
    }

    // if (products.length < 1) {
    //   return Container(
    //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
    //       width: 400,
    //       decoration: BoxDecoration(
    //         borderRadius: new BorderRadius.circular(12.0),
    //         color: Colors.white,
    //         boxShadow: <BoxShadow>[
    //           new BoxShadow(
    //             color: Colors.grey[350],
    //             offset: new Offset(0, 0),
    //             blurRadius: 10.0,
    //           )
    //         ],
    //       ),
    //       child: Text('No encontramos ninguno con este nombre'));
    // }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      width: 400,
      // height: 200,
      // constraints: BoxConstraints(),
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.grey[350],
            offset: new Offset(0, 0),
            blurRadius: 10.0,
          )
        ],
      ),
      child: ListView.builder(
          itemCount: products.length,
          shrinkWrap: true,
          itemBuilder: ((context, i) {
            return TextButton(
                onPressed: () {
                  selectProduct(products[i]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      products[i].product,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ));
          })),
    );
  }
}
