import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/models/recipe.dart';

import '../config.dart';

class RecipeFromDB {
  static final db = Firestore.instance;

  static insertNewRecipe(Recipe recipe) async {
    // set recipe fields
    var currentRecipe = await db
        .collection('users')
        .document(recipe.writerUid)
        .collection('recipes')
        .add(recipe.toJson());

    // set the new id to data base
    String id = currentRecipe.documentID.toString();
    recipe.setId(id);
    await db
        .collection('users')
        .document(recipe.writerUid)
        .collection('recipes')
        .document(id)
        .updateData({'recipeID': id});

    // set recipe ingredients
    for (int i = 0; i < recipe.ingredients.length; i++) {
      await db
          .collection('users')
          .document(recipe.writerUid)
          .collection('recipes')
          .document(id)
          .collection('ingredients')
          .add(recipe.ingredients[i].toJson());
    }

    // set recipe stages
    for (int i = 0; i < recipe.stages.length; i++) {
      await db
          .collection('users')
          .document(recipe.writerUid)
          .collection('recipes')
          .document(id)
          .collection('stages')
          .add(recipe.stages[i].toJson(i));
    }
  }

  static Recipe convertSnapshotToRecipe(DocumentSnapshot recipe) {
    var id = recipe.documentID;
    String name = recipe.data['name'] ?? '';
    String description = recipe.data['description'] ?? '';
    String level = recipe.data['level'] ?? 0;
    int levelInt = int.parse(level);
    String time = recipe.data['time'] ?? '0';
    int timeInt = int.parse(time);
    String writer = recipe.data['writer'] ?? '';
    String writerUid = recipe.data['writerUid'] ?? '';
    String publish = recipe.data['publishID'] ?? '';

    // tags
    var tags = recipe.data['tags'] ?? [];
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
    var note = recipe.data['tags'];
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

    Recipe r = Recipe(name, description, l, levelInt, nList, writer, writerUid,
        timeInt, false, id, publish, '');
    r.setId(id);
    return r;
  }

  static Future<String> getRecipeIdFromElement(DocumentSnapshot element) async {
    return await element.data['recipeId'] ?? '';
  }

  static Future<Recipe> getRecipeOfUser(String uid, String recipeId) async {
    DocumentSnapshot recipe = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('recipes')
        .document(recipeId)
        .get();
    return convertSnapshotToRecipe(recipe);
  }

  static Future<List<String>> getLikesPublishRecipe(String publishId) async {
    var publishRecipe =
        await db.collection(publishCollectionName).document(publishId).get();
    return await publishRecipe.data['likes'] ?? [];
  }

  static Future<void> updateWriterOfRecipes(String uid, String fullName) async {
    var recipes = await Firestore.instance
        .collection(usersCollectionName)
        .document(uid)
        .collection('recipes')
        .getDocuments();

    // change the writer name in all the recipes
    for (int i = 0; i < recipes.documents.length; i++) {
      var recipeId = recipes.documents[i].documentID.toString();
      await db
          .collection(usersCollectionName)
          .document(uid)
          .collection('recipes')
          .document(recipeId)
          .updateData({'writer': fullName});
    }
  }

  static Future<void> deletePublushRecipesOfUser(String uid) async {
    QuerySnapshot userRecipes = await db
        .collection('users')
        .document(uid)
        .collection('recipes')
        .getDocuments();
    for (int i = 0; i < userRecipes.documents.length; i++) {
      String publishId = await userRecipes.documents[i].data['publishID'] ?? "";
      if (publishId != "") {
        deletePublishRecipe(publishId);
      }
    }
  }

  static deletePublishRecipe(String publishId) async {
    await db.collection('publish recipe').document(publishId).delete();
  }
}
