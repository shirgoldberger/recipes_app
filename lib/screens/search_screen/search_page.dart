import 'dart:collection';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/recipes/recipeHeadLine.dart';
import 'package:recipes_app/screens/search_screen/userHeadLine.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/shared_screen/config.dart';
import '../recipes/watch_recipes/watchRecipe.dart';
import 'dart:math';

class Pair<T1, T2> {
  final String user;
  final String recipe;

  Pair(this.user, this.recipe);
}

// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  bool home;
  bool doneLoadCounter = false;
  bool doneGetUser = false;
  String uid;
  bool getUser = false;
  List listusers = [];
  List<Pair> list = [];
  List<Pair> listTags = [];
  List<Recipe> recipes = [];
  List<Recipe> friendsRecipes = [];
  List<Recipe> tagsRecipes = [];
  List<Recipe> popularRecipes = [];
  List<Pair> popular = [];
  List<String> usersId = [];

  List<Recipe> recipesSearch = [];
  bool userPress = true;
  bool recipePress = false;
  bool searchMode = false;
  Color recipePresColor = Colors.white;
  Color userPressColor = mainButtonColor;

  bool doneFriends = false;
  bool doneTags = false;
  bool donePopular = false;

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  void initState() {
    super.initState();
    getuser();
  }

  void getuser() async {
    setState(() {
      widget.doneLoadCounter = false;
      widget.recipes = [];
      widget.friendsRecipes = [];
      widget.tagsRecipes = [];
      widget.popularRecipes = [];
    });

    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();

    if (user != null) {
      setState(() {
        widget.uid = user.uid;
        widget.getUser = true;
        changeState();
      });
    } else {
      await getPopularRecipes();
      unitRecipesList();
    }
  }

  @protected
  @mustCallSuper
  void dispose() {
    print("dispose");
    assert(() {
      getuser();
      return true;
    }());
  }

  // void getuser() async {
  //   setState(() {
  //     widget.doneLoadCounter = false;
  //     widget.recipes = [];
  //     widget.friendsRecipes = [];
  //     widget.tagsRecipes = [];
  //     widget.popularRecipes = [];
  //   });
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   await auth.currentUser().then((value) async {
  //     if (!mounted) {
  //       return;
  //     }
  //     if (value != null) {
  //       setState(() {
  //         widget.uid = value.uid;
  //         widget.getUser = true;
  //         changeState();
  //       });
  //     } else {
  //       await getPopularRecipes().then((value) {
  //         if (!mounted) {
  //           return;
  //         }
  //       });
  //       unitRecipesList();
  //     }
  //   });
  // }

  Future<void> changeState() async {
    if (widget.getUser) {
      myFriends(widget.uid);
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
    await Future.delayed(Duration(seconds: 0), getuser);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.doneFriends && widget.doneTags && widget.donePopular) {
      unitRecipesList();
    }
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(fontFamily: logoFont, color: Colors.white),
        ),
        backgroundColor: appBarBackgroundColor,
        elevation: 0.0,
        actions: <Widget>[],
      ),
      body: SafeArea(
          child: RefreshIndicator(
              color: Colors.blue,
              onRefresh: refresh,
              child: SingleChildScrollView(
                  child: Container(
                      child: Column(children: <Widget>[
                box,
                searchWidget(),
                box,
                widget.doneLoadCounter
                    ? ((widget.searchMode)
                        ? Center(child: searchButtomWidget())
                        : Center(child: recipeGrid()))
                    : Column(
                        children: [
                          Container(
                              child: Center(
                            child: SpinKitCircle(
                              color: Colors.grey[600],
                              size: 50.0,
                            ),
                          )),
                          Text('Search recipes for you...')
                        ],
                      ),
              ]))))),
      resizeToAvoidBottomInset: false,
    ));
  }

  Widget recipeGrid() {
    return RefreshIndicator(
        color: Colors.blue,
        onRefresh: refresh,
        child: Container(
          height:
              max(300, (((widget.recipes.length * 200) / 3) - 300).toDouble()),
          child: GridView.count(
            physics: ScrollPhysics(),
            crossAxisCount: 3,
            // ignore: missing_return
            children: List.generate(widget.recipes.length, (index) {
              if (!widget.searchMode) {
                return Container(
                    height: 500,
                    width: 500,
                    child: Card(
                      shape: RoundedRectangleBorder(side: BorderSide.none),
                      child: _buildOneItem(index),
                    ));
              }
            }),
          ),
        ));
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
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () async {
                        widget.recipes[index] =
                            await RecipeFromDB.getRecipeOfUser(
                                widget.recipes[index].writerUid,
                                widget.recipes[index].id);

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
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () => {
                        setState(() {
                          widget.userPress = false;
                          widget.recipePress = true;
                          widget.recipePresColor = mainButtonColor;
                          widget.userPressColor = Colors.white;
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
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () => {
                        setState(() {
                          widget.userPress = true;
                          widget.recipePress = false;
                          widget.recipePresColor = Colors.white;
                          widget.userPressColor = mainButtonColor;
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

  Widget searchUsersWidget() {
    return Container(
        height: max((((widget.usersId.length * 150)) - 300).toDouble(),
            (((widget.usersId.length * 150))).toDouble()),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
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
    // recipes
    return Container(
        height: max((((widget.recipesSearch.length * 150)) - 300).toDouble(),
            (((widget.recipesSearch.length * 150))).toDouble()),
        child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
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
  }

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
      if (firstName.toUpperCase().contains(val.toUpperCase())) {
        if (!widget.usersId.contains(element.documentID)) {
          setState(() {
            widget.usersId.add(element.documentID);
          });
        }
      }

      String lastName = element.data['lastName'];
      if (lastName.toUpperCase().contains(val.toUpperCase())) {
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
      if (recipeName.toUpperCase().contains(val.toUpperCase())) {
        convertToRecipeForSearch(Pair(uidRecipe, recipeId));
      }
    });
  }

  List<String> userId = [];

  Future convertToRecipeForSearch(Pair pair) async {
    String uid = pair.user;
    String recipeId = pair.recipe;

    DocumentSnapshot recipe = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('recipes')
        .document(recipeId)
        .get();
    Recipe r = RecipeFromDB.convertSnapshotToRecipe(recipe);
    bool check = false;

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

  // *** algorithm functions *** //

  Future myFriends(String uid) async {
    List<Pair> myFreiendsRecipe = [];

    widget.listusers = [];
    int i = 0;
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('groups')
        .getDocuments();

    if (snap.documents.length == 0) {
      widget.doneFriends = true;
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
          if (i > 7) {
            break;
          }
          QuerySnapshot snap3 = await Firestore.instance
              .collection('users')
              .document(widget.listusers[i])
              .collection('saved recipe')
              .getDocuments();

          for (int i = 0; i < snap3.documents.length; i++) {
            String uid2 = snap3.documents[i].data['userID'];
            String recipeId2 = snap3.documents[i].data['recipeID'];
            myFreiendsRecipe.add(Pair(uid2, recipeId2));
          }
        }
        convertToRecipe(myFreiendsRecipe, 1);
      }
    });
  }

  Future<void> tagsRecipe(String uid) async {
    widget.listTags = [];
    DocumentSnapshot snap =
        await Firestore.instance.collection("users").document(uid).get();
    Map<dynamic, dynamic> tagsCount = snap.data['tags'] ?? {};
    if (tagsCount.isEmpty) {
      widget.doneTags = true;
      return;
    }
    var sortedKeys = tagsCount.keys.toList(growable: false)
      ..sort((k1, k2) => tagsCount[k1].compareTo(tagsCount[k2]));
    LinkedHashMap sorted = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => tagsCount[k]);
    for (int i = (sorted.length - 1); i >= (sorted.length - 3); i--) {
      if (sorted.values.elementAt(i) == 0) {
        break;
      }
      String maxValue = sorted.keys.elementAt(i);
      DocumentSnapshot snap3 = await Firestore.instance
          .collection('tags')
          .document('xt0XXXOLgprfkO3QiANs')
          .get();
      List publishTecipe = snap3.data[maxValue] ?? [];
      for (int i = 0; i < publishTecipe.length; i++) {
        DocumentSnapshot snap4 = await Firestore.instance
            .collection('publish recipe')
            .document(publishTecipe[i])
            .get();
        if (snap4 == null) {
          continue;
        }
        String uid2 = snap4.data['userID'] ?? "";
        String recipeId2 = snap4.data['recipeId'] ?? "";
        widget.listTags.add(Pair(uid2, recipeId2));
      }
    }
    convertToRecipe(widget.listTags, 2);
  }

  Future getPopularRecipes() async {
    Map<String, double> amounts = {};
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    for (int i = 0; i < snap.documents.length; i++) {
      String recipeId = snap.documents[i].documentID.toString();
      List users = snap.documents[i].data['saveUser'] ?? [];
      int amountUsers = users.length;

      List groups = snap.documents[i].data['saveInGroup'] ?? [];
      int amountGroups = groups.length;

      List likes = snap.documents[i].data['likes'] ?? [];
      int amountLikes = likes.length;

      amounts[recipeId] = (calculate(amountLikes) +
              calculate(amountGroups) +
              calculate(amountUsers)) /
          3;
    }
    var sortedKeys = amounts.keys.toList(growable: false)
      ..sort((k1, k2) => amounts[k1].compareTo(amounts[k2]));
    amounts = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => amounts[k]);

    for (int i = amounts.length - 1; i >= 0; i--) {
      await addToPopular(amounts.keys.elementAt(i));
    }
    await convertToRecipe(widget.popular, 3).then((value) {
      if (!mounted) {
        return;
      }
    });
  }

  Future<void> addToPopular(String docID) async {
    var recipe = await Firestore.instance
        .collection('publish recipe')
        .document(docID)
        .get();
    String recipeId = recipe.data['recipeId'];
    String userId = recipe.data['userID'];
    if (!mounted) {
      return;
    }
    setState(() {
      widget.popular.add(Pair(userId, recipeId));
    });
  }

  double calculate(int n) {
    double e = exp(-n);
    return (1 / (1 + e)) * 2 - 1;
  }

  Future convertToRecipe(List<Pair> pair, int cameFrom) async {
    for (int i = 0; i < pair.length; i++) {
      String writerId = pair[i].user;
      String recipeId = pair[i].recipe;
      DocumentSnapshot recipe = await Firestore.instance
          .collection('users')
          .document(writerId)
          .collection('recipes')
          .document(recipeId)
          .get();
      String publish = recipe.data["publishID"] ?? '';
      if (publish == "") {
        continue;
      }
      String path = recipe.data['imagePath'] ?? '';
      Recipe r = Recipe.forSearchRecipe(recipeId, writerId, path);

      switch (cameFrom) {
        case 1:
          bool check = false;

          for (int i = 0; i < widget.friendsRecipes.length; i++) {
            if (widget.friendsRecipes[i].id == r.id) {
              check = true;
            }
          }
          if (!check) {
            widget.friendsRecipes.add(r);
          }
          break;
        case 2:
          bool check = false;

          for (int i = 0; i < widget.tagsRecipes.length; i++) {
            if (widget.tagsRecipes[i].id == r.id) {
              check = true;
            }
          }
          if (!check) {
            widget.tagsRecipes.add(r);
          }
          break;
        case 3:
          bool check = false;

          for (int i = 0; i < widget.popularRecipes.length; i++) {
            if (widget.popularRecipes[i].id == r.id) {
              check = true;
            }
          }
          if (!check) {
            widget.popularRecipes.add(r);
          }
          break;
        default:
      }
    }
    switch (cameFrom) {
      case 1:
        if (!mounted) {
          return;
        }
        setState(() {
          widget.doneFriends = true;
        });
        break;
      case 2:
        if (!mounted) {
          return;
        }
        setState(() {
          widget.doneTags = true;
        });
        break;
      case 3:
        if (!mounted) {
          return;
        }
        setState(() {
          widget.donePopular = true;
        });
        break;
      default:
    }
  }

  void unitRecipesList() {
    bool doneLiles = false;
    bool doneGroups = false;
    bool doneUsers = false;

    if (widget.friendsRecipes.length == 0) {
      doneLiles = true;
    }
    if (widget.popularRecipes.length == 0) {
      doneGroups = true;
    }
    if (widget.tagsRecipes.length == 0) {
      doneUsers = true;
    }
    if (doneUsers && doneGroups && doneLiles) {
      setState(() {
        widget.doneLoadCounter = true;
      });
    }
    int i = 0;
    while ((!doneUsers) || (!doneGroups) || (!doneLiles)) {
      if (i < widget.friendsRecipes.length) {
        if (widget.recipes.length > 0) {
          Recipe a = widget.recipes.firstWhere(
              (element) => element.id == widget.friendsRecipes[i].id,
              orElse: () => null);
          if (a == null) {
            setState(() {
              widget.recipes.add(widget.friendsRecipes[i]);
            });
          }
        } else {
          setState(() {
            widget.recipes.add(widget.friendsRecipes[i]);
          });
        }
      } else {
        doneLiles = true;
      }
      if (i < widget.popularRecipes.length) {
        if (widget.recipes.length > 0) {
          Recipe a = widget.recipes.firstWhere(
              (element) => element.id == widget.popularRecipes[i].id,
              orElse: () => null);
          if (a == null) {
            setState(() {
              widget.recipes.add(widget.popularRecipes[i]);
            });
          }
        } else {
          setState(() {
            widget.recipes.add(widget.popularRecipes[i]);
          });
        }
      } else {
        doneGroups = true;
      }
      if (i < widget.tagsRecipes.length) {
        if (widget.recipes.length > 0) {
          Recipe a = widget.recipes.firstWhere(
              (element) => element.id == widget.tagsRecipes[i].id,
              orElse: () => null);
          if (a == null) {
            setState(() {
              widget.recipes.add(widget.tagsRecipes[i]);
            });
          }
        } else {
          setState(() {
            widget.recipes.add(widget.tagsRecipes[i]);
          });
        }
      } else {
        doneUsers = true;
      }
      i++;
      setState(() {
        widget.doneLoadCounter = true;
      });
    }
    setState(() {
      widget.doneFriends = false;
      widget.donePopular = false;
      widget.doneTags = false;
    });
  }
}
