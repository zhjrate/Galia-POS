import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Models/Products.dart';
import 'package:denario/Products/ProductOptionsDialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class NewProduct extends StatefulWidget {
  final String activeBusiness;
  final List categories;
  final String businessField;
  final Products product;
  const NewProduct(
      this.activeBusiness, this.categories, this.businessField, this.product,
      {Key key})
      : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String code = '';
  double price = 0;
  String description = '';
  String category = '';
  bool isAvailable;
  bool show;
  bool vegan;
  bool newProduct;
  List historicPrices;

  void setProductOptions(String optionTitle, bool mandadory,
      bool multipleOptions, String priceStructure, List<Map> priceOptions) {
    setState(() {
      productOptions.add({
        'Title': optionTitle,
        'Mandatory': mandadory,
        'Multiple Options': multipleOptions,
        'Price Structure': priceStructure,
        'Price Options': priceOptions
      });
    });
  }

  //List of ingredients
  List ingredients = [];
  ValueKey redrawObject = ValueKey('List');
  List<TextEditingController> _controllers = [];

  //List of product Options
  List productOptions = [];
  ValueKey redrawObject2 = ValueKey('List2');

  //Lista de letras del nombre
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  //Image select and upload to storage
  String image = '';
  Uint8List webImage = Uint8List(8);
  String downloadUrl;
  bool changedImage = false;
  Future getImage() async {
    XFile selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      Uint8List uploadFile = await selectedImage.readAsBytes();
      setState(() {
        webImage = uploadFile;
        changedImage = true;
      });
    }
  }

  Future uploadPic(businessID) async {
    ////Upload to Clod Storage

    String fileName = 'Product Images/' + businessID + '/' + name + '.png';
    var ref = FirebaseStorage.instance.ref().child(fileName);

    TaskSnapshot uploadTask = await ref.putData(webImage);

    ///Save to Firestore
    if (uploadTask.state == TaskState.success) {
      downloadUrl = await uploadTask.ref.getDownloadURL();
    }
  }

  @override
  void initState() {
    if (widget.product != null) {
      newProduct = false;
      category = widget.product.category;
      isAvailable = widget.product.available;
      show = widget.product.available;
      vegan = widget.product.vegan;
      name = widget.product.product;
      price = widget.product.price;
      code = widget.product.code;
      description = widget.product.description;
      image = widget.product.image;
      ingredients = widget.product.ingredients;
      historicPrices = widget.product.historicPrices;
      if (widget.product.productOptions.length > 0) {
        for (var x = 0; x < widget.product.productOptions.length; x++) {
          productOptions.add({
            'Mandatory': widget.product.productOptions[x].mandatory,
            'Multiple Options':
                widget.product.productOptions[x].multipleOptions,
            'Price Structure': widget.product.productOptions[x].priceStructure,
            'Title': widget.product.productOptions[x].title,
            'Price Options': widget.product.productOptions[x].priceOptions
          });
        }
      } else {
        productOptions = [];
      }
    } else {
      newProduct = true;
      category = widget.categories.first;
      isAvailable = true;
      show = true;
      vegan = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Title
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0),
              SizedBox(width: 25),
              Text(
                'Nuevo Producto',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
              ),
            ],
          ),
          SizedBox(height: 35),
          //Form
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15),
              //Image
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey[350],
                        offset: new Offset(0, 0),
                        blurRadius: 10.0,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      //Text
                      Text(
                        'Imagen',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black45),
                      ),
                      SizedBox(height: 10),
                      //Image
                      (changedImage)
                          ? Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  color: Colors.grey,
                                  image: DecorationImage(
                                      image: Image.memory(
                                        webImage,
                                        fit: BoxFit.cover,
                                      ).image,
                                      fit: BoxFit.cover)))
                          : (!newProduct && image != '')
                              ? Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      color: Colors.grey.shade200,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              widget.product.image),
                                          fit: BoxFit.cover)),
                                  child: Center(
                                    child: Icon(Icons.add_a_photo,
                                        color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Center(
                                    child: Icon(Icons.add_a_photo,
                                        color: Colors.grey),
                                  ),
                                ),

                      SizedBox(height: 20),
                      TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
                        onPressed: getImage,
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 2),
                          child: Center(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 12,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Editar imagen',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 35),
              //Main Data
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.grey[350],
                        offset: new Offset(0, 0),
                        blurRadius: 10.0,
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name and code
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Nombre
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nombre del producto*',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black45),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      cursorColor: Colors.grey,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Agrega un nombre";
                                        } else {
                                          return null;
                                        }
                                      },
                                      initialValue: name,
                                      decoration: InputDecoration(
                                        focusColor: Colors.black,
                                        hintStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14),
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
                                          name = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            //Code
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Código (opcional)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black45),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      cursorColor: Colors.grey,
                                      initialValue: code,
                                      decoration: InputDecoration(
                                        hintText: 'xxx',
                                        focusColor: Colors.black,
                                        hintStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14),
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
                                          code = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        //Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Price
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Precio de venta*',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black45),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                      cursorColor: Colors.grey,
                                      initialValue:
                                          (price > 0) ? price.toString() : '',
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                                        TextInputFormatter.withFunction(
                                          (oldValue, newValue) =>
                                              newValue.copyWith(
                                            text: newValue.text
                                                .replaceAll(',', '.'),
                                          ),
                                        ),
                                      ],
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Agrega un precio";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: '0.00',
                                        prefixIcon: Icon(
                                          Icons.attach_money,
                                          color: Colors.grey,
                                        ),
                                        focusColor: Colors.black,
                                        hintStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 14),
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
                                        if (value != '' && value != null) {
                                          setState(() {
                                            price = double.parse(value);
                                          });
                                        } else {
                                          setState(() {
                                            price = 0;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            //Available
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Disponible',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black45),
                                  ),
                                  SizedBox(height: 10),
                                  Switch(
                                    value: isAvailable,
                                    onChanged: (value) {
                                      setState(() {
                                        isAvailable = value;
                                      });
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            //Show on menu
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mostrar en catálogo digital',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black45),
                                  ),
                                  SizedBox(height: 10),
                                  Switch(
                                    value: show,
                                    onChanged: (value) {
                                      setState(() {
                                        show = value;
                                      });
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        //Dropdown categories
                        Text(
                          'Categoría',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black45),
                        ),
                        SizedBox(height: 10),
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton(
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: Text(
                                widget.categories[0],
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.grey[700]),
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.grey[700]),
                              value: category,
                              items: widget.categories.map((x) {
                                return new DropdownMenuItem(
                                  value: x,
                                  child: new Text(x),
                                  onTap: () {
                                    setState(() {
                                      category = x;
                                    });
                                  },
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  category = newValue;
                                });
                              },
                            )),
                        SizedBox(height: 20),
                        //Description
                        Text(
                          'Descripción (opcional)',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black45),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          minLines: 5,
                          maxLines: 10,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          cursorColor: Colors.grey,
                          initialValue: description,
                          decoration: InputDecoration(
                            hintText: 'Descripción del producto',
                            focusColor: Colors.black,
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
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        //Vegan
                        (widget.businessField == 'Gastronómico')
                            ? //Available
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Vegano',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black45),
                                  ),
                                  SizedBox(height: 10),
                                  Switch(
                                    value: vegan,
                                    onChanged: (value) {
                                      setState(() {
                                        vegan = value;
                                      });
                                    },
                                    activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: Colors.green,
                                  ),
                                ],
                              )
                            : SizedBox(),
                        (widget.businessField == 'Gastronómico')
                            ? SizedBox(height: 20)
                            : SizedBox(),
                        //Product Options
                        Text(
                          'Opciones del producto (opcional)',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black45),
                        ),
                        SizedBox(height: 10),
                        (productOptions.length == 0)
                            ? SizedBox()
                            : ListView.builder(
                                key: redrawObject2,
                                shrinkWrap: true,
                                itemCount: productOptions.length,
                                itemBuilder: ((context, i) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Column(
                                      children: [
                                        //TITLE
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            //Title
                                            Expanded(
                                              flex: 9,
                                              child: Text(
                                                productOptions[i]['Title'],
                                                maxLines: 5,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            //Edit
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.edit)),
                                            SizedBox(width: 5),

                                            //Delete
                                            IconButton(
                                                onPressed: () {
                                                  productOptions.removeAt(i);

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
                                                    redrawObject2 =
                                                        ValueKey(randomString);
                                                  });
                                                },
                                                icon: Icon(Icons.delete))
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        //Mandatory //Multiple options
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            //Mandatory
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Text((productOptions[i]
                                                      ['Mandatory'])
                                                  ? 'Obligatorio'
                                                  : 'Opcional'),
                                            ),
                                            SizedBox(width: 10),
                                            //Multiple Options
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Text((productOptions[i]
                                                      ['Multiple Options'])
                                                  ? 'Selección múltiple'
                                                  : 'Selección única'),
                                            ),
                                            SizedBox(width: 10),
                                            //Price Structure
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Text((productOptions[i]
                                                          ['Price Structure'] ==
                                                      'Aditional')
                                                  ? 'Precio adicional'
                                                  : (productOptions[i][
                                                              'Price Structure'] ==
                                                          'Complete')
                                                      ? 'Reemplaza el precio'
                                                      : 'Sin costo adicional'),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 10),
                                        //OPTIONS
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: productOptions[i]
                                                    ['Price Options']
                                                .length,
                                            itemBuilder: ((context, x) {
                                              if (productOptions[i]
                                                              ['Price Options']
                                                          [x]['Price'] !=
                                                      0 &&
                                                  productOptions[i]
                                                              ['Price Options']
                                                          [x]['Price'] !=
                                                      null) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15.0),
                                                  child: Text(
                                                      '• ${productOptions[i]['Price Options'][x]['Option']}  (+\$${productOptions[i]['Price Options'][x]['Price']})'),
                                                );
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 15.0),
                                                  child: Text(
                                                      '• ${productOptions[i]['Price Options'][x]['Option']}'),
                                                );
                                              }
                                            })),
                                      ],
                                    ),
                                  );
                                })),
                        //Agregar Lista de opciones
                        Tooltip(
                          message: 'Agregar opciones del producto',
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ProductOptionsDialog(
                                        setProductOptions);
                                  });
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              child: Center(
                                  child: Icon(
                                Icons.add,
                                color: Colors.black87,
                                size: 30,
                              )),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        //Ingredientes
                        Text(
                          'Insumos asociados (opcional)',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black45),
                        ),
                        SizedBox(height: 10),
                        (ingredients.length == 0)
                            ? SizedBox()
                            : ListView.builder(
                                key: redrawObject,
                                shrinkWrap: true,
                                itemCount: ingredients.length,
                                itemBuilder: ((context, i) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //Ingrediente
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                            width: double.infinity,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              cursorColor: Colors.grey,
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return "Agrega un ingrediente válido";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              initialValue: ingredients[i]
                                                  ['Ingredient'],
                                              decoration: InputDecoration(
                                                hintText: 'Insumo',
                                                focusColor: Colors.black,
                                                hintStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12),
                                                errorStyle: TextStyle(
                                                    color:
                                                        Colors.redAccent[700],
                                                    fontSize: 12),
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          12.0),
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey[350],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          12.0),
                                                  borderSide: new BorderSide(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  ingredients[i]['Ingredient'] =
                                                      value;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        //Amount
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            width: double.infinity,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                              initialValue: ingredients[i]
                                                      ['Quantity']
                                                  .toString(),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'[0-9]+[,.]{0,1}[0-9]*')),
                                                TextInputFormatter.withFunction(
                                                  (oldValue, newValue) =>
                                                      newValue.copyWith(
                                                    text: newValue.text
                                                        .replaceAll(',', '.'),
                                                  ),
                                                ),
                                              ],
                                              cursorColor: Colors.grey,
                                              decoration: InputDecoration(
                                                focusColor: Colors.black,
                                                hintText: 'Cantidad',
                                                hintStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12),
                                                errorStyle: TextStyle(
                                                    color:
                                                        Colors.redAccent[700],
                                                    fontSize: 12),
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          12.0),
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey[350],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          12.0),
                                                  borderSide: new BorderSide(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  ingredients[i]['Quantity'] =
                                                      double.parse(value);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        //Yield
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            width: double.infinity,
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                              initialValue: ingredients[i]
                                                      ['Yield']
                                                  .toString(),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'[0-9]+[,.]{0,1}[0-9]*')),
                                                TextInputFormatter.withFunction(
                                                  (oldValue, newValue) =>
                                                      newValue.copyWith(
                                                    text: newValue.text
                                                        .replaceAll(',', '.'),
                                                  ),
                                                ),
                                              ],
                                              cursorColor: Colors.grey,
                                              decoration: InputDecoration(
                                                focusColor: Colors.black,
                                                hintText: 'Rinde para:',
                                                hintStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12),
                                                errorStyle: TextStyle(
                                                    color:
                                                        Colors.redAccent[700],
                                                    fontSize: 12),
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          12.0),
                                                  borderSide: new BorderSide(
                                                    color: Colors.grey[350],
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          12.0),
                                                  borderSide: new BorderSide(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  ingredients[i]['Yield'] =
                                                      double.parse(value);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        //Delete
                                        IconButton(
                                            onPressed: () {
                                              ingredients.removeAt(i);

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
                                            icon: Icon(Icons.delete))
                                      ],
                                    ),
                                  );
                                })),
                        SizedBox(height: (ingredients.length == 0) ? 0 : 12),
                        //Agregar ingrediente
                        Tooltip(
                          message: 'Agregar insumo',
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              for (var x = 0; x < 2; x++) {
                                _controllers.add(new TextEditingController());
                              }
                              setState(() {
                                ingredients.add({
                                  'Ingredient': '',
                                  'Quantity': '',
                                  'Yield': ''
                                });
                              });
                            },
                            child: Container(
                              height: 70,
                              width: 70,
                              child: Center(
                                  child: Icon(
                                Icons.add,
                                color: Colors.black87,
                                size: 30,
                              )),
                            ),
                          ),
                        ),
                        //Button
                        SizedBox(height: 35),
                        (widget.product == null)
                            ? ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered))
                                        return Colors.grey;
                                      if (states.contains(
                                              MaterialState.focused) ||
                                          states
                                              .contains(MaterialState.pressed))
                                        return Colors.grey.shade300;
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                ),
                                onPressed: () {
                                  if (newProduct) {
                                    if (_formKey.currentState.validate()) {
                                      if (changedImage) {
                                        uploadPic(widget.activeBusiness).then(
                                            (value) => DatabaseService()
                                                .createProduct(
                                                    widget.activeBusiness,
                                                    name,
                                                    downloadUrl,
                                                    category,
                                                    price,
                                                    description,
                                                    productOptions,
                                                    setSearchParam(
                                                        name.toLowerCase()),
                                                    code,
                                                    ingredients,
                                                    (widget.businessField ==
                                                            'Gatronómico')
                                                        ? vegan
                                                        : null,
                                                    show));
                                      } else {
                                        DatabaseService().createProduct(
                                            widget.activeBusiness,
                                            name,
                                            '',
                                            category,
                                            price,
                                            description,
                                            productOptions,
                                            setSearchParam(name.toLowerCase()),
                                            code,
                                            ingredients,
                                            (widget.businessField ==
                                                    'Gatronómico')
                                                ? vegan
                                                : null,
                                            show);
                                      }

                                      Navigator.of(context).pop();
                                    }
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      if (changedImage) {
                                        if (widget.product.price != price) {
                                          historicPrices.last['To Date'] =
                                              DateTime.now();

                                          historicPrices.add({
                                            'From Date': DateTime.now(),
                                            'To Date': null,
                                            'Price': price
                                          });
                                        }
                                        uploadPic(widget.activeBusiness).then(
                                            (value) => DatabaseService()
                                                .editProduct(
                                                    widget.activeBusiness,
                                                    widget.product.productID,
                                                    isAvailable,
                                                    name,
                                                    downloadUrl,
                                                    category,
                                                    price,
                                                    description,
                                                    productOptions,
                                                    setSearchParam(
                                                        name.toLowerCase()),
                                                    code,
                                                    ingredients,
                                                    (widget.businessField ==
                                                            'Gatronómico')
                                                        ? vegan
                                                        : null,
                                                    show,
                                                    historicPrices));
                                      } else {
                                        if (widget.product.price != price) {
                                          historicPrices.last['To Date'] =
                                              DateTime.now();

                                          historicPrices.add({
                                            'From Date': DateTime.now(),
                                            'To Date': null,
                                            'Price': price
                                          });
                                        }
                                        DatabaseService().editProduct(
                                            widget.activeBusiness,
                                            widget.product.productID,
                                            isAvailable,
                                            name,
                                            image,
                                            category,
                                            price,
                                            description,
                                            productOptions,
                                            setSearchParam(name.toLowerCase()),
                                            code,
                                            ingredients,
                                            (widget.businessField ==
                                                    'Gatronómico')
                                                ? vegan
                                                : null,
                                            show,
                                            historicPrices);
                                      }
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Center(
                                    child: Text((newProduct)
                                        ? 'Crear'
                                        : 'Guardar cambios'),
                                  ),
                                ))
                            : Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    //Save
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered))
                                                  return Colors.grey;
                                                if (states.contains(
                                                        MaterialState
                                                            .focused) ||
                                                    states.contains(
                                                        MaterialState.pressed))
                                                  return Colors.grey.shade300;
                                                return null; // Defer to the widget's default.
                                              },
                                            ),
                                          ),
                                          onPressed: () {
                                            if (newProduct) {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                if (changedImage) {
                                                  uploadPic(
                                                          widget.activeBusiness)
                                                      .then((value) => DatabaseService()
                                                          .createProduct(
                                                              widget
                                                                  .activeBusiness,
                                                              name,
                                                              downloadUrl,
                                                              category,
                                                              price,
                                                              description,
                                                              productOptions,
                                                              setSearchParam(name
                                                                  .toLowerCase()),
                                                              code,
                                                              ingredients,
                                                              (widget.businessField ==
                                                                      'Gatronómico')
                                                                  ? vegan
                                                                  : null,
                                                              show));
                                                } else {
                                                  DatabaseService().createProduct(
                                                      widget.activeBusiness,
                                                      name,
                                                      '',
                                                      category,
                                                      price,
                                                      description,
                                                      productOptions,
                                                      setSearchParam(
                                                          name.toLowerCase()),
                                                      code,
                                                      ingredients,
                                                      (widget.businessField ==
                                                              'Gatronómico')
                                                          ? vegan
                                                          : null,
                                                      show);
                                                }

                                                Navigator.of(context).pop();
                                              }
                                            } else {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                if (changedImage) {
                                                  if (widget.product.price !=
                                                      price) {
                                                    historicPrices
                                                            .last['To Date'] =
                                                        DateTime.now();

                                                    historicPrices.add({
                                                      'From Date':
                                                          DateTime.now(),
                                                      'To Date': null,
                                                      'Price': price
                                                    });
                                                  }
                                                  uploadPic(
                                                          widget.activeBusiness)
                                                      .then((value) => DatabaseService().editProduct(
                                                          widget.activeBusiness,
                                                          widget.product
                                                              .productID,
                                                          isAvailable,
                                                          name,
                                                          downloadUrl,
                                                          category,
                                                          price,
                                                          description,
                                                          productOptions,
                                                          setSearchParam(name
                                                              .toLowerCase()),
                                                          code,
                                                          ingredients,
                                                          (widget.businessField ==
                                                                  'Gatronómico')
                                                              ? vegan
                                                              : null,
                                                          show,
                                                          historicPrices));
                                                } else {
                                                  if (widget.product.price !=
                                                      price) {
                                                    historicPrices
                                                            .last['To Date'] =
                                                        DateTime.now();

                                                    historicPrices.add({
                                                      'From Date':
                                                          DateTime.now(),
                                                      'To Date': null,
                                                      'Price': price
                                                    });
                                                  }
                                                  DatabaseService().editProduct(
                                                      widget.activeBusiness,
                                                      widget.product.productID,
                                                      isAvailable,
                                                      name,
                                                      image,
                                                      category,
                                                      price,
                                                      description,
                                                      productOptions,
                                                      setSearchParam(
                                                          name.toLowerCase()),
                                                      code,
                                                      ingredients,
                                                      (widget.businessField ==
                                                              'Gatronómico')
                                                          ? vegan
                                                          : null,
                                                      show,
                                                      historicPrices);
                                                }
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            child: Center(
                                              child: Text((newProduct)
                                                  ? 'Crear'
                                                  : 'Guardar cambios'),
                                            ),
                                          )),
                                    ),
                                    SizedBox(width: 20),
                                    //Delete
                                    Container(
                                      height: 45,
                                      width: 45,
                                      child: Tooltip(
                                        message: 'Eliminar producto',
                                        child: OutlinedButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsetsGeometry>(
                                                EdgeInsets.all(5)),
                                            alignment: Alignment.center,
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white70),
                                            overlayColor: MaterialStateProperty
                                                .resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                                if (states.contains(
                                                    MaterialState.hovered))
                                                  return Colors.grey.shade300;
                                                if (states.contains(
                                                        MaterialState
                                                            .focused) ||
                                                    states.contains(
                                                        MaterialState.pressed))
                                                  return Colors.white;
                                                return null; // Defer to the widget's default.
                                              },
                                            ),
                                          ),
                                          onPressed: () {
                                            DatabaseService().deleteProduct(
                                                widget.activeBusiness,
                                                widget.product.productID);
                                            Navigator.of(context).pop();
                                          },
                                          child: Center(
                                              child: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                            size: 18,
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              //Expanded
              Expanded(flex: 2, child: Container())
            ],
          ),
          SizedBox(height: 20),
        ],
      )),
    );
  }
}
