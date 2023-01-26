import 'package:denario/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name;

  //create user object based on firebase user
  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //Get UID for Firestore collection calls
  Future<String> getcurrentUID() async {
    return (_auth.currentUser).uid;
  }

  //Auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      if (user != null) {
        print('User is ${user.uid}');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña es muy débil');
      } else if (e.code == 'email-already-in-use') {
        print('El email ya existe para un usuario');
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Update User Profile Data
  Future updateUserData(String displayName) async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.updateDisplayName(displayName);
      }
    } catch (e) {
      print(e);
    }
  }

  //Sing Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
