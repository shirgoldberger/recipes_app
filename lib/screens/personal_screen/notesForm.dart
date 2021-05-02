import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/config.dart';

// ignore: must_be_immutable
class NotesForm extends StatefulWidget {
  String uid;
  List<String> notes = [];
  String docId;
  String newNotes;
  String currentId;
  bool doneLoad = false;

  NotesForm(List _notes, String _uid, String _docId, String _currentId) {
    if (_notes != null) {
      this.notes = _notes.cast<String>().toList();
    } else {
      this.notes = [];
    }
    this.uid = _uid;
    this.docId = _docId;
    this.currentId = _currentId;
  }

  @override
  _NotesFormState createState() => _NotesFormState();
}

class _NotesFormState extends State<NotesForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          child: Column(children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Add new note:',
            hintStyle: TextStyle(
              fontFamily: ralewayFont,
              fontSize: 18,
            ),
          ),
          onChanged: (val) {
            setState(() {
              widget.newNotes = val;
            });
          },
        ),
        // ignore: deprecated_member_use
        saveIcon(),
        title(),
        for (int i = 0; i < widget.notes.length; i++) noteText(i),
      ])),
    );
  }

  void saveIconPressed() {
    final db = Firestore.instance;
    setState(() {
      widget.notes.toList();
      if (widget.newNotes != null) {
        widget.notes.add(widget.newNotes);
      }
      widget.newNotes = '';
    });
    db
        .collection(usersCollectionName)
        .document(widget.uid)
        .collection('saved recipe')
        .document(widget.docId)
        .updateData({'notes': widget.notes});
    Navigator.pop(context);
  }

  Widget saveIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: Colors.blueGrey[400],
        disabledColor: Colors.blueGrey[400],
        icon: Icon(Icons.update),
        label: Text(
          'save',
          style: TextStyle(
            fontFamily: ralewayFont,
            fontSize: 18,
          ),
          textAlign: TextAlign.left,
        ),
        onPressed: saveIconPressed);
  }

  Widget title() {
    return Text(
      'your notes on this recipe:',
      style: TextStyle(fontFamily: ralewayFont, fontSize: 25),
      textAlign: TextAlign.left,
    );
  }

  Widget noteText(int i) {
    return Text(
      (i + 1).toString() + "). " + widget.notes[i],
      style: TextStyle(
        fontFamily: ralewayFont,
        fontSize: 18,
      ),
      textAlign: TextAlign.left,
    );
  }
}
