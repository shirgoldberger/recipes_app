import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/screens/home.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/models/user.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
