import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  Color userPressColor = mainButtonColor;
  double widthUser = 140;
  double highUser = 70;
  double widthRecipe = 120;
  double heifhRecipe = 50;
  double sizeUser = 14;
  double sizeRecipe = 12;
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  void initState() {
    super.initState();
    getuser();
  }

  // void a() async {
  //   setState(() {
  //     widget.doneLoadCounter = 0;
  //   });
  //   if (widget.getUser) {
  //     await myFriends(widget.uid);
  //     tagsRecipe(widget.uid);
  //     getPopularRecipes();
  //   } else {
  //     getPopularRecipes();
  //     setState(() {
  //       widget.doneLoadCounter = 2;
  //     });
  //   }
  // }

  void getuser() async {
    setState(() {
      widget.doneLoadCounter = 0;
      widget.recipes = [];
    });
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

  Future<void> changeState() async {
    if (widget.getUser) {
      await myFriends(widget.uid);
      tagsRecipe(widget.uid);
      getPopularRecipes();
    }
  }

  Future _getImage(BuildContext context, String image) async {
    if (image == "") {
      return null;
    }
    image = "uploads/" + image;
    NetworkImage m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = NetworkImage(downloadUrl.toString());
    });
    return m;
  }

  Future<bool> refresh() async {
    await Future.delayed(Duration(seconds: 1), getuser);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.doneLoadCounter != 3) {
    //   return Loading();
    // } else {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(fontFamily: logoFont, color: Colors.white),
        ),
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
        widget.doneLoadCounter != 3
            ? Container(
                child: Center(
                child: SpinKitCircle(
                  color: Colors.grey[600],
                  size: 50.0,
                ),
              ))
            : Center(
                child:
                    (widget.searchMode) ? searchButtomWidget() : recipeGrid(),
              ),
      ])))),
      resizeToAvoidBottomInset: false,
    ));
    // }
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
                  child: SizedBox(
                    height: 50,
                    width: 120,
                    child: FlatButton(
                      onPressed: () => {
                        setState(() {
                          widget.userPress = false;
                          widget.recipePress = true;
                          widget.recipePresColor = mainButtonColor;
                          widget.userPressColor = Colors.white;
                          widget.highUser = 50;
                          widget.widthUser = 120;
                          widget.heifhRecipe = 70;
                          widget.widthRecipe = 140;
                          widget.sizeRecipe = 14;
                          widget.sizeUser = 12;
                        })
                      },
                      color: widget.recipePresColor,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Row contents horizontally,
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
                  child: SizedBox(
                    width: 120,
                    height: 50,
                    child: FlatButton(
                      onPressed: () => {
                        setState(() {
                          widget.userPress = true;
                          widget.recipePress = false;
                          widget.recipePresColor = Colors.white;
                          widget.userPressColor = mainButtonColor;
                          widget.highUser = 70;
                          widget.widthUser = 140;
                          widget.heifhRecipe = 50;
                          widget.widthRecipe = 120;
                          widget.sizeRecipe = 12;
                          widget.sizeUser = 14;
                        })
                      },
                      color: widget.userPressColor,
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
    return RefreshIndicator(
        color: Colors.blue,
        onRefresh: refresh,
        child: Container(
          height: 600,
          child: GridView.count(
            physics: AlwaysScrollableScrollPhysics(),
            crossAxisCount: 3,
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
        ));
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
                              widget.recipesSearch[index], true, ""))));
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
            return InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                // borderRadius: BorderRadius.circular(5),
                highlightColor: Colors.blueGrey,
                child: Container(
                    width: 190,
                    height: 180,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      color: Colors.blueGrey[50],
                      image: DecorationImage(
                          image: snapshot.data == null
                              ? ExactAssetImage(noImagePath)
                              // : Image.network(snapshot.data.url),
                              : snapshot.data,
                          fit: BoxFit.cover),
                    ),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WatchRecipe(
                                    widget.recipes[index],
                                    true,
                                    snapshot.data,
                                    "")));
                      },
                    )));
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
                child: Center(
              child: SpinKitCircle(
                color: Colors.grey[600],
                size: 50.0,
              ),
            ));
        });
  }

