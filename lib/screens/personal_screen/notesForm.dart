import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/screens/personal_screen/noresEditForm.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/shared_screen/config.dart';

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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        child: Form(
            child: SingleChildScrollView(
          child: Column(children: <Widget>[
            // ignore: deprecated_member_use
            //saveIcon(),
            editIcon(),
            title(),
            ListView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return noteText(index);
                })
          ]),
        )),
      ),
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
    RecipeFromDB.saveNotesInRecipe(widget.uid, widget.docId, widget.notes);
    // db
    //     .collection(usersCollectionName)
    //     .document(widget.uid)
    //     .collection('saved recipe')
    //     .document(widget.docId)
    //     .updateData({'notes': widget.notes});
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

  Widget editIcon() {
    // ignore: deprecated_member_use
    return FlatButton.icon(
        color: Colors.blueGrey[400],
        disabledColor: Colors.blueGrey[400],
        icon: Icon(Icons.edit),
        label: Text(
          'edit',
          style: TextStyle(
            fontFamily: ralewayFont,
            fontSize: 18,
          ),
          textAlign: TextAlign.left,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotesEditForm(widget.notes, widget.uid,
                      widget.docId, widget.currentId)));
        });
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

  Future<void> _showNotesPanel() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: new BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: NotesEditForm(
                widget.notes, widget.uid, widget.docId, widget.currentId)));
  }
}
