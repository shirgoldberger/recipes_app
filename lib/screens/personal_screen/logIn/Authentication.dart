/// register or sign in page ///

import 'package:flutter/material.dart';
import 'sighIn.dart';
import 'register.dart';

// ignore: must_be_immutable
class Authentication extends StatefulWidget {
  bool showSignIn = true;
  Authentication({this.showSignIn});
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  void toggleview() {
    setState(() {
      widget.showSignIn = !widget.showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showSignIn) {
      return SignIn(toggleView: toggleview);
    } else {
      return Register(toggleView: toggleview);
    }
  }
}
