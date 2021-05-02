import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/recipe.dart';

class Pair<T1, T2> {
  final String user;
  final String recipe;

  Pair(this.user, this.recipe);
}

class Algoritem {
  List listusers = [];
  List<Pair> list = [];
  List<Recipe> recipes = [];
  Map<String, int> amountLikesOfRecipe = {};
  Map<String, int> amountGroupsOfRecipe = {};
  Map<String, int> amountUsersOfRecipe = {};
  List popular = [];
  String uid;
  Algoritem(String _uid) {
    uid = _uid;
  }

  Stream<void> getPopularRecipes() async* {
    await getUserAmount();
    await getGroupsAmount();
    await getLikesAmount();
    await getUserAndRecipe(amountLikesOfRecipe);
    await getUserAndRecipe(amountGroupsOfRecipe);
    await getUserAndRecipe(amountUsersOfRecipe);
    await convertToRecipe(popular);
  }

  getUserAndRecipe(Map<String, int> map) async {
    for (int i = 0; i < map.length; i++) {
      var recipe = await Firestore.instance
          .collection('publish recipe')
          .document(map.keys.elementAt(i))
          .get();
      String recipeId = recipe.data['recipeId'];
      String userId = recipe.data['userID'];
      popular.add(Pair(userId, recipeId));
    }
  }

  getUserAmount() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List users = element.data['saveUser'] ?? [];
      int amount = users.length;
      amountUsersOfRecipe[recipeId] = amount;
    });
    amountUsersOfRecipe = SplayTreeMap.from(
        amountUsersOfRecipe,
        (key1, key2) =>
            amountUsersOfRecipe[key1].compareTo(amountUsersOfRecipe[key2]));
    print("listttt user: " + amountUsersOfRecipe.toString());
  }

  getGroupsAmount() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List groups = element.data['saveInGroup'] ?? [];
      int amount = groups.length;
      amountGroupsOfRecipe[recipeId] = amount;
      print("listttt group: " + amountGroupsOfRecipe.toString());
    });
    amountGroupsOfRecipe = SplayTreeMap.from(
        amountGroupsOfRecipe,
        (key1, key2) =>
            amountGroupsOfRecipe[key1].compareTo(amountGroupsOfRecipe[key2]));
    print("listttt group: " + amountGroupsOfRecipe.toString());
  }

  getLikesAmount() async {
    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();
    // get amount of likes of all the publish recipes
    snap.documents.forEach((element) {
      String recipeId = element.documentID.toString();
      List likes = element.data['likes'] ?? [];
      int amount = likes.length;
      amountLikesOfRecipe[recipeId] = amount;
    });
    amountLikesOfRecipe = SplayTreeMap.from(
        amountLikesOfRecipe,
        (key1, key2) =>
            amountLikesOfRecipe[key1].compareTo(amountLikesOfRecipe[key2]));
    print("listttt likes: " + amountLikesOfRecipe.toString());
  }

  Future<void> myFriends(String uid) async {
    int i = 0;
    print(uid);
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('groups')
        .getDocuments();
    snap.documents.forEach((element) async {
      // print(element.data['groupId']);
      // i++;
      //  print("element");
      // print(i);
      String groupId = element.data['groupId'];
      DocumentSnapshot snapGroup =
          await Firestore.instance.collection('Group').document(groupId).get();
      List users = snapGroup.data['users'];
      listusers.addAll(users);
      i++;

      //  print(snap.documents.length);

      if (i == snap.documents.length) {
        //  print("if");
        //  print(listusers);

        for (int i = 0; i < listusers.length; i++) {
          //  print(groupId);
          //  print(users[i]);
          QuerySnapshot snap3 = await Firestore.instance
              .collection('users')
              .document(listusers[i])
              .collection('saved recipe')
              .getDocuments();
          snap3.documents.forEach((element) async {
            String uid2 = element.data['userID'];
            String recipeId2 = element.data['recipeID'];
            // print("add");
            list.add(Pair(uid2, recipeId2));
          });
        }
        // print("for");
        print(list);
        convertToRecipe(list);
      }
    });
    //return friendsRecipe;
    //  print("friends recipe");
    //   print(friendsRecipe);
  }

  Future<void> convertToRecipe(List<Pair> pair) async {
    print("convert");
    for (int i = 0; i < pair.length; i++) {
      String uid = pair[i].user;
      String recipeId = pair[i].recipe;
      print(uid);
      print(recipeId);
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
      Recipe r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI,
          true, id, publish, path);
      recipes.add(r);
      // print("Add");
      // print(recipesFromFriends);
    }
    print("done");
    // return recipesFromFriends;
  }
}
