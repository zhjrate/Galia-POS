import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Mapping.dart';
import 'package:denario/Models/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesDesk extends StatefulWidget {
  final String activeBusiness;
  final List categories;
  final reloadApp;
  const CategoriesDesk(this.activeBusiness, this.categories, this.reloadApp,
      {Key key})
      : super(key: key);

  @override
  State<CategoriesDesk> createState() => _CategoriesDeskState();
}

class _CategoriesDeskState extends State<CategoriesDesk> {
  List categoriesList = [];
  ValueKey redrawObject = ValueKey('List');
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    if (widget.categories.length > 0) {
      for (var i = 0; i < widget.categories.length; i++) {
        categoriesList.add({'Category': widget.categories[i], 'Edit': false});
      }
    } else {
      categoriesList = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Products>>(context);
    final highLevelMapping = Provider.of<HighLevelMapping>(context);

    if (products == null || highLevelMapping == null) {
      return Container();
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Back
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                ),
                SizedBox(width: 25),
                //Title
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Categorias',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 600,
                      child: Text(
                        'La lista de categorías servirá para identificar y organizar tus productos y tus gastos. También te permitirá observar la rentabilidad de tus productos por cada categoría',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            //lIST OF Categories (Titles)
            Container(
              height: 40,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Order
                  Container(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Orden',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          SizedBox(width: 10),
                          Tooltip(
                            message:
                                'Con este orden se muestra en el POS y en el catálogo digital',
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 14,
                              color: Colors.black,
                            ),
                          )
                        ],
                      )),
                  SizedBox(width: 20),
                  //Nombre
                  Container(
                      width: 350,
                      child: Text(
                        'Categoría',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      )),
                  SizedBox(width: 30),
                  //Código
                  Container(
                      width: 200,
                      child: Text(
                        'Cantidad de productos',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      )),
                  Spacer(),
                  //Add category
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      for (var x = 0; x < 1; x++) {
                        _controllers.add(new TextEditingController());
                      }
                      setState(() {
                        categoriesList.add({'Category': '', 'Edit': true});
                      });
                    },
                    child: Container(
                      height: 45,
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 16),
                          SizedBox(width: 10),
                          Text('Agregar categoría'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 1,
              endIndent: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            //List of Categories
            (categoriesList.length == 0)
                ? SizedBox()
                : Expanded(
                    child: ListView.builder(
                        itemCount: categoriesList.length,
                        shrinkWrap: true,
                        key: redrawObject,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          var noProducts = products
                              .where((x) =>
                                  x.category == categoriesList[i]['Category'])
                              .length;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //Order
                                Container(
                                    width: 120,
                                    child: Row(
                                      children: [
                                        //Up
                                        (i > 0)
                                            ? IconButton(
                                                onPressed: () {
                                                  var indexedCategory =
                                                      categoriesList[i];
                                                  int tempIndex = i + 1;

                                                  categoriesList.insert(
                                                      i - 1, indexedCategory);
                                                  categoriesList
                                                      .removeAt(tempIndex);

                                                  final random = Random();
                                                  const availableChars =
                                                      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                                  final randomString = List.generate(
                                                      10,
                                                      (index) => availableChars[
                                                          random.nextInt(
                                                              availableChars
                                                                  .length)]).join();
                                                  setState(() {
                                                    redrawObject =
                                                        ValueKey(randomString);
                                                  });
                                                },
                                                splashRadius: 18,
                                                icon: Icon(
                                                  Icons.arrow_upward,
                                                  size: 15,
                                                  color: Colors.grey,
                                                ))
                                            : SizedBox(width: 40),
                                        SizedBox(width: 5),
                                        //Index
                                        Text(
                                          '${i + 1}',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(width: 5),
                                        //dOWN+
                                        (i == categoriesList.length - 1)
                                            ? SizedBox(
                                                width: 40,
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  var indexedCategory =
                                                      categoriesList[i];
                                                  int tempIndex = i;

                                                  categoriesList.insert(
                                                      i + 2, indexedCategory);
                                                  categoriesList
                                                      .removeAt(tempIndex);
                                                  final random = Random();
                                                  const availableChars =
                                                      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                                  final randomString = List.generate(
                                                      10,
                                                      (index) => availableChars[
                                                          random.nextInt(
                                                              availableChars
                                                                  .length)]).join();
                                                  setState(() {
                                                    redrawObject =
                                                        ValueKey(randomString);
                                                  });
                                                },
                                                splashRadius: 18,
                                                icon: Icon(
                                                  Icons.arrow_downward,
                                                  size: 15,
                                                  color: Colors.grey,
                                                )),
                                      ],
                                    )),
                                SizedBox(width: 20),
                                //Categoría
                                Container(
                                  width: 350,
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    cursorColor: Colors.grey,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Agrega un ingrediente válido";
                                      } else {
                                        return null;
                                      }
                                    },
                                    initialValue: categoriesList[i]['Category'],
                                    enabled: (categoriesList[i]['Edit'])
                                        ? true
                                        : false,
                                    decoration: InputDecoration(
                                      hintText: 'Categoría',
                                      focusColor: Colors.black,
                                      hintStyle: TextStyle(
                                          color: Colors.black45, fontSize: 12),
                                      errorStyle: TextStyle(
                                          color: Colors.redAccent[700],
                                          fontSize: 12),
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0),
                                        borderSide: new BorderSide(
                                          color: Colors.grey[350],
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(12.0),
                                        borderSide: new BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        categoriesList[i]['Category'] = value;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 30),
                                //Number of products
                                Container(
                                    width: 200,
                                    child: Text(
                                      '$noProducts',
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    )),
                                SizedBox(width: 50),
                                //More Button
                                IconButton(
                                    onPressed: () {
                                      if (noProducts > 0) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                child: Container(
                                                  width: 350,
                                                  height: 350,
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //Back
                                                      Container(
                                                        alignment:
                                                            Alignment(1.0, 0.0),
                                                        child: IconButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            icon: Icon(
                                                                Icons.close),
                                                            iconSize: 20.0),
                                                      ),
                                                      SizedBox(height: 20),
                                                      //Icon
                                                      Icon(
                                                        Icons.warning,
                                                        size: 45,
                                                        color: Colors.grey,
                                                      ),
                                                      SizedBox(height: 30),
                                                      //Message
                                                      Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  30),
                                                          child: Text(
                                                            'No puedes editar o borrar una categoría con productos asociados. Primero recategoriza o elimina esos productos y luego podrás borrar la categoría',
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 5,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        categoriesList.removeAt(i);

                                        final random = Random();
                                        const availableChars =
                                            'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                        final randomString = List.generate(
                                                10,
                                                (index) => availableChars[
                                                    random.nextInt(
                                                        availableChars.length)])
                                            .join();
                                        setState(() {
                                          redrawObject = ValueKey(randomString);
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          );
                        }),
                  ),
            SizedBox(height: 20),
            //Agregar Categoria
            Container(
              height: 45,
              child: Tooltip(
                message: (categoriesList != [])
                    ? ''
                    : 'Debes tener al menos una categoría para poder vender',
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          (categoriesList != [])
                              ? Colors.greenAccent[400]
                              : Colors.grey),
                      overlayColor: (categoriesList != [])
                          ? MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.greenAccent[300];
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed))
                                  return Colors.lightGreenAccent;
                                return null; // Defer to the widget's default.
                              },
                            )
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed: () {
                      List newCategoryList = [];

                      if (categoriesList != []) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: SingleChildScrollView(
                                  child: Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Container(
                                      width: 450,
                                      height: 300,
                                      padding: EdgeInsets.fromLTRB(
                                          30.0, 20.0, 30.0, 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //Go back
                                          Container(
                                            alignment: Alignment(1.0, 0.0),
                                            child: IconButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                icon: Icon(Icons.close),
                                                iconSize: 20.0),
                                          ),
                                          //Title
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Confirmar cambio de categorías",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Text(
                                              'Recargaremos la app para actualizar las categorías en todas las secciones',
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //Yes
                                              Expanded(
                                                child: Container(
                                                  height: 45,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty.all<
                                                                  Color>(Colors
                                                                      .greenAccent[
                                                                  400]),
                                                          overlayColor:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                      Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                              if (states.contains(
                                                                  MaterialState
                                                                      .hovered))
                                                                return Colors
                                                                        .greenAccent[
                                                                    300];
                                                              if (states.contains(
                                                                      MaterialState
                                                                          .focused) ||
                                                                  states.contains(
                                                                      MaterialState
                                                                          .pressed))
                                                                return Colors
                                                                    .lightGreenAccent;
                                                              return null; // Defer to the widget's default.
                                                            },
                                                          )),
                                                      onPressed: () {
                                                        //Edit list of categories
                                                        for (var i = 0;
                                                            i <
                                                                categoriesList
                                                                    .length;
                                                            i++) {
                                                          newCategoryList.add(
                                                              categoriesList[i]
                                                                  ['Category']);
                                                        }
                                                        DatabaseService()
                                                            .editBusinessCategories(
                                                                widget
                                                                    .activeBusiness,
                                                                newCategoryList);

                                                        //Edit High Level Mapping
                                                        var newCategoriesMapping =
                                                            highLevelMapping
                                                                .pnlMapping;
                                                        List salesCategories =
                                                            [];
                                                        List costCategories =
                                                            [];

                                                        for (var i = 0;
                                                            i <
                                                                categoriesList
                                                                    .length;
                                                            i++) {
                                                          salesCategories.add(
                                                              'Ventas de ' +
                                                                  categoriesList[
                                                                          i][
                                                                      'Category']);
                                                          costCategories.add(
                                                              'Costos de ' +
                                                                  categoriesList[
                                                                          i][
                                                                      'Category']);
                                                        }

                                                        newCategoriesMapping[
                                                                'Ventas'] =
                                                            salesCategories;
                                                        newCategoriesMapping[
                                                                'Costo de Ventas'] =
                                                            costCategories;

                                                        DatabaseService()
                                                            .editCategoriesonPnlMapping(
                                                                widget
                                                                    .activeBusiness,
                                                                newCategoriesMapping);

                                                        //Go Back
                                                        widget.reloadApp();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 5),
                                                        child: Text(
                                                          'Confirmar',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              //No
                                              Expanded(
                                                child: Container(
                                                  height: 45,
                                                  child: OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.black,
                                                      ),
                                                      onPressed: () {},
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 15,
                                                                vertical: 5),
                                                        child: Text(
                                                          'Cancelar',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 25),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Text(
                        'Guardar cambios',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
