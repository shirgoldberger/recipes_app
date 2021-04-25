import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/user.dart';
import 'homeLogIn.dart';
import 'logIn/Authentication.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return home or Authentication
    //if the user is null - no user us cinnect
    if (user == null) {
      return Authentication();
    } else {
      return HomeLogIn(user.uid);
    }
  }
}
