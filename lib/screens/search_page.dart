import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screens/home_screen/watchRecipe.dart';
import 'package:recipes_app/services/fireStorageService.dart';
import 'package:recipes_app/shared_screen/loading.dart';

import '../searchAlgorithm.dart';

class SearchPage extends StatefulWidget {
  bool home;
  List<Recipe> publisRecipe = [];
  bool doneLoadPublishRecipe = true;
  bool doneGetUser = false;
  String uid;
  bool getUser = false;
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
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      widget.uid = user.uid;
      widget.getUser = true;
    });
  }

  void changeState() {
    widget.publisRecipe = [];
    // widget.doneLoadPublishRecipe = false;
    if (!widget.doneLoadPublishRecipe) {
      setState(() {
        widget.doneLoadPublishRecipe = true;
      });
      // loadPublishRecipe();
    }
  }

  Widget box = SizedBox(
    height: 20.0,
  );

  Future<Widget> _getImage(BuildContext context, String image) async {
    if (image == "") {
      return Image.asset('lib/images/no_image.jpg', fit: BoxFit.fill);
    }
    image = "uploads/" + image;
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.fitHeight,
        // height: 100,
        // width: 100,
      );
    });
    return m;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.getUser) {
      Algoritem a = new Algoritem(widget.uid);
      a.allRecipe().whenComplete(() {
        print("shir");
        widget.publisRecipe.addAll(a.recipes);
      });
      print("saerch");
    }
    if (!widget.doneLoadPublishRecipe) {
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
                SearchInput(),
                box,
                Container(
                  height: 500,
                  child: GridView.count(
                    crossAxisCount: 3,
                    children:
                        List.generate(widget.publisRecipe.length, (index) {
                      return Container(
                          height: 500,
                          width: 500,
                          child: Card(
                            shape:
                                RoundedRectangleBorder(side: BorderSide.none),
                            child: _buildOneItem(index),
                          ));
                    }),
                  ),
                )
              ]))))));
    }
  }

  Widget _buildOneItem(int index) {
    if (widget.publisRecipe.length <= index) {
      return Container();
    }
    return FutureBuilder(
        future: _getImage(context, widget.publisRecipe[index].imagePath),
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
                            WatchRecipe(widget.publisRecipe[index], true)));
              },
            );

          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 10,
                child: CircularProgressIndicator());
        });
  }

  Future<void> loadPublishRecipe() async {
    String uid;
    String recipeId;
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    widget.publisRecipe = [];
    if (snap.documents.length == 0) {
      setState(() {
        widget.doneLoadPublishRecipe = true;
      });
    }
    int i = 0;
    snap.documents.forEach((element) async {
      uid = element.data['userID'] ?? '';
      recipeId = element.data['recipeId'] ?? '';
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
      String imagePath = doc.data['imagePath'] ?? '';
      //
      String publish = doc.data['publishID'] ?? '';
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
      Recipe r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI,
          true, id, publish, imagePath);
      // r.setId(id);
      // print(publish + "publish");
      //r.publishThisRecipe(publish);
      widget.publisRecipe.add(r);
      // print(r.publish);
      i++;
      print("i -     " + i.toString());
      print(snap.documents.length);
      // print(snap.documents.length);
      if ((i) == snap.documents.length) {
        setState(() {
          widget.doneLoadPublishRecipe = true;
        });
      }
    });
  }

  // Future<void> loadPublishRecipe() async {
  //   String uid;
  //   String recipeId;
  //   QuerySnapshot snap =
  //       await Firestore.instance.collection('publish recipe').getDocuments();
  //   widget.publisRecipe = [];
  //   if (snap.documents.length == 0) {
  //     setState(() {
  //       widget.doneLoadPublishRecipe = true;
  //     });
  //   }
  //   int i = 0;
  //   snap.documents.forEach((element) async {
  //     // get user id and recipe id
  //     uid = element.data['userID'] ?? '';
  //     recipeId = element.data['recipeId'] ?? '';
  //     // get the cpecific recipe document
  //     DocumentSnapshot doc = await Firestore.instance
  //         .collection('users')
  //         .document(uid)
  //         .collection('recipes')
  //         .document(recipeId)
  //         .get();
  //     String imagePath = doc.data['imagePath'] ?? '';
  //     Recipe r = Recipe.forSearchRecipe(uid, imagePath);
  //     widget.publisRecipe.add(r);
  //     i++;
  //     if ((i) == snap.documents.length) {
  //       setState(() {
  //         widget.doneLoadPublishRecipe = true;
  //       });
  //     }
  //   });
  // }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 30,
      child: TextField(
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
      ),
    );
  }
}
