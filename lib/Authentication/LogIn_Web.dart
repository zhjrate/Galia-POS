import 'package:denario/Backend/auth.dart';
import 'package:denario/Home.dart';
import 'package:denario/Loading.dart';
import 'package:denario/Wrapper.dart';
import 'package:denario/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//////////////////// //////////////////////// /////// This is were we manage the Sign in/Register Page /////////////////////////////////////
class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

//Text field state
  String email = "";
  String password = "";
  String error = "";

  goHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

////////////////////////////////////////// Start Widget tree visible in Screen ///////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return loading
        ? SafeArea(
            child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: Loading()),
          )
        : SafeArea(
            child: Scaffold(
                body: Center(
              child: Container(
                width: 400,
                constraints: BoxConstraints(minHeight: 300, maxHeight: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                      color: Colors.grey[200],
                      offset: new Offset(15.0, 15.0),
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
                        validator: (val) =>
                            val.isEmpty ? "Agrega un email" : null,
                        cursorColor: Colors.grey,
                        focusNode: _emailNode,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: "email",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            errorStyle: TextStyle(
                                color: Colors.redAccent[700], fontSize: 12),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
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
                            hintText: "contraseña",
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            errorStyle: TextStyle(
                                color: Colors.redAccent[700], fontSize: 12),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey))),
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
                              ;
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () async {
                          print(FirebaseAuth.instance.currentUser);
                          if (_formKey.currentState.validate()) {
                            //Loading
                            setState(() => loading = true);

                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wrapper()));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                setState(() {
                                  error =
                                      'No encontramos el usuario $email. Revisa de nuevo';
                                  loading = false;
                                });
                              } else if (e.code == 'wrong-password') {
                                setState(() {
                                  error =
                                      'Contraseña incorrecta, intenta de nuevo';
                                  loading = false;
                                });
                              } else {
                                setState(() {
                                  error = 'Oops.. Algo salió mal';
                                  loading = false;
                                });
                              }
                            } catch (e) {
                              setState(() {
                                error = 'Oops.. Algo salió mal';
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
                            "ENTRAR",
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
              ),
            )),
          );
  }
}
