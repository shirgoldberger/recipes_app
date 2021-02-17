import 'package:flutter/material.dart';
import 'package:recipes_app/models/userInformation.dart';

class ShowInfo extends StatelessWidget {
  final userDetailes;
  ShowInfo({this.userDetailes});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.brown[700],
          ),
          title: Text(userDetailes.firstName),
          subtitle: Text(userDetailes.lastName),
        ),
      ),
    );
  }
}
