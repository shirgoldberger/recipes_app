import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // create user object based firebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, verified: user.isEmailVerified)
        : null;
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
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
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
      user.sendEmailVerification();
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
      if (!user.isEmailVerified) {
        return "Email not verify";
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      return e.toString();
    }
  }

  Future handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    try {
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;
      await DataBaseService(user.uid)
          .updateUserData(user.email, '', '', 0, user.email, '');
      return _userFromFirebaseUser(user);
    } catch (e) {}
  }

  Future deleteAccount() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      await user.delete();
    }
  }

  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
