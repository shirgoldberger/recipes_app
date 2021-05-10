import 'package:flutter/material.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import '../../../config.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _isHidden = true;

  // text field state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';

  // error text
  String error = '';

  void pressedRegister() async {
    // if password and email are null its enter into the if statement
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      // create new user
      dynamic result =
          await _auth.registerWithEmailAndPass(email, password, name);
      // check errors:
      if (result == errorInvalidEmail) {
        setState(() {
          error = 'Please supply a valid email';
          loading = false;
        });
      } else if (result == errorEmailAlreadyInUse) {
        setState(() {
          error = 'There is a registered user with this email address';
          loading = false;
        });
      } else if (result == errorNetworkRequestFaild) {
        setState(() {
          error =
              'Network connection failed. Please check your internet connection and try again';
          loading = false;
        });
      } else if (result == null) {
        setState(() {
          error = 'Something happend. Please try again';
          loading = false;
        });
      }
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
                      title(),
                      box,
                      emailField(),
                      box,
                      nameField(),
                      box,
                      passwordField(),
                      box,
                      confirmPasswordField(),
                      box,
                      registerButton(),
                      errorText(),
                      box,
                      alreadyAcoountButton()
                    ],
                  ),
                )),
            resizeToAvoidBottomInset: false,
          );
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        appName,
        style: TextStyle(fontFamily: 'LogoFont'),
      ),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
    );
  }

  Widget title() {
    return Text(
      'Enter details about yourself:',
      style:
          TextStyle(fontFamily: ralewayFont, fontSize: 20, color: titleColor),
      textAlign: TextAlign.center,
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
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

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Name',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
      ),
      validator: (val) => val.isEmpty ? 'Enter a name' : null,
      onChanged: (val) {
        setState(() => name = val);
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
        suffix: InkWell(
          onTap: _togglePasswordView,
          child: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        hintText: 'Password',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
      ),
      obscureText: _isHidden,
      validator: (val) =>
          val.length < 6 ? 'Enter a password with 6+ characters' : null,
      onChanged: (val) {
        setState(() => password = val);
      },
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Widget confirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Confirm password',
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0)),
      ),
      obscureText: true,
      validator: (val) => val != password ? 'Not match password' : null,
      onChanged: (val) {
        setState(() => confirmPassword = val);
      },
    );
  }

  Widget registerButton() {
    // ignore: deprecated_member_use
    return RaisedButton(
      color: mainButtonColor,
      child: Text(
        'Register',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: pressedRegister,
    );
  }

  Widget alreadyAcoountButton() {
    // ignore: deprecated_member_use
    return OutlineButton(
      borderSide: BorderSide.none,
      onPressed: () {
        widget.toggleView();
      },
      child: Text(
        'If you already have an account, tap here!',
        style: TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget errorText() {
    return Text(
      error,
      style: TextStyle(color: errorColor, fontSize: 14.0),
    );
  }
}
