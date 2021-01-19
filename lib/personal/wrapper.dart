import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/personal/Authentication.dart';
import 'package:recipes_app/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    //return home or Authentication
    return Authentication();
  }
}
