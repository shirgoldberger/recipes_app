import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/models/recipe.dart';

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
  // collection redernce
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName, String phone,
      int age, String email, String imagePath) async {
    Map<String, int> tags = {
      'choose recipe tag': 0,
      'fish': 0,
      'meat': 0,
      'dairy': 0,
      'desert': 0,
      'for children': 0,
      'other': 0,
      //
      'vegetarian': 0,
      'Gluten free': 0,
      'without sugar': 0,
      'vegan': 0,
      'Without milk': 0,
      'No eggs': 0,
      'kosher': 0,
      'baking': 0,
      'cakes and cookies': 0,
      'Food toppings': 0,
      'Salads': 0,
      'Soups': 0,
      'Pasta': 0,
      'No carbs': 0,
      'Spreads': 0
    };
    return await userCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'Email': email,
      'age': age,
      'phone': phone,
      'imagePath': imagePath,
      'tags': tags
    });
  }

  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        firstName: snapshot.data['firstName'],
        lastName: snapshot.data['lastName'],
        email: snapshot.data['Email'],
        age: snapshot.data['age'],
        phone: snapshot.data['phone'],
        imagePath: snapshot.data['imagePath']);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  // get recipe list
  Stream<List<Recipe>> get recipe {
    return recipeCollection.snapshots().map(_recipeListFromSnapshot);
  }

  // get recipe list
  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      var id = doc.documentID;
      String n = doc.data['name'] ?? '';
      String de = doc.data['description'] ?? '';
      String level = doc.data['level'] ?? 0;
      String time = doc.data['time'] ?? '0';
      int timeI = int.parse(time);
      String writer = doc.data['writer'] ?? '';
      String writerUid = doc.data['writerUid'] ?? '';
      String publish = doc.data['publishID'] ?? '';
      String path = doc.data['imagePath'] ?? '';
      int levlelInt = int.parse(level);
      // tags
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
      // notes
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
      // create recipe
      Recipe r = Recipe(n, de, l, levlelInt, nList, writer, writerUid, timeI,
          true, id, publish, path);
      r.setId(id);
      return r;
    }).toList();
  }
}
