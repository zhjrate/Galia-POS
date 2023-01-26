import 'package:denario/Authentication/Onboarding.dart';
import 'package:flutter/material.dart';

class InitOnboarding extends StatefulWidget {
  const InitOnboarding({Key key}) : super(key: key);

  @override
  State<InitOnboarding> createState() => _InitOnboardingState();
}

class _InitOnboardingState extends State<InitOnboarding> {
  bool starting = true;
  bool newBusiness;

  @override
  Widget build(BuildContext context) {
    if (starting) {
      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Title
                Text(
                  '¡Hola!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Cómo te gustaría iniciar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //My business
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        setState(() {
                          starting = false;
                          newBusiness = true;
                        });
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Icon
                            Icon(Icons.store, size: 16, color: Colors.black),
                            SizedBox(width: 10),
                            //Name
                            Text(
                              'Crear un nuevo perfil para mi negocio',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                    //Others business
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        setState(() {
                          starting = false;
                          newBusiness = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //Icon
                            Icon(Icons.person_add,
                                size: 16, color: Colors.black),
                            SizedBox(width: 10),
                            //Name
                            Text(
                              'Unirme aun negocio existente',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Onboarding();
    }
  }
}
