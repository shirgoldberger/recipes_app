import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipes_app/screens/personal_screen/homeLogIn.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import '../../../config.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  // error text
  String error = '';

  // log in button pressed function
  void pressedLogIn() async {
    // if passwors and email are null its enter to 'if'
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      // try log in
      dynamic result = await _auth.signInWithEmailAndPass(email, password);
      if (result == errorNetworkRequestFaild) {
        setState(() {
          loading = false;
          error =
              'Network connection failed. Please connect to the internet and try again';
        });
        return;
      }
      if (result == "Email not verify") {
        setState(() {
          loading = false;
          error = result;
        });
        return;
      }
      if (result == null) {
        setState(() {
          loading = false;
          error = 'Could not log in - check your email and password again';
        });
        return;
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeLogIn(result.uid)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: appBar(),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      box,
                      helloText(),
                      titleText(),
                      box,
                      emailField(),
                      box,
                      passwordField(),
                      box,
                      logInButton(),
                      box,
                      errorText(),
                      signInWithGoogleButton(),
                      box,
                      registerButton(),
                      box,
                      image(),
                    ],
                  ),
                )),
            resizeToAvoidBottomInset: false,
          );
  }

  Widget helloText() {
    return Text(
      "Hello!",
      style:
          TextStyle(fontFamily: ralewayFont, fontSize: 20, color: titleColor),
      textAlign: TextAlign.center,
    );
  }

  Widget titleText() {
    return Text(
      "Log in and enjoy from great recipes!",
      style: TextStyle(
          fontFamily: ralewayFont, fontSize: 15, height: 2, color: titleColor),
      textAlign: TextAlign.center,
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'enter email...',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
      ),
      validator: (val) => val.isEmpty ? 'Enter an email' : null,
      onChanged: (val) {
        setState(() => email = val);
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'enter password...',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
      ),
      validator: (val) =>
          val.length < 6 ? 'Enter a password with 6+ characters' : null,
      obscureText: true,
      onChanged: (val) {
        setState(() => password = val);
      },
    );
  }

  Widget logInButton() {
    return SizedBox(
      width: 320,
      height: 30.0,
      // ignore: deprecated_member_use
      child: RaisedButton(
        padding: EdgeInsets.only(left: 1.0, right: 1.0),
        focusColor: Colors.black,
        color: Colors.blueGrey[500],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Text(
          'Log In',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: pressedLogIn,
        animationDuration: Duration(seconds: 2),
      ),
    );
  }

  Widget errorText() {
    return Text(
      error,
      style: TextStyle(color: errorColor, fontSize: 14.0),
    );
  }

  Widget registerButton() {
    // ignore: deprecated_member_use
    return OutlineButton(
      borderSide: BorderSide.none,
      onPressed: () {
        widget.toggleView();
      },
      child: Text(
        'Don\'t have an account?\n Tap here to register',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget signInWithGoogleButton() {
    // ignore: deprecated_member_use
    return OutlineButton(
      borderSide: BorderSide.none,
      onPressed: _signInWithGoogle,
      child: Text(
        'Sign-In with Google',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _signInWithGoogle() async {
    await _auth.handleSignIn();
  }

  Widget image() {
    return Image.asset(chefImagePath,
        height: 50,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain);
  }

  Widget appBar() {
    return AppBar(
      title: Text(appName, style: TextStyle(fontFamily: logoFont)),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
    );
  }
}
