import 'package:cached_network_image/cached_network_image.dart';
import 'package:denario/Backend/Ticket.dart';
import 'package:denario/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlateSelectionMobile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final product = Provider.of<List<Products>>(context);

    if (product == null){
      return Center();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),      
      scrollDirection: Axis.vertical,
      itemCount: 5, //product.length,
      itemBuilder: (context, i) {

        return Text ('Product');
        // return InkWell(
        //   borderRadius: BorderRadius.all(Radius.circular(15)),
        //   hoverColor: Colors.black26,
        //   onTap: () => bloc.addToCart({
        //     'name': product[i].product,
        //     'price': product[i].price,
        //     'Quantity': 1,
        //     'Total Price': product[i].price
        //   }),
        //   child: Container(
        //     height: MediaQuery.of(context).size.width * 0.14,
        //     width: double.infinity,
        //     padding: EdgeInsets.all(5.0),
        //     child: Row(              
        //       children: <Widget>[
        //         ///Image
        //         Container(
        //           height: MediaQuery.of(context).size.width * 0.12,
        //           width: double.infinity,
        //           decoration: BoxDecoration(
        //               color: Colors.grey[100],
        //               borderRadius: BorderRadius.circular(15.0),
        //               // image: DecorationImage(
        //               //     image: NetworkImage(product[i].image),
        //               //     fit: BoxFit.cover)
        //             ),
        //           child: CachedNetworkImage(
        //             imageUrl: product[i].image,
        //             fit: BoxFit.cover)
        //         ),
        //         SizedBox(width: 10),
        //         ///Text
        //         Container(
        //           width: double.infinity,
        //           height: 20,
        //           padding: EdgeInsets.symmetric(vertical: 10),
        //           child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children: <Widget>[
        //                 ///Product
        //                 Container(
        //                   child: Text(
        //                     product[i].product, //product[index].product,
        //                     textAlign: TextAlign.start,
        //                     style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 12,
        //                         fontWeight: FontWeight.w400),
        //                   ),
        //                 ),
        //                 Spacer(),

        //                 ///Price
        //                 Padding(
        //                   padding: const EdgeInsets.only(top: 8.0),
        //                   child: Text(
        //                     "\$${product[i].price}", //'\$120' + //product[index].price.toString(),
        //                     textAlign: TextAlign.start,
        //                     style: TextStyle(
        //                       color: Colors.black54,
        //                       fontWeight: FontWeight.w400,
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                 ),
        //               ]),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }
}
