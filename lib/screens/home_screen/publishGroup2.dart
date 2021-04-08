import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/shared_screen/loading.dart';

class PublishGroup2 extends StatefulWidget {
  PublishGroup2(String _uid, String _recipeId) {
    this.uid = _uid;
    this.recipeId = _recipeId;
  }
  String uid;
  String recipeId;
  List<String> groupName = [];
  List<String> groupName2 = [];
  List<String> groupId = [];
  List<bool> isCheck = [];
  List<String> publish = [];
  bool doneLoad = false;
  bool check = false;
  List<Color> colors = [];
  Map<String, bool> map = {};
  @override
  _PublishGroup2State createState() => _PublishGroup2State();
}

class _PublishGroup2State extends State<PublishGroup2> {
  void convertToCheck() {
    widget.groupName2 = widget.groupName;
    print("convert to shack");
    for (int i = 0; i < widget.publish.length; i++) {
      for (int j = 0; j < widget.groupName.length; j++) {
        if (widget.groupName[j] == widget.publish[i]) {
          setState(() {
            widget.isCheck[j] = !widget.isCheck[j];
            widget.colors[j] = Colors.grey;
          });
        }
      }
    }
    print("check list");
    print(widget.isCheck);
    setState(() {
      widget.check = true;
    });
  }

  Future<void> getGroups() async {
    // print(getGroups());
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('groups')
        .getDocuments();
    snap.documents.forEach((element) async {
      setState(() {
        widget.groupId.add(element.data['groupId']);
        widget.groupName.add(element.data['groupName']);
        widget.map.addAll({element.data['groupName']: false});
        widget.isCheck.add(false);
        widget.colors.add(Colors.blueGrey[400]);
      });

      //  print("b");
      // print(widget.groupName);

      QuerySnapshot snap2 = await Firestore.instance
          .collection('Group')
          .document(element.data['groupId'])
          .collection('recipes')
          .getDocuments();
      //    print(element.data['groupId']);
      //  print(snap2.documents.length);
      if (snap2.documents.length != 0) {
        snap2.documents.forEach((element2) async {
          if (element2.data['recipeId'] == widget.recipeId) {
            //  print('sucses');
            setState(() {
              // widget.colors[]
              widget.map.update(element.data['groupName'], (value) => true);
              widget.publish.add(element.data['groupName']);
            });
            //widget.publish.add(element.data['groupName']);
          }
        });
      }
    });

    setState(() {
      //convert();
      widget.doneLoad = true;
      // convertToCheck();
    });
    // convertToCheck();
  }

  // void initState() {
  //   super.initState();
  //   convertToCheck();
  // }

  @override
  Widget build(BuildContext context) {
    if (!widget.doneLoad) {
      getGroups();

      return Loading();
    } else {
      //    convertToCheck();

      return ListView.builder(
          itemCount: widget.map.length,
          itemBuilder: (context, index) {
            return FlatButton.icon(
              color: widget.map.values.elementAt(index)
                  ? Colors.red
                  : Colors.black,
              icon: Icon(Icons.plus_one, color: Colors.white),
              label: Text(widget.map.keys.elementAt(index),
                  style: TextStyle(color: Colors.white)),
              onPressed: () {
                print("press");
                print(widget.isCheck[index]);
                if (widget.map.values.elementAt(index)) {
                  setState(() {
                    print("set state");
                    widget.isCheck[index] = false;
                    widget.colors[index] = Colors.blueGrey[400];
                    widget.map.update(
                        widget.map.keys.elementAt(index), (value) => false);
                  });
                  unPublishGroup(index);
                } else {
                  publishInGroup(index);
                  setState(() {
                    widget.isCheck[index] = true;
                    widget.colors[index] = Colors.grey;
                    widget.map.update(
                        widget.map.keys.elementAt(index), (value) => true);
                  });
                }
              },
            );
          });
    }
  }

  void publishInGroup(int index) async {
    final db = Firestore.instance;
    var currentRecipe = await db
        .collection('Group')
        .document(widget.groupId[index])
        .collection('recipes')
        .add({'userId': widget.uid, 'recipeId': widget.recipeId});
  }

  Future<void> unPublishGroup(int index) async {
    print("1");
    setState(() {
      widget.isCheck[index] = false;
      widget.colors[index] = Colors.blueGrey[400];
      print("2");
    });

    final db = Firestore.instance;

    QuerySnapshot snap = await Firestore.instance
        .collection('Group')
        .document(widget.groupId[index])
        .collection('recipes')
        .getDocuments();
    snap.documents.forEach((element) async {
      if (element.data['recipeId'] == widget.recipeId) {
        db
            .collection('Group')
            .document(widget.groupId[index])
            .collection('recipes')
            .document(element.documentID)
            .delete();
      }
    });
  }
}
