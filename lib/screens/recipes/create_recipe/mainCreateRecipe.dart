import 'package:flutter/material.dart';
import 'package:recipes_app/screens/recipes/create_recipe/setRecipeDetails.dart';
import '../../../config.dart';

class MainCreateRecipe extends StatefulWidget {
  String username;
  String uid;
  MainCreateRecipe(String _username, String _uid) {
    username = _username;
    uid = _uid;
  }
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
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: [box, box, title(), getStartedButton()],
          ),
        ));
  }

  Widget getStartedButton() {
    return Container(
      width: 180,
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      margin:
          const EdgeInsets.only(top: 30, left: 20.0, right: 20.0, bottom: 20.0),
      decoration: BoxDecoration(
          color: Colors.blueGrey[400],
          borderRadius: BorderRadius.circular(10.0)),
      child: FlatButton(
        onPressed: () => {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(seconds: 0),
                  pageBuilder: (context, animation1, animation2) =>
                      SetRecipeDetails(widget.username, widget.uid)))
        },
        child: Text(
          "Get Started",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget title() {
    return Column(children: [
      Text(
        'Hi ' + widget.username + '!',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 25, fontFamily: 'AcmeFont', fontWeight: FontWeight.bold),
      ),
      box,
      Text(
        'Here you can create your new recipe in the app. For do that, you need to fill all the recipe\'s details.\n' +
            'You can go back and change whatever you want. Enjoy!',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, fontFamily: 'DescriptionFont'),
      )
    ]);
  }
}
