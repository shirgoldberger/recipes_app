import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/personal/wrapper.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/models/user.dart';

class LogInWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
