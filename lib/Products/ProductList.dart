import 'package:denario/Models/Products.dart';
import 'package:denario/Products/NewProduct.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  final String businessID;
  final List categories;
  final String businessField;
  ProductList(this.businessID, this.categories, this.businessField);

  final formatCurrency = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Products>>(context);

    if (products == null) {
      return Container(
        child: Text('Error'),
      );
    }

    if (products.length == 0) {
      return Container(
        width: double.infinity,
        child: Center(child: Text('No se encontraron productos')),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewProduct(businessID,
                              categories, businessField, products[i])));
                },
                child: Container(
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Imagen
                      (products[i].image != '')
                          ? Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: Colors.grey.shade300,
                                  image: DecorationImage(
                                      image: NetworkImage(products[i].image),
                                      fit: BoxFit.cover)))
                          : Container(
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  color: Colors.grey.shade300)),
                      //Nombre
                      Container(
                          width: 150,
                          child: Text(
                            products[i].product,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      //Código
                      Container(
                          width: 100,
                          child: Text(
                            products[i].code,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black54),
                          )),

                      //Categoria
                      Container(
                          width: 150,
                          child: Text(
                            products[i].category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          )),

                      //Precio
                      Container(
                          width: 150,
                          child: Text(
                            '${formatCurrency.format(products[i].price)}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                      //Margen de ganancia
                      Container(
                          width: 100,
                          child: Text(
                            '10%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),

                      //More Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.black, size: 20),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewProduct(businessID,
                                      categories, businessField, products[i])));
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
