import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/recipes/create_recipe/addRecipeIngredients.dart';
import 'package:recipes_app/screens/recipes/create_recipe/setRecipeDetails.dart';
import '../../../config.dart';
import 'uploadRecipeImage.dart';

class MainCreateRecipe extends StatefulWidget {
  final db = Firestore.instance;
  @override
  _MainCreateRecipeState createState() => _MainCreateRecipeState();
}

class _MainCreateRecipeState extends State<MainCreateRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            appName,
            style: TextStyle(fontFamily: 'LogoFont'),
          ),
          backgroundColor: appBarBackgroundColor,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [
              box,
              box,
              Text(
                'Hi!\nHere you can create your new recipe in the app. For do that, you need to fill all the recipe\'s details.\n' +
                    'You can go back and change whatever you want. Enjoy!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontFamily: 'DescriptionFont'),
              ),
              getStartedButton()
            ],
          ),
        ));
  }

  Widget getStartedButton() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            width: 180,
            height: 50,
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: Colors.blueGrey[400],
                borderRadius: BorderRadius.circular(10.0)),
            child: FlatButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetRecipeDetails()))
              },
              child: Text(
                "Get Started",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
