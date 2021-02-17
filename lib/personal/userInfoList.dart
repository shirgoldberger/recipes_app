import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/models/userInformation.dart';
import 'package:recipes_app/personal/showInfo.dart';

class UserInfoList extends StatefulWidget {
  @override
  _UserInfoListState createState() => _UserInfoListState();
}

checkUser(UserInformation u) {}

class _UserInfoListState extends State<UserInfoList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<List<UserInformation>>(context) ?? [];
    user.forEach((user) {
      print(user.age);
      print(user.email);
      print(user.firstName);
    });

    return ListView.builder(
        itemCount: user.length,
        itemBuilder: (context, index) {
          return ShowInfo(
            userDetailes: user[index],
          );
        });
  }
}
