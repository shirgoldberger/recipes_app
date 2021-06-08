/// here user can reset his password ///

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:recipes_app/services/auth.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatefulWidget {
  AuthService auth;
  ForgetPassword(AuthService _auth) {
    auth = _auth;
  }
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String _warning;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar(),
      body: ListView(children: [
        showAlert(),
        Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  box,
                  box,
                  emailField(),
                  errorText(),
                  box,
                  resetPassword(),
                  box,
                  goToSignIn()
                ]))),
      ]),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget appBar() {
    return AppBar(
      title: Text(appName, style: TextStyle(fontFamily: logoFont)),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
    );
  }

  Widget errorText() {
    return Text(
      error,
      style: TextStyle(color: Colors.red),
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

  Widget resetPassword() {
    error = "";
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
          'Submit',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: reset,
        animationDuration: Duration(seconds: 2),
      ),
    );
  }

  void reset() async {
    try {
      await widget.auth.sendPasswordResetEmail(email);
    } catch (e) {
      if (e.toString() == errorHasNoUser) {
        setState(() {
          error = "There is no user with this mail.";
        });
      }
      return;
    }
    setState(() {
      _warning = "A password reset link has been sent to $email";
    });
  }

  Widget goToSignIn() {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Go back to sign in',
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.green[200],
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
