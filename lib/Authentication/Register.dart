import 'package:denario/Backend/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _repeatPasswordNode = FocusNode();

  //Text field state
  String email = "";
  String password = "";
  String repeatPassword = "";
  String error = "";
  bool loading = false;

  bool showPass1 = false;
  bool showPass2 = false;

  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Container(
          width: 400,
          // constraints: BoxConstraints(minHeight: 400, maxHeight: 600),
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
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ////// Logo
                Container(
                    height: 100,
                    child: Image(
                        image: AssetImage('images/Denario Tag.png'),
                        height: 100)),
                SizedBox(height: 15),

                ///Email input
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
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    errorStyle:
                        TextStyle(color: Colors.redAccent[700], fontSize: 12),
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
                    label: Text('contraseña'),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPass1 = !showPass1;
                          });
                        },
                        icon: (showPass1)
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                size: 18,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                size: 18,
                              )),
                    errorStyle:
                        TextStyle(color: Colors.redAccent[700], fontSize: 12),
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
                  obscureText: (showPass1) ? false : true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),

                ///Repeat Password input
                SizedBox(height: 25),
                TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  validator: (val) =>
                      (val != password) ? "Las contraseñas no coinciden" : null,
                  cursorColor: Colors.grey,
                  focusNode: _repeatPasswordNode,
                  decoration: InputDecoration(
                    label: Text('repetir contraseña'),
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPass2 = !showPass2;
                          });
                        },
                        icon: (showPass2)
                            ? Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                                size: 18,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Colors.grey,
                                size: 18,
                              )),
                    errorStyle:
                        TextStyle(color: Colors.redAccent[700], fontSize: 12),
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
                  obscureText: (showPass2) ? false : true,
                  onChanged: (val) {
                    setState(() => repeatPassword = val);
                  },
                  onFieldSubmitted: (val) {
                    //Loading
                    setState(() => loading = true);
                    if (_formKey.currentState.validate()) {
                      //Loading
                      setState(() => loading = true);

                      try {
                        AuthService()
                            .registerWithEmailAndPassword(email, password);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Wrapper()));
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          error = 'Oops.. Algo salió mal. $e';
                          loading = false;
                        });
                        // return null
                      }
                    }
                  },
                ),

                ///Button Register
                SizedBox(height: 50),
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
                  onPressed: () async {
                    //Loading
                    setState(() => loading = true);
                    if (_formKey.currentState.validate()) {
                      //Loading
                      setState(() => loading = true);

                      try {
                        AuthService()
                            .registerWithEmailAndPassword(email, password);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Wrapper()));
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          error = 'Oops.. Algo salió mal. $e';
                          loading = false;
                        });
                        // return null
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "REGISTRARME",
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
                  style:
                      TextStyle(color: Colors.redAccent[700], fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
                //SignIn Instead
                SizedBox(height: 5.0),
                TextButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: Text('Entrar',
                        style: TextStyle(color: Colors.black45, fontSize: 12)))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
