import 'package:flutter/material.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/shared_screen/loading.dart';

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

  // text field state
  String email = '';
  String password = '';
  String error = '';

  Widget box = SizedBox(
    height: 20.0,
  );

  void pressedRegister() async {
    //if passwors and email are null its enter to if
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      dynamic result = await _auth.registerWithEnailAndPass(email, password);
      if (result == null) {
        setState(() {
          error = 'please supply a valid email';
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
            backgroundColor: Colors.grey[350],
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      box,
                      Text(
                        'Enter details about yourself:',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 20,
                            color: Colors.blueGrey[800]),
                        textAlign: TextAlign.center,
                      ),
                      box,
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey, width: 2.0)),
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      box,
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey, width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueGrey, width: 2.0)),
                        ),
                        obscureText: true,
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      box,
                      RaisedButton(
                        color: Colors.cyan[600],
                        child: Text(
                          'register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: pressedRegister,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      box,
                      OutlineButton(
                        borderSide: BorderSide.none,
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text(
                          'If you already have an account, tap here!',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )),
            resizeToAvoidBottomPadding: false,
          );
  }
}
