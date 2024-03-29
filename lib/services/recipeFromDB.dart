import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/models/recipe.dart';
import '../shared_screen/config.dart';

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
    // var tags =
    //     await db.collection('tags').document('xt0XXXOLgprfkO3QiANs').get();

    // for (int i = 0; i < recipe.tags.length; i++) {
    //   List tag = tags.data[recipe.tags[i]];
    //   List copyTag = [];
    //   copyTag.addAll(tag);
    //   copyTag.
    // }
  }

  static Recipe convertSnapshotToRecipe(DocumentSnapshot recipe) {
    var id = recipe.documentID;
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

    // notes
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
    var id = recipe.documentID;
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

    // notes
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

  static Future<List> getLikesPublishRecipe(String publishId) async {
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
      String writerId = await userRecipes.documents[i].data['writerUid'] ?? "";
      String recipeId = await userRecipes.documents[i].data['recipeID'] ?? "";
      if (publishId != "") {
        deletePublishRecipe(publishId);
        deletePublishRecipeFromAllDirectories(writerId, recipeId);
      }
    }
  }

  static deletePublishRecipeFromAllDirectories(
      String writerId, String recipeId) async {
    QuerySnapshot users = await db.collection('users').getDocuments();
    for (int i = 0; i < users.documents.length; i++) {
      QuerySnapshot userDirectories = await Firestore.instance
          .collection('users')
          .document(users.documents[i].documentID)
          .collection('Directory')
          .getDocuments();
      for (int j = 0; j < userDirectories.documents.length; j++) {
        Map<dynamic, dynamic> directoryRecipes =
            userDirectories.documents[j].data['Recipes'] ?? {};
        Map<String, String> copyRecipes =
            new Map<String, String>.from(directoryRecipes);

        if (copyRecipes.keys.contains(writerId)) {
          copyRecipes.remove(writerId);
          await db
              .collection('users')
              .document(users.documents[i].documentID)
              .collection('Directory')
              .document(userDirectories.documents[j].documentID)
              .updateData({'Recipes': copyRecipes});
        }
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
      String recipeId, String publishId, String directoryId) async {
    DocumentSnapshot directory = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(directoryId)
        .get();
    Map<dynamic, dynamic> recipes = directory.data['Recipes'] ?? {};

    //remove recipe from list
    Map<dynamic, dynamic> copyRecipe = new Map<dynamic, dynamic>.from(recipes);
    copyRecipe.remove(recipeId);
    Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(directoryId)
        .updateData({'Recipes': copyRecipe});
  }

  static Future<void> deleteFromFavoriteRecipe(
      String uid, String recipeUserid, String recipeId) async {
    //find recipe in directory
    QuerySnapshot savedDirectory = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .getDocuments();
    for (int i = 0; i < savedDirectory.documents.length; i++) {
      Map<dynamic, dynamic> recipes =
          savedDirectory.documents[i].data['Recipes'] ?? {};
      if (recipes.keys.contains(recipeId)) {
        //remove recipe from list
        Map<dynamic, dynamic> copyRecipe = {};
        copyRecipe.addAll(recipes);
        copyRecipe.remove(recipeId);
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

  static Future<void> deleteRecipe(String publish, String recipeId, String uid,
      List tags, String writerId) async {
    // publish recipe
    if (publish != '') {
      DocumentSnapshot publishRecipe = await Firestore.instance
          .collection('publish recipe')
          .document(publish)
          .get();
      List users = publishRecipe.data['saveUser'] ?? [];
      deleteRecipeFromAllUsers(users, recipeId, writerId);
      deleteRecipeFromUserDirectory(recipeId, uid);
      deleteRcipeFromTags(tags, publish);
      deletePublishRecipe(publish);
    }
    deleteRecipeFromAllGroups(recipeId);
    deleteRecipeFromUser(uid, recipeId);
  }

  static deleteRecipeFromUserDirectory(String recipeId, String uid) async {
    QuerySnapshot userDirectories = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .getDocuments();
    for (int i = 0; i < userDirectories.documents.length; i++) {
      Map<dynamic, dynamic> recipes =
          userDirectories.documents[i].data['Recipes'] ?? {};

      Map<String, String> copyRecipes = new Map<String, String>.from(recipes);

      if (copyRecipes.keys.contains(recipeId)) {
        copyRecipes.remove(recipeId);
        await db
            .collection('users')
            .document(uid)
            .collection('Directory')
            .document(userDirectories.documents[i].documentID)
            .updateData({'Recipes': copyRecipes});
      }
    }
  }

  static Future deleteRcipeFromTags(List tagsList, String publishId) async {
    final db = Firestore.instance;
    var tags =
        await db.collection('tags').document('xt0XXXOLgprfkO3QiANs').get();
    for (int i = 0; i < tagsList.length; i++) {
      List tag = tags.data[tagsList[i]];
      List copyTag = [];
      copyTag.addAll(tag);
      copyTag.remove(publishId);
      db
          .collection('tags')
          .document('xt0XXXOLgprfkO3QiANs')
          .updateData({tagsList[i]: copyTag});
    }
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

  static Future deleteRecipeFromAllUsers(
      List users, String recipeId, String writerId) async {
    for (int i = 0; i < users.length; i++) {
      QuerySnapshot userSavedRecipes = await Firestore.instance
          .collection('users')
          .document(users[i])
          .collection('saved recipe')
          .getDocuments();
      for (int j = 0; j < userSavedRecipes.documents.length; j++) {
        String recipesToCheck =
            userSavedRecipes.documents[j].data['recipeID'] ?? "";
        if (recipesToCheck == recipeId) {
          await db
              .collection('users')
              .document(users[i])
              .collection('saved recipe')
              .document(userSavedRecipes.documents[j].documentID)
              .delete();
        }
      }

      QuerySnapshot userDirectories = await Firestore.instance
          .collection('users')
          .document(users[i])
          .collection('Directory')
          .getDocuments();
      for (int j = 0; j < userDirectories.documents.length; j++) {
        Map<dynamic, dynamic> directoryRecipes =
            userDirectories.documents[j].data['Recipes'] ?? {};
        Map<String, String> copyRecipes =
            new Map<String, String>.from(directoryRecipes);

        if (copyRecipes.keys.contains(recipeId)) {
          copyRecipes.remove(recipeId);
          await db
              .collection('users')
              .document(users[i])
              .collection('Directory')
              .document(userDirectories.documents[j].documentID)
              .updateData({'Recipes': copyRecipes});
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
    if (directoryId == null) {
      return [];
    }
    List<Recipe> directoryRecipes = [];
    DocumentSnapshot directory = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(directoryId)
        .get();
    Map<dynamic, dynamic> list = directory.data['Recipes'] ?? {};
    for (int i = 0; i < list.length; i++) {
      String writerId = list.values.elementAt(i);
      String recipeId = list.keys.elementAt(i);
      Recipe r = await getRecipeOfUser(writerId, recipeId);
      directoryRecipes.add(r);
    }
    return directoryRecipes;
  }

  static getPublishRecipe(String id) async {
    DocumentSnapshot publishRecipe = await Firestore.instance
        .collection('publish recipe')
        .document(id)
        .get();
    return publishRecipe;
  }

  static void saveRecipe(
      String uid, String recipeId, String writerId, bool saveInUser) async {
    QuerySnapshot savedRecipes = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('saved recipe')
        .getDocuments();
    bool found = false;
    for (int i = 0; i < savedRecipes.documents.length; i++) {
      String id = savedRecipes.documents[i].data['recipeID'];
      String userID = savedRecipes.documents[i].data['userID'];
      if ((id == recipeId) && (userID == writerId)) {
        found = true;
      }
    }
    if (!found) {
      final db = Firestore.instance;
      db.collection('users').document(uid).collection('saved recipe').add(
          {'saveInUser': saveInUser, 'recipeID': recipeId, 'userID': writerId});

      String id;
      QuerySnapshot snap =
          await Firestore.instance.collection('publish recipe').getDocuments();
      for (int i = 0; i < snap.documents.length; i++) {
        if (snap.documents[i].data['recipeId'] == recipeId) {
          id = snap.documents[i].documentID;
          var currentRecipe2 =
              await db.collection('publish recipe').document(id).get();
          List publishUsers = [];
          List loadList = currentRecipe2.data['saveUser'] ?? [];
          publishUsers.addAll(loadList);
          publishUsers.add(uid);
          await db
              .collection('publish recipe')
              .document(id)
              .updateData({'saveUser': publishUsers});
        }
      }
    }
  }

  static saveNotesInRecipe(
      String uid, String saveRecipeId, List<String> notes) async {
    await db
        .collection(usersCollectionName)
        .document(uid)
        .collection('saved recipe')
        .document(saveRecipeId)
        .updateData({'notes': notes});
  }

  static Future<String> like(String publishId, String uid) async {
    DocumentSnapshot currentRecipe = await Firestore.instance
        .collection('publish recipe')
        .document(publishId)
        .get();

    // user likes
    DocumentSnapshot currentUser = await Firestore.instance
        .collection('users')
        .document(uid.toString())
        .get();
    List likes = [];
    List loadList = currentUser.data['likes'] ?? [];
    likes.addAll(loadList);
    likes.add(publishId);
    db
        .collection('users')
        .document(uid.toString())
        .updateData({'likes': likes});

    // recipe likes
    likes = [];
    loadList = currentRecipe.data['likes'] ?? [];
    likes.addAll(loadList);
    likes.add(uid.toString());
    db
        .collection('publish recipe')
        .document(publishId)
        .updateData({'likes': likes});
    return currentUser.data['Email'] ?? "";
  }

  static Future<void> unlike(String publishId, String uid) async {
    DocumentSnapshot currentRecipe = await Firestore.instance
        .collection('publish recipe')
        .document(publishId)
        .get();

    // user likes
    DocumentSnapshot currentUser = await Firestore.instance
        .collection('users')
        .document(uid.toString())
        .get();
    List likes = [];
    List loadList = currentUser.data['likes'] ?? [];
    likes.addAll(loadList);
    likes.remove(publishId);
    db
        .collection('users')
        .document(uid.toString())
        .updateData({'likes': likes});

    // recipe likes
    likes = [];
    loadList = currentRecipe.data['likes'] ?? [];
    likes.addAll(loadList);
    likes.remove(uid.toString());
    db
        .collection('publish recipe')
        .document(publishId)
        .updateData({'likes': likes});
    return currentUser.data['Email'] ?? "";
  }

  static deleteUserFromPublishRecipe(String uid) async {
    QuerySnapshot publishRecipes =
        await db.collection('publish recipe').getDocuments();
    for (int i = 0; i < publishRecipes.documents.length; i++) {
      List likes = publishRecipes.documents[i].data['likes'] ?? [];
      List copy = [];
      copy.addAll(likes);
      if (copy.contains(uid)) {
        copy.remove(uid);
      }
      await db
          .collection('publish recipe')
          .document(publishRecipes.documents[i].documentID)
          .updateData({'likes': copy});

      List users = publishRecipes.documents[i].data['saveUser'] ?? [];
      copy = [];
      copy.addAll(users);
      if (copy.contains(uid)) {
        copy.remove(uid);
      }
      await db
          .collection('publish recipe')
          .document(publishRecipes.documents[i].documentID)
          .updateData({'saveUser': copy});
    }
  }
}
