import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based firebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // sign in anonymous
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

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPass(
      String email, String pass, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      FirebaseUser user = result.user;
      // create an new document fot the new user with this uid
      await DataBaseService(user.uid)
          .updateUserData(name, '', '', 0, user.email, '');
      return _userFromFirebaseUser(user);
    } catch (e) {
      return e.toString();
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPass(String email, String pass) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("erorr: " + e.toString());
      return e.toString();
    }
  }
}
