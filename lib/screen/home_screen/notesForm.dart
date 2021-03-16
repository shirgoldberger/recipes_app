import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesForm extends StatefulWidget {
  NotesForm(List notes, String uid, String docId) {
    this.notes = notes.cast<String>().toList();
    this.uid = uid;
    this.docId = docId;
  }
  List<String> notes;
  String uid;
  String docId;
  String newNotes;
  @override
  _NotesFormState createState() => _NotesFormState();
}

class _NotesFormState extends State<NotesForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          child: Column(children: <Widget>[
        Text(
          'your notes on this recipe:',
          style: TextStyle(fontSize: 18.0),
        ),
        for (int i = 0; i < widget.notes.length; i++)
          Text(
            (i + 1).toString() + "). " + widget.notes[i],
            style: TextStyle(fontSize: 18.0),
          ),
        TextFormField(
          decoration: InputDecoration(labelText: 'add new note:'),
          onChanged: (val) {
            print(val);
            setState(() {
              widget.newNotes = val;
            });
          },
        ),
        FlatButton.icon(
            icon: Icon(Icons.update),
            label: Text('save'),
            onPressed: () {
              final db = Firestore.instance;
              // print("save----------");
              // print(widget.uid);
              // print(widget.docId);
              setState(() {
                widget.notes.toList();
                widget.notes.add(widget.newNotes);
              });
              // setState(() {
              //   widget.notes.add(widget.newNotes);
              // });
              // print(widget.notes);

              db
                  .collection('users')
                  .document(widget.uid)
                  .collection('saved recipe')
                  .document(widget.docId)
                  .updateData({'notes': widget.notes});
            }),
      ])),
    );
  }
}
