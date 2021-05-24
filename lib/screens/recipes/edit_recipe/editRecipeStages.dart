import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/models/stage.dart';
import '../../../config.dart';

// ignore: must_be_immutable
class EditRecipeStages extends StatefulWidget {
  String uid;
  List<Stages> stages = [];
  EditRecipeStages(String _uid, List<Stages> _stages) {
    uid = _uid;
    stages.addAll(_stages);
  }
  @override
  _EditRecipeStagesState createState() => _EditRecipeStagesState();
}

class _EditRecipeStagesState extends State<EditRecipeStages> {
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          box,
          box,
          title(),
          box,
          box,
          // stages
          Container(
              child: Column(children: [
            Text(error),
            widget.stages.length <= 0
                ? Text(
                    'There is no stages in this recipe yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                : Container(
                    height: min(50 * widget.stages.length.toDouble(), 300),
                    child: ListView.builder(
                        shrinkWrap: true,
                        addAutomaticKeepAlives: true,
                        itemCount: widget.stages.length,
                        itemBuilder: (_, i) => Row(children: <Widget>[
                              SizedBox(
                                width: 20,
                              ),
                              stageIndex(i),
                              Expanded(
                                  child: SizedBox(
                                      height: 37.0,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: widget.stages[i].s,
                                        ),
                                        validator: (val) => val.length < 2
                                            ? 'Enter a description with 2 letter at least'
                                            : null,
                                        onChanged: (val) {
                                          setState(() {
                                            widget.stages[i].s = val;
                                            widget.stages[i].i = i;
                                          });
                                        },
                                      ))),
                              deleteButton(i),
                            ])),
                  ),
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
          ])),
        ],
      ),
    );
  }

  void onDelteStages(int i) {
    setState(() {
      widget.stages.removeAt(i);
    });
  }

  void addStages() {
    setState(() {
      widget.stages.add(Stages());
    });
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: addStages,
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

  Widget title() {
    return Text('Stages list:',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontFamily: 'Raleway'));
  }

  Widget stageIndex(int i) {
    return Text(
      (i + 1).toString() + "." + " ",
      style: TextStyle(fontSize: 20, fontFamily: 'DescriptionFont'),
    );
  }

  Widget saveButton() {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: widget.stages.length != 0 ? Colors.green : Colors.grey,
      onPressed: () {
        if (widget.stages.length != 0) {
          Navigator.pop(context, widget.stages);
        }
      },
      tooltip: 'save',
      child: Icon(Icons.save_rounded),
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
}
