import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes_app/models/ingresients.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/screen/home_screen/ingredients.dart';

class DataBaseService {
  String uid;
  CollectionReference recipeCollection;
  DataBaseService(String u) {
    this.uid = u;
    recipeCollection = Firestore.instance
        .collection('users')
        .document(uid)
        .collection('recipes');
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //collection redernce
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName, String phone,
      int age, String email) async {
    return await userCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'Email': email,
      'age': age,
      'phone': phone
    });
  }

  Future<String> getCurrentUID() async {
    print("noaaaaaa");
    return (await _firebaseAuth.currentUser()).uid;
  }
  //user data from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        firstName: snapshot.data['firstName'],
        lastName: snapshot.data['lastName'],
        email: snapshot.data['Email'],
        age: snapshot.data['age'],
        phone: snapshot.data['phone']);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  //get recipe list
  Stream<List<Recipe>> get recipe {
    return recipeCollection.snapshots().map(_recipeListFromSnapshot);
  }

  //get recipe list
  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot) {
    List<String> o;
    return snapshot.documents.map((doc) {
      String n = doc.data['name'] ?? '';
      String de = doc.data['description'] ?? '';

      return Recipe(n, de);
    }).toList();
  }
}
