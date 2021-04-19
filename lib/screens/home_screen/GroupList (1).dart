import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/home_screen/groupRecipeList.dart';
import 'package:recipes_app/shared_screen/loading.dart';

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
        print(element.data);
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
          backgroundColor: Colors.teal[50],
          appBar: AppBar(
            title: Text(
              'your recipe groups',
              style: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            ),
            backgroundColor: Colors.teal[900],
            elevation: 0.0,
            actions: <Widget>[],
          ),
          body: Column(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: widget.groupId.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupRecipeList(
                                        widget.groupId[index],
                                        widget.groupName[index],
                                        widget.uid)));
                          },
                          child: Text(widget.groupName[index]));
                    }))
          ]));
    }
  }
}
