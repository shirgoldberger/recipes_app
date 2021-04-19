import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Algo {
  static Map<String, int> amountLikesOfRecipe = {};
  static Map<String, int> amountGroupsOfRecipe = {};
  static Map<String, int> amountUsersOfRecipe = {};
  getPopularRecipes() async {}

  static getUserAmount() async {
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

  static getGroupsAmount() async {
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

  static getLikesAmount() async {
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
}
