import 'package:denario/Backend/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddUserDialog extends StatefulWidget {
  final String businessID;
  final String businessName;
  AddUserDialog(this.businessID, this.businessName);

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  //Text field state
  String name = "";
  String rol = "Encargad@";
  String email = "";
  String password = "";
  String error = "";

  List dropdownRol = [
    'Dueñ@', //Vista de todos los modulos
    'Encargad@', //Vistas de todos - PnL y Stats?
    'Moz@', //Solo modulo de POS
    'Cajer@', //Solo modulo POS + Daily + Gastos
    'Contador(a)', //Soolo modulo de PnL, vista de gastos, vista de ventas
    'Otro'
  ];

  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 500,
          width: 400,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Close and Title
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(width: 50),
                      Spacer(),
                      //Title
                      Container(
                        width: 200,
                        child: Text(
                          'Crear Nuevo Usuario',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Spacer(),
                      //Close
                      Container(
                        width: 50,
                        child: IconButton(
                            splashRadius: 15,
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                            iconSize: 20.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ///Name
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        validator: (val) =>
                            val == '' ? "Agrega un nombre" : null,
                        cursorColor: Colors.grey,
                        focusNode: _nameNode,
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
                        },
                        onChanged: (val) {
                          setState(() => name = val);
                        },
                      ),

                      ///Rol
                      SizedBox(height: 25),
                      Text(
                        'Rol en el negocio',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[350]),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton(
                          underline: SizedBox(),
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

                      ///Email input
                      SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        validator: (val) => !(emailValid.hasMatch(val))
                            ? "Agrega un email válido"
                            : null,
                        cursorColor: Colors.grey,
                        focusNode: _emailNode,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          label: Text('email'),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          prefixIcon: Icon(
                            Icons.email_outlined,
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
                          _emailNode.unfocus();
                          FocusScope.of(context).requestFocus(_passwordNode);
                        },
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),

                      ///Password input
                      SizedBox(height: 25),
                      TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        validator: (val) => val.length < 6
                            ? "La contraseña debe tener al menos 6 caracteres"
                            : null,
                        cursorColor: Colors.grey,
                        focusNode: _passwordNode,
                        decoration: InputDecoration(
                          label: Text('Contraseña'),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 12),
                          prefixIcon: Icon(
                            Icons.lock,
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
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),

                      ///Button Register
                      SizedBox(height: 50),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color>(
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              FirebaseApp app = await Firebase.initializeApp(
                                  name: 'Secondary',
                                  options: Firebase.app().options);
                              UserCredential userCredential =
                                  await FirebaseAuth.instanceFor(app: app)
                                      .createUserWithEmailAndPassword(
                                          email: email, password: password);
                              DatabaseService().createUserProfile(
                                  userCredential.user.uid,
                                  name,
                                  0,
                                  rol,
                                  widget.businessName,
                                  widget.businessID,
                                  ['Sub-usuario']);
                              DatabaseService().addUsertoBusiness(
                                  widget.businessID, userCredential.user.uid);

                              await app.delete();
                              Navigator.of(context).pop();
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                error = 'Oops.. Algo salió mal. $e';
                              });
                              // return null
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          child: Text(
                            "REGISTRAR USUARIO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      //Show error if threr is an error signing in
                      SizedBox(height: 5.0),
                      Text(
                        error,
                        style: TextStyle(
                            color: Colors.redAccent[700], fontSize: 12.0),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                //email
                //Pass
                //Name
                //Rol
              ],
            ),
          ),
        ));
  }
}
