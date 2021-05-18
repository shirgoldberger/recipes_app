import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'groupRecipeList.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'package:recipes_app/config.dart';

// ignore: must_be_immutable
class GroupList extends StatefulWidget {
  String uid;
  List<String> groupName = [];
  List<String> groupId = [];
  bool doneLoad = false;

  GroupList(String _uid) {
    this.uid = _uid;
  }

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      getGroups();
      return Loading();
    } else {
      return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(),
          body: Column(children: <Widget>[
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: widget.groupId.length > 0 ? groupsList() : emptyMessage(),
            ))
          ]));
    }
  }

  Widget appBar() {
    return AppBar(
      title: Text(
        'Your Groups',
        style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
      ),
      backgroundColor: appBarBackgroundColor,
    );
  }

  Widget groupsList() {
    return ListView.builder(
        itemCount: widget.groupId.length,
        itemBuilder: (context, index) {
          return groupTitle(index);
        });
  }

  Widget groupTitle(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.white)),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupRecipeList(widget.groupId[index],
                      widget.groupName[index], widget.uid)));
        },
        padding: EdgeInsets.all(20.0),
        color: subButtonColor,
        textColor: Colors.white,
        child: groupName(index),
      ),
    );
  }

  Widget emptyMessage() {
    return Text("you dont have any group// kets create new one!",
        style: TextStyle(fontSize: 25, fontFamily: 'Raleway'));
  }

  Widget groupName(int index) {
    return Text(widget.groupName[index],
        style: TextStyle(fontSize: 25, fontFamily: 'Raleway'));
  }

  // database function //
  Future<void> getGroups() async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('groups')
        .getDocuments();
    snap.documents.forEach((element) async {
      setState(() {
        widget.groupId.add(element.data['groupId']);
        widget.groupName.add(element.data['groupName']);
      });
    });
    setState(() {
      widget.doneLoad = true;
    });
  }
}
