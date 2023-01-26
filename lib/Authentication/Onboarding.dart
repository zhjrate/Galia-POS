import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Backend/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';

class Onboarding extends StatefulWidget {
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  bool loading = false;

  final controller = PageController(initialPage: 0);
  final int totalPages = 3;

  int currentpage = 0;

  final FocusNode _nameNode = FocusNode();
  final FocusNode _tlfNode = FocusNode();

  final FocusNode _businessNameNode = FocusNode();
  final FocusNode _businessFieldNode = FocusNode();
  final FocusNode _businessLocationNode = FocusNode();
  final FocusNode _businessSizeNode = FocusNode();

//Text field state
  String name = "";
  int phone = 0;
  String rol = 'Dueñ@';
  List dropdownRol = [
    'Dueñ@', //Vista de todos los modulos
    'Encargad@', //Vistas de todos - PnL y Stats?
    'Moz@', //Solo modulo de POS
    'Cajer@', //Solo modulo POS + Daily + Gastos
    'Contador(a)', //Soolo modulo de PnL, vista de gastos, vista de ventas
    'Otro'
  ];
  String repeatPassword = "";
  String error = "";

  String businessName = "";
  String businessField = "Gastronómico";
  List businessFieldList = [
    'Gastronómico', //Vista de Mesas/Mostrador + Botón de venta manual
    'Servicios Profesionales', //Solo boton de venta manual
    'Tienda Minorista', //Solo venta de mostrador + boton de venta manual
    'Otro' //Solo boton de venta manual
  ];
  String businessLocation = "";
  int businessSize = 0;

  List purposeTags = [
    'Ahorrar trabajo administrativo',
    'Simplificar los procesos',
    'Tener mejor visión de mis finanzas',
    'Controlar mis ventas y gastos',
    'Controlar inventario',
    'Controlar los costos/precios de mis productos/servicios',
    'Vender online',
    'Manejar arqueos de caja',
    'Simplificar mi contabilidad'
  ];
  List selectedTags = [];

