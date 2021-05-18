import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/config.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import 'package:recipes_app/screens/userHeadLine.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'package:recipes_app/shared_screen/loading.dart';
import 'searchAlgorithm.dart';
import '../recipes/watch_recipes/watchRecipe.dart';

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  bool home;
  // List<Recipe> publisRecipe = [];
  // bool doneLoadPublishRecipe = true;
  int doneLoadCounter = 0;
  bool doneGetUser = false;
  String uid;
  bool getUser = false;
  List listusers = [];
  List<Pair> list = [];
  List<Pair> listTags = [];
  List<Recipe> recipes = [];
  Map<String, int> amountLikesOfRecipe = {};
  Map<String, int> amountGroupsOfRecipe = {};
  Map<String, int> amountUsersOfRecipe = {};
  List<Pair> popular = [];
  List<String> usersId = [];

  List<Recipe> recipesSearch = [];
  bool userPress = true;
  bool recipePress = false;
  bool searchMode = false;
  Color recipePresColor = Colors.white;
  Color userPressColor = Colors.grey[350];
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  void initState() {
    super.initState();
    getuser();

    changeState();
  }

  void getuser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.currentUser().then((value) {
      if (value != null) {
        setState(() {
          widget.uid = value.uid;
          widget.getUser = true;
          changeState();
        });
      } else {
        getPopularRecipes();
        setState(() {
          widget.doneLoadCounter = 2;
        });
      }
    });
  }

  void changeState() {
    if (widget.getUser) {
      myFriends(widget.uid);
      tagsRecipe(widget.uid);
      getPopularRecipes();
    }
  }

  Widget box = SizedBox(
    height: 20.0,
  );

  Future<Widget> _getImage(BuildContext context, String image) async {
    if (image == "") {
      return Image.asset(noImagePath, fit: BoxFit.cover);
    }
    image = "uploads/" + image;
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.cover,
      );
    });
    return m;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.doneLoadCounter != 3) {
      return Loading();
    } else {
      return MaterialApp(
          home: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[700],
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    child: Column(children: <Widget>[
          box,
          searchWidget(),
          box,
          Center(
            child: (widget.searchMode) ? searchButtomWidget() : recipeGrid(),
          ),
        ])))),
        resizeToAvoidBottomInset: false,
      ));
    }
  }

  Widget searchButtomWidget() {
    return Container(
      child: Column(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  child: FlatButton(
                    onPressed: () => {
                      setState(() {
                        widget.userPress = false;
                        widget.recipePress = true;
                        widget.recipePresColor = Colors.grey[350];
                        widget.userPressColor = Colors.white;
                      })
                    },
                    color: widget.recipePresColor,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.auto_stories),
                        Text(
                          "  Recipes  ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  child: FlatButton(
                    onPressed: () => {
                      setState(() {
                        widget.userPress = true;
                        widget.recipePress = false;
                        widget.recipePresColor = Colors.white;
                        widget.userPressColor = Colors.grey[350];
                      })
                    },
                    color: widget.userPressColor,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.person),
                        Text(
                          "  users  ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Raleway',
                              fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          widget.userPress ? searchUsersWidget() : searcRecipesWidget(),
        ],
      ),
    );
  }

  Widget recipeGrid() {
    return Container(
      height: 500,
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(widget.recipes.length, (index) {
          if (!widget.searchMode) {
            return Container(
                height: 500,
                width: 500,
                child: Card(
                  shape: RoundedRectangleBorder(side: BorderSide.none),
                  // child: RecipeHeadLineSearch(
                  //     widget.recipes[index], true),
                  child: _buildOneItem(index),
                ));
          }
        }),
      ),
    );
  }

  Widget searchUsersWidget() {
    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
            itemCount: widget.usersId.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0)),
                          child: UserHeadLine(widget.usersId[index]))));
            }));
  }

  Widget searcRecipesWidget() {
    //recipes
    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
            itemCount: widget.recipesSearch.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0)),
                          child: RecipeHeadLine(
                              widget.recipesSearch[index], true))));
            }));

    // child: UserHeadLine(
    //     widget.listForWatch[index], widget.home))));
  }

  Widget _buildOneItem(int index) {
    if (widget.recipes.length <= index) {
      return Container();
    }
    return FutureBuilder(
        future: _getImage(context, widget.recipes[index].imagePath),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[50],
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              child: snapshot.data,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WatchRecipe(widget.recipes[index], true)));
              },
            );

          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 10,
                child: CircularProgressIndicator());
        });
  }

