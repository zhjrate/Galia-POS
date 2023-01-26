import 'package:denario/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCGgaI2hxuYbr8yiqHuPStscPHlV08pmso",
        appId: "1:414051585564:web:1a01eea9c4ed991ae459d9",
        messagingSenderId: "414051585564",
        projectId: "cafe-galia",
        storageBucket: 'cafe-galia.appspot.com'),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final bool signedOut;
  MyApp({this.signedOut});
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Denario POS',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Colors.black,
          hoverColor: Colors.white70,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}
