import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/personal_screen/logIn/register.dart';
import 'package:recipes_app/screens/recipes/recipesFolder.dart';
import 'package:recipes_app/services/database.dart';
import '../main.dart';

// ignore: must_be_immutable
class RecipesBookPage extends StatelessWidget {
  static String tag = 'book-page';
  static const TextStyle optionStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey);
  String user;
  RecipesBookPage(String _user) {
    user = _user;
  }

  @override
  Widget build(BuildContext context) {
    if (user == "") {
      return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: Column(
            children: [
              box,
              title(),
              box,
              // ignore: deprecated_member_use
              // FlatButton.icon(
              //   minWidth: 110,
              //   color: Colors.blueGrey[400],
              //   icon: Icon(Icons.person_pin, color: Colors.white),
              //   label: Text('Log In', style: TextStyle(color: Colors.white)),
              //   onPressed: () async {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Personal()));
              //   },
              // ),
              // box,
              // // ignore: deprecated_member_use
              // FlatButton.icon(
              //   minWidth: 110,
              //   color: Colors.blueGrey[400],
              //   icon:
              //       Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
              //   label: Text('Sign Up', style: TextStyle(color: Colors.white)),
              //   onPressed: () async {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Register()));
              //   },
              // ),
            ],
          ));
    } else {
      // ignore: missing_required_param
      return StreamProvider<List<Recipe>>.value(
          value: DataBaseService(user).recipe,
          child: Scaffold(
              backgroundColor: Colors.blueGrey[50],
              appBar: AppBar(
                title: Text(
                  'My Book',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                  ),
                ),
                backgroundColor: Colors.blueGrey[700],
                elevation: 0.0,
                actions: <Widget>[],
              ),
              body: RecipeFolder(false)));
    }
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        'Cook Book',
        style: TextStyle(fontFamily: logoFont),
      ),
      backgroundColor: appBarBackgroundColor,
      elevation: 0.0,
    );
  }

  Widget title() {
    return Text(
      'Hello!\n If you want to create recipes book, you need to log in or sign up first.',
      style:
          TextStyle(fontFamily: ralewayFont, fontSize: 20, color: titleColor),
      textAlign: TextAlign.center,
    );
  }
}
