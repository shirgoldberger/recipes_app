import 'package:flutter/material.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import '../../shared_screen/config.dart';

// ignore: must_be_immutable
class ChangeNameGroup extends StatefulWidget {
  List userId = [];
  String groupId;
  String groupName;
  bool done = false;
  ChangeNameGroup(List _userId, String _groupId, String _groupName) {
    this.userId = _userId.toList();
    this.groupId = _groupId;
    this.groupName = _groupName;
  }

  @override
  _ChangeNameGroupState createState() => _ChangeNameGroupState();
}

class _ChangeNameGroupState extends State<ChangeNameGroup> {
  String error = '';
  bool findUser = false;
  String emailTocheck = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(children: <Widget>[
          Flexible(
              child: ListView(children: [
            heightBox(10),
            title(),
            heightBox(10),
            nameBox(),
            updateBox(),
          ]))
        ]));
  }

  Widget nameBox() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: widget.groupName,
      ),
      validator: (val) => val.isEmpty ? widget.groupName : null,
      onChanged: (val) {
        setState(() {
          widget.groupName = val;
          widget.done = true;
        });
      },
    );
  }

  Widget title() {
    return Text("Change group name:");
  }

  Widget updateBox() {
    return MaterialButton(
        minWidth: 200.0,
        height: 35,
        color: appBarBackgroundColor,
        child: Text('Update name',
            style: TextStyle(fontSize: 16.0, color: Colors.white)),
        onPressed: () {
          saveName(emailTocheck);
        });
  }

  // database function //
  Future<void> saveName(String email) async {
    if (widget.groupName != null) {
      if (widget.done) {
        await GroupFromDB.updateGroupName(
            widget.groupId, widget.groupName, widget.userId);
      }
      Navigator.pop(context, widget.groupName);
    }
  }
}