//algo funcs
  Future<void> myFriends(String uid) async {
    List<Pair> myFreiendsRecipe = [];

    widget.listusers = [];
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
      widget.listusers.remove(uid);

      final seen = Set<String>();
      final unique = widget.listusers.where((str) => seen.add(str)).toList();
      setState(() {
        widget.listusers = [];
        widget.listusers.addAll(unique);
      });

      i++;

      if (i == snap.documents.length) {
        for (int i = 0; i < widget.listusers.length; i++) {
          QuerySnapshot snap3 = await Firestore.instance
              .collection('users')
              .document(widget.listusers[i])
              .collection('saved recipe')
              .getDocuments();

          for (int i = 0; i < snap3.documents.length; i++) {
            if (i > 4) {
              break;
            }

            String uid2 = snap3.documents[i].data['userID'];
            String recipeId2 = snap3.documents[i].data['recipeID'];

            myFreiendsRecipe.add(Pair(uid2, recipeId2));
          }
        }

        convertToRecipe(myFreiendsRecipe);
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
    widget.listTags = [];
    DocumentSnapshot snap =
        await Firestore.instance.collection("users").document(uid).get();
    Map<dynamic, dynamic> tagsCount = snap.data['tags'];
    var sortedKeys = tagsCount.keys.toList(growable: false)
      ..sort((k1, k2) => tagsCount[k1].compareTo(tagsCount[k2]));
    LinkedHashMap sorted = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => tagsCount[k]);
    String maxValue = sorted.keys.elementAt(sorted.length - 1);

    sorted.remove(sorted.keys.elementAt(sorted.length - 1));
    for (int i = 0; i < 3; i++) {
      DocumentSnapshot snap3 = await Firestore.instance
          .collection('tags')
          .document('xt0XXXOLgprfkO3QiANs')
          .get();
      List publishTecipe = snap3.data[maxValue];
      for (int i = 0; i < publishTecipe.length; i++) {
        if (i > 4) {
          break;
        }
        DocumentSnapshot snap4 = await Firestore.instance
            .collection('publish recipe')
            .document(publishTecipe[i])
            .get();
        String uid2 = snap4.data['userID'];
        String recipeId2 = snap4.data['recipeId'];
        widget.listTags.add(Pair(uid2, recipeId2));
      }

      convertToRecipe(widget.listTags);
      maxValue = sorted.keys.elementAt(sorted.length - 1);
      sorted.remove(sorted.keys.elementAt(sorted.length - 1));
    }
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
    for (int i = (map.length - 1); i >= 0; i--) {
      if (i < map.length - 5) {
        break;
      }
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
    widget.amountUsersOfRecipe = {};
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    for (int i = 0; i < snap.documents.length; i++) {
      String recipeId = snap.documents[i].documentID.toString();
      List users = snap.documents[i].data['saveUser'] ?? [];
      int amount = users.length;
      widget.amountUsersOfRecipe[recipeId] = amount;
    }
    var sortedKeys = widget.amountUsersOfRecipe.keys.toList(growable: false)
      ..sort((k1, k2) => widget.amountUsersOfRecipe[k1]
          .compareTo(widget.amountUsersOfRecipe[k2]));
    widget.amountUsersOfRecipe = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => widget.amountUsersOfRecipe[k]);
  }

  getGroupsAmount() async {
    widget.amountGroupsOfRecipe = {};
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List groups = element.data['saveInGroup'] ?? [];
      int amount = groups.length;
      widget.amountGroupsOfRecipe[recipeId] = amount;
    });
    var sortedKeys = widget.amountGroupsOfRecipe.keys.toList(growable: false)
      ..sort((k1, k2) => widget.amountGroupsOfRecipe[k1]
          .compareTo(widget.amountGroupsOfRecipe[k2]));
    widget.amountGroupsOfRecipe = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => widget.amountGroupsOfRecipe[k]);
  }

  getLikesAmount() async {
    widget.amountLikesOfRecipe = {};
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    // get amount of likes of all the publish recipes
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List likes = element.data['likes'] ?? [];
      int amount = likes.length;
      widget.amountLikesOfRecipe[recipeId] = amount;
    });
    var sortedKeys = widget.amountLikesOfRecipe.keys.toList(growable: false)
      ..sort((k1, k2) => widget.amountLikesOfRecipe[k1]
          .compareTo(widget.amountLikesOfRecipe[k2]));
    widget.amountLikesOfRecipe = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => widget.amountLikesOfRecipe[k]);
  }

  List<String> userId = [];

  Widget searchWidget() {
    return Container(
      width: 350,
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
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
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
