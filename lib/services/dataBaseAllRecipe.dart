import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/models/recipe.dart';

class DataBaseAllRecipes {
  DataBaseAllRecipes() {
    recipeCollection = Firestore.instance.collection('recipes');
    publishRecipeCollection = Firestore.instance.collection('publish recipe');
  }

  CollectionReference recipeCollection;
  CollectionReference publishRecipeCollection;

  Stream<List<Recipe>> get allRecipe {
    return recipeCollection.snapshots().map(_recipeListFromSnapshot);
  }

  //get recipe list
  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot) {
    List<Recipe> recipeList = snapshot.documents.map((doc) {
      return convertToRecipe(doc);
    }).toList();
    return recipeList;
  }

  Recipe convertToRecipe(DocumentSnapshot doc) {
    var id = doc.documentID;
    String n = doc.data['name'] ?? '';
    String de = doc.data['description'] ?? '';
    String level = doc.data['level'] ?? 0;
    String time = doc.data['time'] ?? '0';
    int timeI = int.parse(time);
    String writer = doc.data['writer'] ?? '';
    String writerUid = doc.data['writerUid'] ?? '';
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
        false, id, publish, '');
    r.setId(id);
    return r;
  }

  Future<List<Recipe>> getPublishRecipe() async {
    List<Recipe> publicRecipeList = [];
    String uid;
    String recipeId;

    QuerySnapshot snap =
        await Firestore.instance.collection('publish recipe').getDocuments();

    snap.documents.forEach((element) {
      uid = element.data['userID'] ?? '';
      recipeId = element.data['recipeId'] ?? '';
      DocumentSnapshot doc2 = Firestore.instance
          .collection('users')
          .document(uid)
          .collection('recipes')
          .document(recipeId) as DocumentSnapshot;
      publicRecipeList.add(convertToRecipe(doc2));
    });
    return publicRecipeList;
  }
}
