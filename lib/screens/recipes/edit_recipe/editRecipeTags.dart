import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../config.dart';

// ignore: must_be_immutable
class EditRecipeTags extends StatefulWidget {
  String uid;
  List<String> tags;
  EditRecipeTags(String _uid, List<String> _tags) {
    uid = _uid;
    tags = _tags;
  }
  @override
  _EditRecipeTagsState createState() => _EditRecipeTagsState();
}

class _EditRecipeTagsState extends State<EditRecipeTags> {
  String tagChoose;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      box,
      box,
      title(),
      box,
      box,
      // tags
      widget.tags.length <= 0
          ? Text(
              'There is no tags in this recipe yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
            )
          : Container(
              height: min(50 * widget.tags.length.toDouble(), 300),
              child: ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  itemCount: widget.tags.length,
                  itemBuilder: (_, i) => Row(children: <Widget>[
                        SizedBox(
                          width: 40,
                        ),
                        Expanded(
                            child: SizedBox(
                          height: 37.0,
                          child: DropdownButton(
                            hint: Text("choose this recipe tag"),
                            dropdownColor: Colors.grey,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 36,
                            isExpanded: true,
                            value: widget.tags[i],
                            onChanged: (newValue) {
                              setState(() {
                                widget.tags[i] = newValue;
                              });
                            },
                            items: tagList.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        deleteButton(i)
                      ])),
            ),

      box,
      addButton(),
      SizedBox(
        height: (min(50 * widget.tags.length.toDouble(), 300) ==
                50 * widget.tags.length.toDouble())
            ? 300 - 50 * widget.tags.length.toDouble()
            : 0,
      ),
      saveButton()
    ]));
  }

  void addTags() {
    setState(() {
      widget.tags.add('choose recipe tag');
    });
  }

  void onDelteTags(int i) {
    setState(() {
      widget.tags.removeAt(i);
    });
  }

  Widget title() {
    return Text('Tags list:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addTags,
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

  Widget saveButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor:
          this.widget.tags.length != 0 ? Colors.green : Colors.grey,
      onPressed: () {
        if (this.widget.tags.length != 0) {
          Navigator.pop(context, widget.tags);
        }
      },
      tooltip: 'save',
      child: Icon(Icons.save_rounded),
    );
  }

  Widget deleteButton(int i) {
    return RawMaterialButton(
      onPressed: () => onDelteTags(i),
      elevation: 0.2,
      child: Icon(
        Icons.delete_forever,
        size: 30,
      ),
      padding: EdgeInsets.all(5.0),
      shape: CircleBorder(),
    );
  }
}
