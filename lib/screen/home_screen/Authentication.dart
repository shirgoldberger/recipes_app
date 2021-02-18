import 'package:flutter/material.dart';
import 'package:recipes_app/screen/home_screen/sigh_in.dart';

import 'package:recipes_app/screen/home_screen/register.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showSignIn = true;

  void toggleview() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleview);
    } else {
      return Register(toggleView: toggleview);
    }
  }
}
