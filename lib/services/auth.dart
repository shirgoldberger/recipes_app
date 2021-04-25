import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based firebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //sign in anonamis
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register eith email and password
  Future registerWithEnailAndPass(String email, String pass) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser user = result.user;
      //create an new document fot the new user with this uid
      await DataBaseService(user.uid)
          .updateUserData('', '', '', 0, user.email, '');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("errorrrr: " + e.toString());
      //PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null, null)
      ////PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)
      return e.toString();
    }
  }

  //sign in with email and password
  Future signInWithEnailAndPass(String email, String pass) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
