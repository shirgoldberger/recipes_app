import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/screen/home.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/wrapper.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
