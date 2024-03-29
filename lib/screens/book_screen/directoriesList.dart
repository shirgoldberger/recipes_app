import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/shared_screen/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'directoryRecipesList.dart';

// ignore: must_be_immutable
class DirectoriesList extends StatefulWidget {
  String uid;
  List<Directory> directories = [];
  bool doneLoad = false;

  DirectoriesList(List<Directory> _directories, String _uid) {
    this.uid = _uid;
    this.directories = _directories;
  }

  @override
  _DirectoriesListState createState() => _DirectoriesListState();
}

class _DirectoriesListState extends State<DirectoriesList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.directories.length > 0 ? directoriesList() : emptyMessage(),
    );
  }

  Widget directoriesList() {
    return ReorderableListView(
      children: widget.directories
          .map((item) => ListTile(
                key: Key("${item.id}"),
                title: directoryTitle(item),
                trailing: Icon(Icons.menu),
              ))
          .toList(),
      onReorder: (int start, int current) {
        // dragging from top to bottom
        if (start < current) {
          int end = current - 1;
          Directory startItem = widget.directories[start];
          int i = 0;
          int local = start;
          do {
            widget.directories[local] = widget.directories[++local];
            i++;
          } while (i < end - start);
          widget.directories[end] = startItem;
        }
        // dragging from bottom to top
        else if (start > current) {
          Directory startItem = widget.directories[start];
          for (int i = start; i > current; i--) {
            widget.directories[i] = widget.directories[i - 1];
          }
          widget.directories[current] = startItem;
        }
        setState(() {});
      },
    );
  }

  Widget directoryTitle(Directory d) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      // ignore: deprecated_member_use
      child: RaisedButton(
        color: Colors.blueGrey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          BuildContext dialogContext;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              dialogContext = context;
              return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      backgroundColor: Colors.black87,
                      content: loadingIndicator()));
            },
          );
          await getDirectoryRecipes(d);
          Navigator.pop(dialogContext);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DirectoryRecipesList(
                      widget.directories
                          .firstWhere((element) => element.id == d.id),
                      widget.uid,
                      true,
                      d.id))).then((value) {
            if (value == "delete") {
              setState(() {
                widget.directories.removeWhere((element) => element.id == d.id);
              });
            }
            if (value != null) {
              setState(() {
                Directory directory = widget.directories.firstWhere(
                    (element) => element.id == d.id,
                    orElse: () => null);
                if (directory != null) {
                  widget.directories
                      .firstWhere((element) => element.id == d.id)
                      .name = value;
                  directory.name = value;
                }
              });
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        textColor: Colors.white,
        child: directoryName(d),
      ),
    );
  }

  void getDirectoryRecipes(Directory d) async {
    BuildContext context1 = context;
    try {
      String id =
          widget.directories.firstWhere((element) => element.id == d.id).id ??
              null;
      List<Recipe> recipes =
          await RecipeFromDB.getDirectoryRecipesList(widget.uid, id);
      widget.directories
          .firstWhere((element) => element.id == d.id)
          .initRecipes(recipes);
    } on Exception catch (error) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Something wrong.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Phoenix.rebirth(context1);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget emptyMessage() {
    return Text("You dont have any directories.\nLets create a new one!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 25, fontFamily: 'Raleway'));
  }

  Widget directoryName(Directory d) {
    return Text(d.name,
        style: TextStyle(
            fontSize: 25, fontFamily: 'Raleway', color: Colors.blueGrey[700]));
  }
}
