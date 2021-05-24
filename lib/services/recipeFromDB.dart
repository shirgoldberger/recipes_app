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
    print(id);
    String name = recipe.data['name'] ?? '';
    String description = recipe.data['description'] ?? '';
    String level = recipe.data['level'] ?? '0';
    int levelInt = int.parse(level);
    String time = recipe.data['time'] ?? '0';
    int timeInt = int.parse(time);
    String writer = recipe.data['writer'] ?? '';
    String writerUid = recipe.data['writerUid'] ?? '';
    String publish = recipe.data['publishID'] ?? '';
    String imagePath = recipe.data['imagePath'] ?? '';

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
    List nList = recipe.data['notes'];
    List<String> noteList = [];
    for (int i = 0; i < nList.length; i++) {
      String note = nList[i].toString();
      noteList.add(note);
    }

    Recipe r = Recipe(name, description, l, levelInt, noteList, writer,
        writerUid, timeInt, true, id, publish, imagePath);
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

  static Future<void> deleteFromSavedRecipe(String uid, String recipeId) async {
    QuerySnapshot savedRecipes = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('saved recipe')
        .getDocuments();
    for (int i = 0; i < savedRecipes.documents.length; i++) {
      String recipeIdfromSnap = savedRecipes.documents[i].data['recipeID'];
      if (recipeIdfromSnap == recipeId) {
        db
            .collection('users')
            .document(uid)
            .collection('saved recipe')
            .document(savedRecipes.documents[i].documentID)
            .delete();
      }
    }
  }

  static Future<void> deleteFromDirectoryRecipe(String uid, String recipeUserid,
      String recipeId, String directoryId) async {
    //get publish id
    DocumentSnapshot publishRecipe = await Firestore.instance
        .collection('users')
        .document(recipeUserid)
        .collection('recipes')
        .document(recipeId)
        .get();
    String publishID = publishRecipe.data['publishID'];
    //delete from directory
    DocumentSnapshot directory = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(directoryId)
        .get();
    List recipes = directory.data['Recipes'];

    //remove recipe from list
    List copyRecipe = [];
    copyRecipe.addAll(recipes);
    copyRecipe.remove(publishID);
    Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(directoryId)
        .updateData({'Recipes': copyRecipe});
  }

  static Future<void> deleteFromFavoriteRecipe(
      String uid, String recipeUserid, String recipeId) async {
    DocumentSnapshot publishRecipe = await Firestore.instance
        .collection('users')
        .document(recipeUserid)
        .collection('recipes')
        .document(recipeId)
        .get();
    String publishID = publishRecipe.data['publishID'];
    //find recipe in directory
    QuerySnapshot savedDirectory = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .getDocuments();
    for (int i = 0; i < savedDirectory.documents.length; i++) {
      List recipes = savedDirectory.documents[i].data['Recipes'];
      if (recipes.contains(publishID)) {
        //remove recipe from list
        List copyRecipe = [];
        copyRecipe.addAll(recipes);
        copyRecipe.remove(publishID);
        Firestore.instance
            .collection('users')
            .document(uid)
            .collection('Directory')
            .document(savedDirectory.documents[i].documentID)
            .updateData({'Recipes': copyRecipe});
      }
    }
    QuerySnapshot savedRecipes = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('saved recipe')
        .getDocuments();
    for (int i = 0; i < savedRecipes.documents.length; i++) {
      String recipeIdfromSnap = savedRecipes.documents[i].data['recipeID'];
      if (recipeIdfromSnap == recipeId) {
        db
            .collection('users')
            .document(uid)
            .collection('saved recipe')
            .document(savedRecipes.documents[i].documentID)
            .delete();
      }
    }
  }

  static Future<void> deleteRecipe(
      String publish, String recipeId, String uid) async {
    // publish recipe
    if (publish != '') {
      DocumentSnapshot publishRecipe = await Firestore.instance
          .collection('publish recipe')
          .document(publish)
          .get();
      List users = publishRecipe.data['saveUser'] ?? [];
      deleteRecipeFromAllUsers(users, recipeId);
      deletePublishRecipe(publish);
    }
    deleteRecipeFromAllGroups(recipeId);
    deleteRecipeFromUser(uid, recipeId);
  }

  static Future deleteRecipeFromAllGroups(String recipeId) async {
    QuerySnapshot groups =
        await Firestore.instance.collection('Group').getDocuments();
    for (int i = 0; i < groups.documents.length; i++) {
      // all recipes of group i
      QuerySnapshot groupRecipes = await Firestore.instance
          .collection('Group')
          .document(groups.documents[i].documentID)
          .collection('recipes')
          .getDocuments();
      for (int j = 0; j < groupRecipes.documents.length; j++) {
        // the specific recipe
        if (groupRecipes.documents[j].data['recipeId'] == recipeId) {
          await db
              .collection('Group')
              .document(groups.documents[i].documentID)
              .collection('recipes')
              .document(groupRecipes.documents[j].documentID)
              .delete();
        }
      }
    }
  }

  static Future deleteRecipeFromAllUsers(List users, String recipeId) async {
    for (int i = 0; i < users.length; i++) {
      QuerySnapshot userSavedRecipes = await Firestore.instance
          .collection('users')
          .document(users[i])
          .collection('saved recipe')
          .getDocuments();
      for (int j = 0; j < userSavedRecipes.documents.length; j++) {
        if (userSavedRecipes.documents[j].data['recipeId'] == recipeId) {
          await db
              .collection('users')
              .document(users[i])
              .collection('saved recipe')
              .document(userSavedRecipes.documents[j].documentID)
              .delete();
        }
      }
    }
  }

  // delete recipe from the user that wrote it
  static Future deleteRecipeFromUser(String uid, String recipeId) async {
    //delete ingredients
    var a = await db
        .collection('users')
        .document(uid)
        .collection('recipes')
        .document(recipeId)
        .collection('ingredients')
        .getDocuments();
    for (int i = 0; i < a.documents.length; i++) {
      await db
          .collection('users')
          .document(uid)
          .collection('recipes')
          .document(recipeId)
          .collection('ingredients')
          .document(a.documents[i].documentID)
          .delete();
    }
    //delete stages
    var b = await db
        .collection('users')
        .document(uid)
        .collection('recipes')
        .document(recipeId)
        .collection('stages')
        .getDocuments();
    for (int i = 0; i < b.documents.length; i++) {
      await db
          .collection('users')
          .document(uid)
          .collection('recipes')
          .document(recipeId)
          .collection('stages')
          .document(b.documents[i].documentID)
          .delete();
    }
    await db
        .collection('users')
        .document(uid)
        .collection('recipes')
        .document(recipeId)
        .delete();
  }

  static Future<List<Recipe>> getDirectoryRecipesList(
      String uid, String directoryId) async {
    List<Recipe> directoryRecipes = [];
    DocumentSnapshot recipesList = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(directoryId)
        .get();
    List list = recipesList.data['Recipes'] ?? [];
    for (String publishId in list) {
      var publishRecipe =
          await db.collection('publish recipe').document(publishId).get();
      String writerId = await publishRecipe.data['userID'] ?? "";
      String recipeId = await publishRecipe.data['recipeId'] ?? "";
      Recipe r = await getRecipeOfUser(writerId, recipeId);
      directoryRecipes.add(r);
    }
    return directoryRecipes;
  }
}
