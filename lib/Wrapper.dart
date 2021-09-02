import 'package:denario/Authentication/LogIn_Web.dart';
import 'package:denario/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User user;

  @override
  void initState() {
    _auth.userChanges().listen((event) => setState(() => user = event));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return LogIn();
    } else {
      return Home();
    }
  }
}
