import 'dart:math';

import 'package:denario/Backend/DatabaseService.dart';
import 'package:denario/Loading.dart';
import 'package:denario/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateNewBusiness extends StatefulWidget {
  const CreateNewBusiness({Key key}) : super(key: key);

  @override
  State<CreateNewBusiness> createState() => _CreateNewBusinessState();
}

class _CreateNewBusinessState extends State<CreateNewBusiness> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _businessNameNode = FocusNode();
  final FocusNode _businessFieldNode = FocusNode();
  final FocusNode _businessLocationNode = FocusNode();
  final FocusNode _businessSizeNode = FocusNode();

  String rol = 'Dueñ@';
  List dropdownRol = [
    'Dueñ@', //Vista de todos los modulos
    'Encargad@', //Vistas de todos - PnL y Stats?
    'Moz@', //Solo modulo de POS
    'Cajer@', //Solo modulo POS + Daily + Gastos
    'Contador(a)', //Soolo modulo de PnL, vista de gastos, vista de ventas
    'Otro'
  ];
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

  String generateRandomString() {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(15,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserData>(context);

    if (userProfile == null) {
      return Loading();
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 16,
              ))),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20.0),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ////// About text
                  SizedBox(height: 30),
                  Text(
                    'Sobre tu negocio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  //Nombre del negocio
                  Container(
                    width: 350,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      validator: (val) =>
                          val.isEmpty ? "Agrega un nombre" : null,
                      cursorColor: Colors.grey,
                      focusNode: _businessNameNode,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: Text('Nombre del negocio'),
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
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
                        _businessNameNode.unfocus();
                        FocusScope.of(context).requestFocus(_businessFieldNode);
                      },
                      onChanged: (val) {
                        setState(() => businessName = val);
                      },
                    ),
                  ),
                  //Rubro del negocio
                  SizedBox(height: 25),
                  Container(
                    width: 350,
                    child: Text(
                      'Rubro',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 350,
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
                  Container(
                    width: 350,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      validator: (val) => val.isEmpty ? "" : null,
                      cursorColor: Colors.grey,
                      focusNode: _businessLocationNode,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: Text('Ubicación'),
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
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
                        FocusScope.of(context).requestFocus(_businessSizeNode);
                      },
                      onChanged: (val) {
                        setState(() => businessLocation = val);
                      },
                    ),
                  ),
                  //Tamaño
                  SizedBox(height: 25),
                  Container(
                    width: 350,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      validator: (val) =>
                          val.isEmpty ? "Agrega un numero válido" : null,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      cursorColor: Colors.grey,
                      focusNode: _businessSizeNode,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: Text('No. de personas en el negocio'),
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
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
                      },
                      onChanged: (val) {
                        setState(() => businessSize = int.parse(val));
                      },
                    ),
                  ),
                  SizedBox(height: 25),

                  //Button
                  ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
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

                      if (_formKey.currentState.validate()) {
                        final User user = FirebaseAuth.instance.currentUser;
                        final String uid = user.uid.toString();
                        //Save user data to Firestore
                        DatabaseService().updateUserBusinessProfile({
                          'Business ID': businessID,
                          'Business Name': businessName,
                          'Business Rol': rol,
                          'Table View': false
                        }, uid);
                        //Create Business Profile
                        DatabaseService().createBusinessProfile(
                            uid,
                            rol,
                            businessName,
                            businessID,
                            businessField,
                            businessLocation,
                            businessSize, []);
                        DatabaseService()
                            .createBusinessERPcategories(businessID);
                        DatabaseService().createBusinessERPmapping(businessID);
                        // DatabaseService()
                        //     .createBusinessERPaccountMapping(businessID);
                        DatabaseService().createBusinessProductList(businessID);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      width: 300,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(
                        'Crear',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
