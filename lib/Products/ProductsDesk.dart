import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Categories.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/Products/CategoriesDesk.dart';
import 'package:denario/Products/NewProduct.dart';
import 'package:denario/Products/ProductList.dart';
import 'package:denario/Products/ProductSearchBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDesk extends StatefulWidget {
  final String currentBusiness;
  final List categories;
  final String businessField;
  final reloadApp;
  const ProductDesk(
      this.currentBusiness, this.categories, this.businessField, this.reloadApp,
      {Key key})
      : super(key: key);

  @override
  State<ProductDesk> createState() => _ProductDeskState();
}

class _ProductDeskState extends State<ProductDesk> {
  String name;
  TextEditingController nameController = new TextEditingController(text: '');
  String selectedProduct;
  List searchName;
  bool filtered;
  List listOfCategories = [];
  String selectedCategory = 'Todas las categorías';
  bool showSearchOptions;

  void selectProduct(Products product) {
    setState(() {
      selectedProduct = product.product;
      nameController.text = product.product;
      searchName = product.searchName;
      showSearchOptions = false;
      selectedCategory = 'Todas las categorías';
    });
  }

  @override
  void initState() {
    filtered = false;
    showSearchOptions = false;
    name = '';
    listOfCategories = widget.categories;
    if (!listOfCategories.contains('Todas las categorías')) {
      listOfCategories.add('Todas las categorías');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoryList>(context);

    if (categoriesProvider == null) {
      return Container();
    }

    return Scaffold(
        body: Container(
      width:
          (MediaQuery.of(context).size.width > 1100) ? double.infinity : 1100,
      padding: const EdgeInsets.all(20.0),
      child: Stack(children: [
        //Content
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            Container(
              child: Text(
                'Productos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            //Filters
            SizedBox(height: 70),
            //Titles
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Imagen
                  Container(
                      width: 75,
                      child: Text(
                        'Imagen',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      )),
                  //Nombre
                  Container(
                      width: 150,
                      child: Text(
                        'Producto',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      )),
                  //Código
                  Container(
                      width: 100,
                      child: Text(
                        'Código',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      )),

                  //Categoria
                  Container(
                      width: 150,
                      child: Text(
                        'Categoría',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      )),

                  //Precio
                  Container(
                      width: 150,
                      child: Text(
                        'Precio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                  //Margen de ganancia
                  Container(
                      width: 100,
                      child: Text(
                        'Margen %',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),

                  //More Button
                  SizedBox(width: 35)
                ],
              ),
            ),
            Divider(
              indent: 1,
              endIndent: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            //List of Products
            Expanded(
                child: (selectedCategory != 'Todas las categorías')
                    ? StreamProvider<List<Products>>.value(
                        initialData: null,
                        value: DatabaseService().productList(
                            selectedCategory, widget.currentBusiness),
                        child: ProductList(
                          widget.currentBusiness,
                          categoriesProvider.categoryList,
                          widget.businessField,
                        ))
                    : (selectedProduct != null && selectedProduct != '')
                        ? StreamProvider<List<Products>>.value(
                            initialData: null,
                            value: DatabaseService().productListbyentireName(
                                selectedProduct, widget.currentBusiness),
                            child: ProductList(
                              widget.currentBusiness,
                              categoriesProvider.categoryList,
                              widget.businessField,
                            ))
                        : StreamProvider<List<Products>>.value(
                            initialData: null,
                            value: DatabaseService()
                                .allProductList(widget.currentBusiness),
                            child: ProductList(
                              widget.currentBusiness,
                              categoriesProvider.categoryList,
                              widget.businessField,
                            )))
          ],
        ),
        //Filter
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            SizedBox(height: 60),
            //Filters
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Filter Box
                Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey[350],
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Nombre
                      Container(
                        width: 250,
                        height: 45,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: nameController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(2),
                              iconSize: 14,
                              splashRadius: 15,
                              onPressed: () {
                                setState(() {
                                  showSearchOptions = false;
                                  nameController.text = '';
                                });
                              },
                              icon: Icon(Icons.close),
                              color: Colors.black,
                            ),
                            hintText: 'Nombre',
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
                          onChanged: (val) {
                            setState(() {
                              name = val;
                              if (val != '') {
                                showSearchOptions = true;
                              } else {
                                showSearchOptions = false;
                              }
                            });
                          },
                          onFieldSubmitted: ((value) {
                            setState(() {
                              selectedProduct = value;
                              selectedCategory = 'Todas las categorías';
                            });
                          }),
                        ),
                      ),
                      //Categorias
                      Container(
                        width: 200,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          hint: Text(
                            'Todas las categorías',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black),
                          value: selectedCategory,
                          items: listOfCategories.map((i) {
                            return new DropdownMenuItem(
                              value: i,
                              child: new Text(i),
                            );
                          }).toList(),
                          onChanged: (x) {
                            setState(() {
                              selectedCategory = x;
                              selectedProduct = null;
                              nameController.text = '';
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        height: 40,
                        width: 40,
                        child: Tooltip(
                          message: 'Quitar filtros',
                          child: OutlinedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.all(5)),
                              alignment: Alignment.center,
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white70),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Colors.grey.shade300;
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed))
                                    return Colors.white;
                                  return null; // Defer to the widget's default.
                                },
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                filtered = false;
                                showSearchOptions = false;
                                selectedCategory = 'Todas las categorías';
                                selectedProduct = '';
                                name = '';
                              });
                            },
                            child: Center(
                                child: Icon(
                              Icons.filter_alt_off_outlined,
                              color: Colors.black,
                              size: 18,
                            )),
                          ),
                        ),
                      ),
                      Spacer(),
                      //Boton de categorias
                      Container(
                        height: 45,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StreamProvider<List<Products>>.value(
                                              initialData: null,
                                              value: DatabaseService()
                                                  .allProductList(
                                                      widget.currentBusiness),
                                              child: CategoriesDesk(
                                                  widget.currentBusiness,
                                                  categoriesProvider
                                                      .categoryList,
                                                  widget.reloadApp))));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Text(
                                'Categorías',
                                style: TextStyle(color: Colors.black),
                              ),
                            )),
                      ),
                      SizedBox(width: 15),
                      //Boton de agregar
                      Container(
                        height: 45,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.greenAccent[400]),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Colors.greenAccent[300];
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
                                      builder: (context) => NewProduct(
                                          widget.currentBusiness,
                                          categoriesProvider.categoryList,
                                          widget.businessField,
                                          null)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Agregar Producto',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                //Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: (showSearchOptions)
                      ? StreamProvider<List<Products>>.value(
                          value: DatabaseService().productListbyName(
                              name.toLowerCase(), widget.currentBusiness),
                          initialData: null,
                          child: ProductSearchBar(selectProduct),
                        )
                      : SizedBox(),
                )
              ],
            ),
          ],
        ),
      ]),
    ));
  }
}
