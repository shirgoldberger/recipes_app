import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/models/userInformation.dart';
import 'package:recipes_app/screen/Setting_form.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/screen/home_screen/RecipeList.dart';
import 'package:recipes_app/screen/home_screen/logIn/log_in_wrapper.dart';
import 'package:recipes_app/screen/home_screen/plusRecipe.dart';
import 'package:recipes_app/screen/home_screen/recipesFolder.dart';
import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/services/database.dart';
import 'package:provider/provider.dart';

class HomeLogIn extends StatelessWidget {
  final db = Firestore.instance;
  final AuthService _auth = AuthService();
  User user;
  // HomeLogIn(User u) {
  //   user = u;
  // }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    void _showSettingPannel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              child: SettingForm(),
            );
          });
    }

    return StreamProvider<List<Recipe>>.value(
        value: DataBaseService(user.uid).recipe,
        child: Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text('cook book'),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('log out'),
                  onPressed: () async {
                    print("out");
                    print(user.uid);
                    await _auth.signOut();
                    print("done");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LogInWrapper()));
                  },
                ),
                FlatButton.icon(
                  icon: Icon(Icons.settings),
                  label: Text('setting'),
                  onPressed: () => _showSettingPannel(),
                ),
                FlatButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('plus'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlusRecipe()));
                    })
              ],
            ),
            body: RecipeFolder(false)));
  }
}