  String generateRandomString() {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(15,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 375),
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: isCurrentPage ? 12 : 6,
      width: isCurrentPage ? 12 : 6,
      decoration: BoxDecoration(
          color: isCurrentPage ? Colors.black54 : Colors.grey[300],
          borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final userProfile = Provider.of<UserData>(context);

    // if (userProfile == null) {
    //   return Loading();
    // }

    // //New Employee Loging in for first time
    // if (userProfile.name != null && userProfile.name != '') {
    //   final businessIndexOnProfile = userProfile.businesses.indexWhere(
    //       (element) => element.businessID == userProfile.activeBusiness);

    //   return Scaffold(
    //       body: Stack(children: [
    //     //Pages
    //     Align(
    //       alignment: Alignment.center,
    //       child: SingleChildScrollView(
    //         child: Container(
    //           constraints: BoxConstraints(
    //               maxWidth: 600, maxHeight: 600, minHeight: 500, minWidth: 500),
    //           padding: EdgeInsets.all(20),
    //           child: Form(
    //             key: _formKey,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 ////// Welcome
    //                 Text(
    //                   'Bienvenido!',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 24,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //                 SizedBox(height: 8),
    //                 Text(
    //                   'Sólo necesitamos confirmar tus datos para activar tu cuenta',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(color: Colors.black, fontSize: 14),
    //                 ),
    //                 SizedBox(height: 50),
    //                 //Nombre
    //                 TextFormField(
    //                   style: TextStyle(color: Colors.black, fontSize: 14),
    //                   validator: (val) =>
    //                       val.isEmpty ? "Agrega un nombre" : null,
    //                   autofocus: true,
    //                   cursorColor: Colors.grey,
    //                   focusNode: _nameNode,
    //                   textInputAction: TextInputAction.next,
    //                   initialValue: userProfile.name,
    //                   decoration: InputDecoration(
    //                       labelText: 'Nombre',
    //                       hintStyle: TextStyle(color: Colors.grey.shade400),
    //                       errorStyle: TextStyle(
    //                           color: Colors.redAccent[700], fontSize: 12),
    //                       focusedBorder: UnderlineInputBorder(
    //                           borderSide: BorderSide(color: Colors.grey))),
    //                   onFieldSubmitted: (term) {
    //                     _nameNode.unfocus();
    //                     FocusScope.of(context).requestFocus(_tlfNode);
    //                   },
    //                   onChanged: (val) {
    //                     setState(() => name = val);
    //                   },
    //                 ),
    //                 //Whatsapp
    //                 SizedBox(height: 25),
    //                 TextFormField(
    //                   style: TextStyle(color: Colors.black, fontSize: 14),
    //                   keyboardType: TextInputType.number,
    //                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    //                   validator: (val) => val.isEmpty
    //                       ? "Agrega un celular válido"
    //                       : (val.length == 10)
    //                           ? null
    //                           : "El número de celular debe tener 10 caracteres",
    //                   cursorColor: Colors.grey,
    //                   focusNode: _tlfNode,
    //                   textInputAction: TextInputAction.next,
    //                   decoration: InputDecoration(
    //                       labelText: 'Nro. de celular',
    //                       hintStyle: TextStyle(color: Colors.grey.shade400),
    //                       errorStyle: TextStyle(
    //                           color: Colors.redAccent[700], fontSize: 12),
    //                       focusedBorder: UnderlineInputBorder(
    //                           borderSide: BorderSide(color: Colors.grey))),
    //                   onFieldSubmitted: (term) {
    //                     _tlfNode.unfocus();
    //                     FocusScope.of(context).requestFocus(_rolNode);
    //                   },
    //                   onChanged: (val) {
    //                     setState(() => phone = int.parse(val));
    //                   },
    //                 ),
    //                 //Rol en el negocio
    //                 SizedBox(height: 25),
    //                 Text(
    //                   'Rol en el negocio',
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       color: Colors.grey[600],
    //                       fontSize: 12,
    //                       fontWeight: FontWeight.w400),
    //                 ),
    //                 SizedBox(height: 8),
    //                 Text(
    //                   userProfile
    //                       .businesses[businessIndexOnProfile].roleInBusiness,
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 14,
    //                       fontWeight: FontWeight.w400),
    //                 ),
    //                 SizedBox(height: 25),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),

    //     ///Pages navigator Dots
    //     Padding(
    //       padding: const EdgeInsets.only(bottom: 25.0),
    //       child: Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    //           //Button
    //           ElevatedButton(
    //             style: ButtonStyle(
    //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //                   RoundedRectangleBorder(
    //                 borderRadius: new BorderRadius.circular(12.0),
    //               )),
    //               backgroundColor:
    //                   MaterialStateProperty.all<Color>(Colors.black),
    //               overlayColor: MaterialStateProperty.resolveWith<Color>(
    //                 (Set<MaterialState> states) {
    //                   if (states.contains(MaterialState.hovered))
    //                     return Colors.grey.shade800;
    //                   if (states.contains(MaterialState.focused) ||
    //                       states.contains(MaterialState.pressed))
    //                     return Colors.grey.shade500;
    //                   return null; // Defer to the widget's default.
    //                 },
    //               ),
    //             ),
    //             onPressed: () {
    //               if (_formKey.currentState.validate()) {
    //                 //Save user data to Firestore
    //                 DatabaseService().updateUserProfile(name, phone, '');
    //                 //Save user data to user profile
    //                 AuthService().updateUserData(name);
    //               }
    //             },
    //             child: Container(
    //               width: 300,
    //               padding: EdgeInsets.symmetric(vertical: 10),
    //               alignment: Alignment.center,
    //               child: Text(
    //                 'CONFIRMAR',
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(
    //                     fontSize: 12,
    //                     fontWeight: FontWeight.w500,
    //                     color: Colors.white),
    //               ),
    //             ),
    //           )
    //         ]),
    //       ),
    //     ),
    //   ]));
    // }

    //New Owner creating user
    return Scaffold(
        body: Stack(children: [
      //Pages
      Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
                maxWidth: 600, maxHeight: 600, minHeight: 500, minWidth: 500),
            child: PageView(
                controller: controller,
                onPageChanged: (int page) {
                  currentpage = page;
                  setState(() {});
                },
                children: [
                  //Initial - create or join business
                  //First Page (About me)
                  Container(
                    constraints: BoxConstraints(minHeight: 400, minWidth: 500),
                    padding: EdgeInsets.all(20),
                    height: 400,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ////// Welcome
                          Text(
                            'Bienvenido!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 50),
                          //Nombre
                          TextFormField(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            validator: (val) =>
                                val.isEmpty ? "Agrega un nombre" : null,
                            autofocus: true,
                            cursorColor: Colors.grey,
                            focusNode: _nameNode,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              label: Text('Nombre'),
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.grey,
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (term) {
                              _nameNode.unfocus();
                              FocusScope.of(context).requestFocus(_tlfNode);
                            },
                            onChanged: (val) {
                              setState(() => name = val);
                            },
                          ),
                          //Whatsapp
                          SizedBox(height: 25),
                          TextFormField(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (val) => val.isEmpty
                                ? "Agrega un celular válido"
                                : (val.length == 10)
                                    ? null
                                    : "El número de celular debe tener 10 caracteres ej: 1112345678",
                            cursorColor: Colors.grey,
                            focusNode: _tlfNode,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              label: Text('Whatsapp'),
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              prefixIcon: Icon(
                                Icons.phone,
                                color: Colors.grey,
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (term) {
                              _tlfNode.unfocus();
                            },
                            onChanged: (val) {
                              setState(() => phone = int.parse(val));
                            },
                          ),
                          //Rol en el negocio
                          SizedBox(height: 25),
                          Text(
                            'Rol en el negocio',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
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
                                'Dueñ@',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black),
                              value: rol,
                              items: dropdownRol.map((i) {
                                return new DropdownMenuItem(
                                  value: i,
                                  child: new Text(i),
                                );
                              }).toList(),
                              onChanged: (x) {
                                setState(() {
                                  rol = x;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                  //Second Page (ABOUT THE NEW BUSINESS)
                  Container(
                    height: 400,
                    constraints: BoxConstraints(minHeight: 400, minWidth: 500),
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ////// About text
                          Text(
                            'Sobre tu negocio',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 50),
                          //Nombre del negocio
                          TextFormField(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            validator: (val) =>
                                val.isEmpty ? "Agrega un nombre" : null,
                            cursorColor: Colors.grey,
                            focusNode: _businessNameNode,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              label: Text('Nombre del negocio'),
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              prefixIcon: Icon(
                                Icons.store,
                                color: Colors.grey,
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (term) {
                              _businessNameNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_businessFieldNode);
                            },
                            onChanged: (val) {
                              setState(() => businessName = val);
                            },
                          ),
                          //Rubro del negocio
                          SizedBox(height: 25),
                          Text(
                            'Rubro',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 5),
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
                                'Gastronómico',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.black),
                              value: businessField,
                              items: businessFieldList.map((i) {
                                return new DropdownMenuItem(
                                  value: i,
                                  child: new Text(i),
                                );
                              }).toList(),
                              onChanged: (x) {
                                setState(() {
                                  businessField = x;
                                });
                              },
                            ),
                          ),
                          //Lugar
                          SizedBox(height: 25),
                          TextFormField(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            validator: (val) => val.isEmpty ? "" : null,
                            cursorColor: Colors.grey,
                            focusNode: _businessLocationNode,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              label: Text('Ubicación'),
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              prefixIcon: Icon(
                                Icons.location_pin,
                                color: Colors.grey,
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (term) {
                              _businessLocationNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_businessSizeNode);
                            },
                            onChanged: (val) {
                              setState(() => businessLocation = val);
                            },
                          ),
                          //Tamaño
                          SizedBox(height: 25),
                          TextFormField(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            validator: (val) =>
                                val.isEmpty ? "Agrega un numero válido" : null,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: Colors.grey,
                            focusNode: _businessSizeNode,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              label: Text(
                                  'No. de personas trabajando en el negocio'),
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.grey,
                              ),
                              errorStyle: TextStyle(
                                  color: Colors.redAccent[700], fontSize: 12),
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(12.0),
                                borderSide: new BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (term) {
                              _businessSizeNode.unfocus();
                              if (_formKey2.currentState.validate()) {
                                controller.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              }
                            },
                            onChanged: (val) {
                              setState(() => businessSize = int.parse(val));
                            },
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                  //Third Page (App intended Usage)
                  Container(
                    height: 400,
                    constraints: BoxConstraints(minHeight: 400, minWidth: 500),
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ////// About text
                          Text(
                            'Para qué quieres usar Denario?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 50),
                          //Tags
                          Container(
                              width: 500,
                              child: Tags(
                                  itemCount: purposeTags.length,
                                  itemBuilder: (int i) {
                                    return ItemTags(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        key: Key(i.toString()),
                                        index: i,
                                        title: purposeTags[i],
                                        textColor: Colors.white,
                                        textActiveColor: Colors.black,
                                        color: Colors.green,
                                        activeColor: Colors.white,
                                        onPressed: (item) {
                                          if (!item.active) {
                                            selectedTags.add(item.title);
                                          } else {
                                            selectedTags.remove(item.title);
                                          }
                                        });
                                  })),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),

      ///Pages navigator Dots
      Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            //Button
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12.0),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.grey.shade800;
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.grey.shade500;
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                final businessID = generateRandomString();

                if (currentpage == 0) {
                  if (_formKey.currentState.validate()) {
                    controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  }
                } else if (currentpage == 1) {
                  if (_formKey2.currentState.validate()) {
                    controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  }
                } else {
                  final User user = FirebaseAuth.instance.currentUser;
                  final String uid = user.uid.toString();
                  //Save user data to Firestore
                  DatabaseService().createUserProfile(uid, name, phone, rol,
                      businessName, businessID, selectedTags);
                  //Create Business Profile
                  // DatabaseService().createUserBusiness(businessName, businessID,
                  //     businessField, businessLocation, businessSize, rol);
                  DatabaseService().createBusinessProfile(
                      uid,
                      rol,
                      businessName,
                      businessID,
                      businessField,
                      businessLocation,
                      businessSize,
                      selectedTags);
                  DatabaseService().createBusinessERPcategories(businessID);
                  DatabaseService().createBusinessERPmapping(businessID);
                  // DatabaseService().createBusinessERPaccountMapping(businessID);
                  DatabaseService().createBusinessProductList(businessID);
                  //Save user data to user profile
                  AuthService().updateUserData(name);
                }
              },
              child: Container(
                width: 300,
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  (currentpage < 2) ? "SIGUIENTE" : 'EMPEZAR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            //Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < totalPages; i++)
                  i == currentpage
                      ? _buildPageIndicator(true)
                      : _buildPageIndicator(false),
              ],
            ),
          ]),
        ),
      ),
    ]));
  }
}
