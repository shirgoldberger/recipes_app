import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../config.dart';

// ignore: must_be_immutable
class EditRecipeNotes extends StatefulWidget {
  String uid;
  List<String> notes = [];
  EditRecipeNotes(String _uid, List<String> _notes) {
    uid = _uid;
    notes.addAll(_notes);
  }
  @override
  _EditRecipeNotesState createState() => _EditRecipeNotesState();
}

class _EditRecipeNotesState extends State<EditRecipeNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        box, box,
        title(), box, box,
        //notes
        widget.notes.length <= 0
            ? Text(
                'There is no notes in this recipe yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              )
            : Container(
                height: min(50 * widget.notes.length.toDouble(), 300),
                child: ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    itemCount: widget.notes.length,
                    itemBuilder: (_, i) => Row(children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          noteIndex(i),
                          Expanded(
                              child: SizedBox(
                                  height: 37.0,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: widget.notes[i]),
                                    validator: (val) => val.length < 2
                                        ? 'Enter a description eith 2 letter at least'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => widget.notes[i] = val);
                                    },
                                  ))),
                          SizedBox(
                            width: 10,
                          ),
                          deleteButton(i)
                        ]))),

        box,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addButton(),
            SizedBox(width: 60),
            saveButton(),
            SizedBox(width: 60),
            cancelButton()
          ],
        )
      ]),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget cancelButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.pop(context, null),
      elevation: 2.0,
      heroTag: null,
      backgroundColor: mainButtonColor,
      child: Icon(
        Icons.cancel,
        color: Colors.white,
      ),
      shape: CircleBorder(),
    );
  }

  void addNotes() {
    setState(() {
      widget.notes.add(' ');
    });
  }

  void onDelteNotes(int i) {
    setState(() {
      widget.notes.removeAt(i);
    });
  }

  Widget saveButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.pop(context, widget.notes);
      },
      tooltip: 'save',
      child: Icon(Icons.save_rounded),
    );
  }

  Widget title() {
    return Text('Notes list:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addNotes,
      elevation: 2.0,
      heroTag: null,
      backgroundColor: Colors.black,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      shape: CircleBorder(),
    );
  }

  Widget deleteButton(int i) {
    return RawMaterialButton(
      onPressed: () => onDelteNotes(i),
      elevation: 0.2,
      child: Icon(
        Icons.delete_forever,
        size: 30,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }

  Widget noteIndex(int i) {
    return Text(
      (i + 1).toString() + "." + " ",
      style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
    );
  }
}
