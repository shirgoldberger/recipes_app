import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesForm extends StatefulWidget {
  NotesForm(List _notes, String uid, String docId, String currentid) {
    print("notes from");
    // getNotes();
    if (_notes != null) {
      this.notes = _notes.cast<String>().toList();
    } else {
      this.notes = [];
    }
    this.uid = uid;
    this.docId = docId;
    this.currentid = currentid;
  }
  List<String> notes = [];
  String uid;
  String docId;
  String newNotes;
  String currentid;
  bool doneLoad = false;
  @override
  _NotesFormState createState() => _NotesFormState();

  Future<void> getNotes() async {
    final db = Firestore.instance;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('saved recipe')
        .getDocuments();
    snap.documents.forEach((element) async {
      String recipeIdfromSnap = element.data['recipeID'];
      if (recipeIdfromSnap == currentid) {
        List notes = element.data['notes'];
        notes = notes;
      }
    });
    doneLoad = true;
  }
}

class _NotesFormState extends State<NotesForm> {
  @override
  Widget build(BuildContext context) {
    //if (widget.doneLoad) {
    return Container(
      child: Form(
          child: Column(children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: 'add new note:',
            hintStyle: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
            ),
          ),
          onChanged: (val) {
            setState(() {
              widget.newNotes = val;
              //  print(widget.newNotes);
            });
          },
        ),
        FlatButton.icon(
            color: Colors.blueGrey[400],
            disabledColor: Colors.blueGrey[400],
            icon: Icon(Icons.update),
            label: Text(
              'save',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
            onPressed: () {
              final db = Firestore.instance;

              setState(() {
                widget.notes.toList();
                if (widget.newNotes != null) {
                  widget.notes.add(widget.newNotes);
                }
                widget.newNotes = '';
              });
              print(widget.notes);
              db
                  .collection('users')
                  .document(widget.uid)
                  .collection('saved recipe')
                  .document(widget.docId)
                  .updateData({'notes': widget.notes});
              Navigator.pop(context);
            }),
        Text(
          'your notes on this recipe:',
          style: TextStyle(fontFamily: 'Raleway', fontSize: 25),
          textAlign: TextAlign.left,
        ),
        for (int i = 0; i < widget.notes.length; i++)
          Text(
            (i + 1).toString() + "). " + widget.notes[i],
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
            ),
            textAlign: TextAlign.left,
          ),
      ])),
    );

    // Future<void> getNotes() async {
    //   final db = Firestore.instance;
    //   QuerySnapshot snap = await Firestore.instance
    //       .collection('users')
    //       .document(widget.uid)
    //       .collection('saved recipe')
    //       .getDocuments();
    //   snap.documents.forEach((element) async {
    //     String recipeIdfromSnap = element.data['recipeID'];
    //     if (recipeIdfromSnap == widget.currentid) {
    //       List notes = element.data['notes'];
    //       widget.notes = notes;
    //     }
    //   });
    // }
  }
}
