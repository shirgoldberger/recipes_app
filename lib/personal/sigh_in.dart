import 'package:flutter/material.dart';
import 'package:recipes_app/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
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
        child: RaisedButton(
            child: Text('sign in annon'),
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if (result == null) {
                print("error sign in");
              } else {
                print("sign in");
                print(result.uid);
              }
            }),
      ),
    );
  }
}
