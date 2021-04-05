import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screens/home_screen/logIn/register.dart';
import 'package:recipes_app/screens/home_screen/recipesFolder.dart';
import 'package:recipes_app/services/database.dart';

import '../main.dart';
import 'home_screen/logIn/log_in_wrapper.dart';

class RecipesBookPage extends StatelessWidget {
  static String tag = 'book-page';
  static const TextStyle optionStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey);
  Widget box = SizedBox(
    height: 20.0,
  );
  String user;
  RecipesBookPage(String _user) {
    user = _user;
  }

  @override
  Widget build(BuildContext context) {
    if (user == "") {
      return Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            title: Text(
              'Cook Book',
              style: TextStyle(fontFamily: 'LogoFont'),
            ),
            backgroundColor: Colors.blueGrey[700],
            elevation: 0.0,
            actions: <Widget>[],
          ),
          body: Column(
            children: [
              box,
              Text(
                'Hello!\n If you want to create recipes book, you need to log in or sign up first.',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 20,
                    color: Colors.blueGrey[800]),
                textAlign: TextAlign.center,
              ),
              box,
              FlatButton.icon(
                minWidth: 110,
                color: Colors.blueGrey[400],
                icon: Icon(Icons.person_pin, color: Colors.white),
                label: Text('Log In', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Personal()));
                },
              ),
              box,
              FlatButton.icon(
                minWidth: 110,
                color: Colors.blueGrey[400],
                icon:
                    Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
                label: Text('Sign Up', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Register()));
                },
              ),
            ],
          ));
    } else {
      return StreamProvider<List<Recipe>>.value(
          value: DataBaseService(user).recipe,
          child: Scaffold(
              backgroundColor: Colors.brown[50],
              appBar: AppBar(
                title: Text('cook book'),
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                actions: <Widget>[],
              ),
              body: RecipeFolder(false)));
    }
  }
}
