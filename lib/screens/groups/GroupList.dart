import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'groupRecipeList.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'package:recipes_app/config.dart';

class GroupList extends StatefulWidget {
  GroupList(String _uid) {
    this.uid = _uid;
  }
  String uid;
  List<String> groupName = [];
  List<String> groupId = [];
  bool doneLoad = false;

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  Future<void> getGroups() async {
    // print(getGroups());
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('groups')
        .getDocuments();
    snap.documents.forEach((element) async {
      setState(() {
        // print(element.data);
        widget.groupId.add(element.data['groupId']);
        widget.groupName.add(element.data['groupName']);
      });
    });
    setState(() {
      widget.doneLoad = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //getGroups();
    if (!widget.doneLoad) {
      getGroups();
      return Loading();
    } else {
      // print("group name");
      //print(widget.groupName);
      // return Text("A");
      return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              'your recipe groups',
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            backgroundColor: appBarBackgroundColor,
            elevation: 0.0,
            actions: <Widget>[],
          ),
          body: Column(children: <Widget>[
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: widget.groupId.length,
                  itemBuilder: (context, index) {
                    return group_title(index);
                  }),
            ))
          ]));
    }
  }

  Widget group_title(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
        color: Colors.blueGrey[300],
        textColor: Colors.white,
        child: Text(widget.groupName[index],
            style: TextStyle(fontSize: 25, fontFamily: 'frik')),
      ),
    );
  }
}
