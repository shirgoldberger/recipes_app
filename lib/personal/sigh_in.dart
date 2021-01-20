import 'package:flutter/material.dart';
import 'package:recipes_app/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //text field state
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('sign in to recipe app'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment(-0.9, -0.1),
                    child: Text(
                      'Email:',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Align(
                    alignment: Alignment(-0.9, -0.1),
                    child: Text(
                      'Password:',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                TextFormField(
                  validator: (val) =>
                      val.length < 6 ? 'Enter a password 6+ chars long' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                RaisedButton(
                    color: Colors.pink[300],
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      //if passwors and email are null its enter to if
                      if (_formKey.currentState.validate()) {
                        dynamic result =
                            await _auth.signInWithEnailAndPass(email, password);
                        if (result == null) {
                          setState(() {
                            error =
                                'Could not sign in - check your email and password again';
                          });
                        }
                      }
                    }),
                SizedBox(height: 20.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  'If you do not have an account in the app, create an account here',
                  style: TextStyle(color: Colors.grey[800], fontSize: 14.0),
                ),
                OutlineButton(
                  onPressed: () {
                    widget.toggleView();
                  },
                  child: Text('Register to cook-book app'),
                ),
              ],
            ),
          )),
    );
  }
}
