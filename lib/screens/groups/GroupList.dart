/// see list of all yout groups ///

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/services/groupFromDB.dart';
import 'groupRecipeList.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'package:recipes_app/shared_screen/config.dart';

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
    int pictureIndex = (index % 6) + 1;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GroupRecipeList(widget.groupId[index],
                        widget.groupName[index], widget.uid))).then((value) => {
                  if (value != null)
                    {
                      setState(() {
                        widget.groupName[index] = value;
                      })
                    }
                });
          },
          borderRadius: BorderRadius.circular(10),
          child: GestureDetector(
            child: Container(
                width: 400,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage('lib/images/group (' +
                          pictureIndex.toString() +
                          ').JPG'),
                      fit: BoxFit.cover),
                  // button text
                )),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Center(
                child: Text(
              widget.groupName[index],
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Raleway',
                  fontSize: 35),
            )),
          ],
        ),
      ]),
    );
  }

  Widget emptyMessage() {
    return Text("you dont have groups, lets create a new one!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, fontFamily: 'Raleway'));
  }

  // database function //
  Future<void> getGroups() async {
    QuerySnapshot snap = await GroupFromDB.getUserGroups(widget.uid);
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