//algo funcs
  Future<void> myFriends(String uid) async {
    int i = 0;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('groups')
        .getDocuments();
    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoadCounter++;
      });
      return;
    }
    snap.documents.forEach((element) async {
      String groupId = element.data['groupId'];
      DocumentSnapshot snapGroup =
          await Firestore.instance.collection('Group').document(groupId).get();
      List users = snapGroup.data['users'];
      widget.listusers.addAll(users);
      i++;

      if (i == snap.documents.length) {
        for (int i = 0; i < widget.listusers.length; i++) {
          QuerySnapshot snap3 = await Firestore.instance
              .collection('users')
              .document(widget.listusers[i])
              .collection('saved recipe')
              .getDocuments();
          snap3.documents.forEach((element) async {
            String uid2 = element.data['userID'];
            String recipeId2 = element.data['recipeID'];
            widget.list.add(Pair(uid2, recipeId2));
          });
        }

        convertToRecipe(widget.list);
      }
    });
  }

  Future<void> convertToRecipe(List<Pair> pair) async {
    for (int i = 0; i < pair.length; i++) {
      String uid = pair[i].user;
      String recipeId = pair[i].recipe;
      DocumentSnapshot doc = await Firestore.instance
          .collection('users')
          .document(uid)
          .collection('recipes')
          .document(recipeId)
          .get();
      if (doc == null) {}
      String n = doc.data['name'] ?? '';
      String de = doc.data['description'] ?? '';
      String level = doc.data['level'] ?? 0;
      String time = doc.data['time'] ?? '0';
      int timeI = int.parse(time);
      String writer = doc.data['writer'] ?? '';
      String writerUid = doc.data['writerUid'] ?? '';
      String id = doc.data['recipeID'] ?? '';
      //
      String publish = doc.data['publishID'] ?? '';
      String path = doc.data['imagePath'] ?? '';
      int levlelInt = int.parse(level);
      //tags
      var tags = doc.data['tags'];
      String tagString = tags.toString();
      List<String> l = [];
      if (tagString != "[]") {
        String tag = tagString.substring(1, tagString.length - 1);
        l = tag.split(',');
        for (int i = 0; i < l.length; i++) {
          if (l[i][0] == ' ') {
            l[i] = l[i].substring(1, l[i].length);
          }
        }
      }
      //notes
      var note = doc.data['tags'];
      String noteString = note.toString();
      List<String> nList = [];
      if (noteString != "[]") {
        String tag = noteString.substring(1, noteString.length - 1);
        nList = tag.split(',');
        for (int i = 0; i < nList.length; i++) {
          if (nList[i][0] == ' ') {
            nList[i] = nList[i].substring(1, nList[i].length);
          }
        }
      }
      bool check = false;
      Recipe r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI,
          true, id, publish, path);
      for (int i = 0; i < widget.recipes.length; i++) {
        if (widget.recipes[i].id == r.id) {
          check = true;
        }
      }
      if (!check) {
        widget.recipes.add(r);
      }
    }
    setState(() {
      widget.doneLoadCounter++;
    });
  }

  Future<void> tagsRecipe(String uid) async {
    DocumentSnapshot snap =
        await Firestore.instance.collection("users").document(uid).get();
    Map<dynamic, dynamic> tagsCount = snap.data['tags'];
    final sorted = SplayTreeMap.from(
        tagsCount, (key1, key2) => tagsCount[key1].compareTo(tagsCount[key2]));
    String maxValue = sorted.lastKey();
    DocumentSnapshot snap3 = await Firestore.instance
        .collection('tags')
        .document('xt0XXXOLgprfkO3QiANs')
        .get();
    List publishTecipe = snap3.data[maxValue];
    for (int i = 0; i < publishTecipe.length; i++) {
      DocumentSnapshot snap4 = await Firestore.instance
          .collection('publish recipe')
          .document(publishTecipe[i])
          .get();
      String uid2 = snap4.data['userID'];
      String recipeId2 = snap4.data['recipeId'];
      widget.listTags.add(Pair(uid2, recipeId2));
    }
    for (int i = 0; i < widget.listTags.length; i++) {}
    convertToRecipe(widget.listTags);
  }

