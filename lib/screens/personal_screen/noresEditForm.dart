import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/shared_screen/config.dart';

// ignore: must_be_immutable
class NotesEditForm extends StatefulWidget {
  String uid;
  List<String> notes = [];
  String docId;
  String newNotes;
  String currentId;
  bool doneLoad = false;

  NotesEditForm(List _notes, String _uid, String _docId, String _currentId) {
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
  _NotesEditFormState createState() => _NotesEditFormState();
}

class _NotesEditFormState extends State<NotesEditForm> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Form(
            child: SingleChildScrollView(
          child: Column(children: <Widget>[
            box,
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
            noteText(),
          ]),
        )),
      ),
    );
  }

  void saveIconPressed() {
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
    int count = 0;

    Navigator.popUntil(context, (route) {
      return count++ == 2;
    });
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

  Widget noteText() {
    return ListView.builder(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        itemCount: widget.notes.length,
        itemBuilder: (_, i) => Row(children: <Widget>[
              SizedBox(
                width: 20,
              ),
              stageIndex(i),
              Expanded(
                  child: SizedBox(
                      height: 37.0,
                      child: TextFormField(
                        initialValue: widget.notes[i],
                        decoration: InputDecoration(
                          hintText: widget.notes[i],
                        ),
                        onChanged: (val) {
                          setState(() {
                            widget.notes[i] = val;
                          });
                        },
                      ))),
              deleteButton(i)
            ]));
  }

  Widget deleteButton(int i) {
    return RawMaterialButton(
      onPressed: () => onDelteStages(i),
      elevation: 0.2,
      child: Icon(
        Icons.delete_forever,
        size: 30,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  void onDelteStages(int i) {
    List<String> a = [];
    a.addAll(widget.notes);
    a.removeAt(i);
    setState(() {
      widget.notes.clear();
      widget.notes.addAll(a);
    });
  }

  Widget stageIndex(int i) {
    return Text(
      (i + 1).toString() + "." + " ",
      style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
    );
  }
}
