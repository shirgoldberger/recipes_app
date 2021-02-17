import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/userInformation.dart';
import 'package:recipes_app/personal/Setting_form.dart';

import 'package:recipes_app/services/auth.dart';
import 'package:recipes_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/personal/userInfoList.dart';

class HomeLogIn extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingPannel() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingForm(),
            );
          });
    }

    // ignore: missing_required_param
    return StreamProvider<List<UserInformation>>.value(
      value: DataBaseService().users,
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
                await _auth.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('setting'),
              onPressed: () => _showSettingPannel(),
            )
          ],
        ),
        body: UserInfoList(),
      ),
    );
  }
}