//popular

  Future<void> getPopularRecipes() async {
    await getUserAmount();
    await getGroupsAmount();
    await getLikesAmount();
    await getUserAndRecipe(widget.amountLikesOfRecipe);
    await getUserAndRecipe(widget.amountGroupsOfRecipe);
    await getUserAndRecipe(widget.amountUsersOfRecipe);
    await convertToRecipe(widget.popular);
  }

  getUserAndRecipe(Map<String, int> map) async {
    for (int i = 0; i < map.length; i++) {
      var recipe = await Firestore.instance
          .collection('publish recipe')
          .document(map.keys.elementAt(i))
          .get();
      String recipeId = recipe.data['recipeId'];
      String userId = recipe.data['userID'];
      setState(() {
        widget.popular.add(Pair(userId, recipeId));
      });
    }
  }

  getUserAmount() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List users = element.data['saveUser'] ?? [];
      int amount = users.length;
      widget.amountUsersOfRecipe[recipeId] = amount;
    });
    widget.amountUsersOfRecipe = SplayTreeMap.from(
        widget.amountUsersOfRecipe,
        (key1, key2) => widget.amountUsersOfRecipe[key1]
            .compareTo(widget.amountUsersOfRecipe[key2]));
  }

  getGroupsAmount() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List groups = element.data['saveInGroup'] ?? [];
      int amount = groups.length;
      widget.amountGroupsOfRecipe[recipeId] = amount;
    });
    widget.amountGroupsOfRecipe = SplayTreeMap.from(
        widget.amountGroupsOfRecipe,
        (key1, key2) => widget.amountGroupsOfRecipe[key1]
            .compareTo(widget.amountGroupsOfRecipe[key2]));
  }

  getLikesAmount() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    // get amount of likes of all the publish recipes
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List likes = element.data['likes'] ?? [];
      int amount = likes.length;
      widget.amountLikesOfRecipe[recipeId] = amount;
    });
    widget.amountLikesOfRecipe = SplayTreeMap.from(
        widget.amountLikesOfRecipe,
        (key1, key2) => widget.amountLikesOfRecipe[key1]
            .compareTo(widget.amountLikesOfRecipe[key2]));
  }

  List<String> userId = [];

  Widget searchWidget() {
    return Container(
      width: 250,
      height: 60,
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
        ),
        onChanged: (val) {
          if (val.isEmpty) {
            setState(() {
              widget.searchMode = false;
            });
          } else {
            startSearch(val);
            startSearchRecipes(val);
            setState(() {
              widget.searchMode = true;
            });
          }
        },
      ),
    );
  }

  Future<void> startSearch(String val) async {
    setState(() {
      widget.usersId.clear();
    });
    QuerySnapshot snap =
        await Firestore.instance.collection('users').getDocuments();
    snap.documents.forEach((element) {
      String firstName = element.data['firstName'];
      if (firstName.contains(val)) {
        if (!widget.usersId.contains(element.documentID)) {
          setState(() {
            widget.usersId.add(element.documentID);
          });
        }
      }

      String lastName = element.data['lastName'];
      if (lastName.contains(val)) {
        if (!widget.usersId.contains(element.documentID)) {
          setState(() {
            widget.usersId.add(element.documentID);
          });
        }
      }
    });
  }

  Future<void> startSearchRecipes(String val) async {
    setState(() {
      widget.recipesSearch.clear();
    });
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) async {
      String recipeId = element.data['recipeId'];
      String uidRecipe = element.data['userID'];
      DocumentSnapshot doc = await Firestore.instance
          .collection('users')
          .document(uidRecipe)
          .collection('recipes')
          .document(recipeId)
          .get();
      String recipeName = doc.data['name'] ?? '';
      if (recipeName.contains(val)) {
        convertToRecipeForSearch(Pair(uidRecipe, recipeId));
      }
    });
  }

  Future convertToRecipeForSearch(Pair pair) async {
    String uid = pair.user;
    String recipeId = pair.recipe;
    DocumentSnapshot doc = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('recipes')
        .document(recipeId)
        .get();
    String n = doc.data['name'] ?? '';
    String de = doc.data['description'] ?? '';
    String level = doc.data['level'] ?? 0;
    String time = doc.data['time'] ?? '0';
    int timeI = int.parse(time);
    String writer = doc.data['writer'] ?? '';
    String writerUid = doc.data['writerUid'] ?? '';
    String id = doc.data['recipeID'] ?? '';
    //
    String publish = doc.data['publishID'] ?? '';
    String path = doc.data['imagePath'] ?? '';
    int levlelInt = int.parse(level);
    //tags
    var tags = doc.data['tags'];
    String tagString = tags.toString();
    List<String> l = [];
    if (tagString != "[]") {
      String tag = tagString.substring(1, tagString.length - 1);
      l = tag.split(',');
      for (int i = 0; i < l.length; i++) {
        if (l[i][0] == ' ') {
          l[i] = l[i].substring(1, l[i].length);
        }
      }
    }
    //notes
    var note = doc.data['tags'];
    String noteString = note.toString();
    List<String> nList = [];
    if (noteString != "[]") {
      String tag = noteString.substring(1, noteString.length - 1);
      nList = tag.split(',');
      for (int i = 0; i < nList.length; i++) {
        if (nList[i][0] == ' ') {
          nList[i] = nList[i].substring(1, nList[i].length);
        }
      }
    }
    bool check = false;
    Recipe r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI,
        true, id, publish, path);
    for (int i = 0; i < widget.recipesSearch.length; i++) {
      if (widget.recipesSearch[i].id == r.id) {
        check = true;
      }
    }
    if (!check) {
      setState(() {
        widget.recipesSearch.add(r);
      });
    }
  }
}
