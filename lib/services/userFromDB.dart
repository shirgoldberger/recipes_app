import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/models/directory.dart';
import 'package:recipes_app/services/recipeFromDB.dart';

class UserFromDB {
  static final db = Firestore.instance;

  static Future<String> getUserFirstName(String uid) async {
    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(uid).get();
    return user.data['firstName'] ?? "";
  }

  static Future<String> getUserLastName(String uid) async {
    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(uid).get();
    return user.data['lastName'] ?? "";
  }

  static Future<String> getUserEmail(String uid) async {
    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(uid).get();
    return user.data['Email'] ?? "";
  }

  static Future<String> setUserEmail(String uid, String email) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'Email': email});
  }

  static getUserImage(String uid) async {
    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(uid).get();
    return user.data['imagePath'] ?? "";
  }

  static setUserImage(String uid, String imagePath) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'imagePath': imagePath});
  }

  static getUserPhone(String uid) async {
    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(uid).get();
    return user.data['phone'] ?? "";
  }

  static getUserAge(String uid) async {
    DocumentSnapshot user =
        await Firestore.instance.collection('users').document(uid).get();
    return user.data['age'] ?? "";
  }

  static insertToGroupByMail(String email) async {
    QuerySnapshot users =
        await Firestore.instance.collection('users').getDocuments();
    users.documents.forEach((element) async {
      String userMail = element.data['Email'] ?? '';
      if (userMail == email) {
        return element.documentID;
      }
    });
    return null;
  }

  static Future<String> getUserIdFromElement(DocumentSnapshot element) async {
    return await element.data['userId'] ?? '';
  }

  static Future<String> getUserByEmail(String email) async {
    QuerySnapshot users =
        await Firestore.instance.collection('users').getDocuments();
    String mailCheck;
    for (int i = 0; i < users.documents.length; i++) {
      mailCheck = users.documents[i].data['Email'] ?? '';
      if (mailCheck == email) {
        return users.documents[i].documentID;
      }
    }
    return null;
  }

  static Future deleteUser(String uid) async {
    QuerySnapshot saved_recipe = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('saved recipe')
        .getDocuments();
    if (saved_recipe.documents.length > 0) {
      saved_recipe.documents.forEach((element) async {
        await db
            .collection('users')
            .document(uid)
            .collection('saved recipe')
            .document(element.documentID)
            .delete();
      });
    }
    // delete directory:
    QuerySnapshot d = await db
        .collection('users')
        .document(uid)
        .collection('Directory')
        .getDocuments();
    for (int i = 0; i < d.documents.length; i++) {
      await db
          .collection('users')
          .document(uid)
          .collection('Directory')
          .document(d.documents[i].documentID)
          .delete();
    }
    // delete groups:
    QuerySnapshot g = await db
        .collection('users')
        .document(uid)
        .collection('groups')
        .getDocuments();
    for (int i = 0; i < g.documents.length; i++) {
      await db
          .collection('users')
          .document(uid)
          .collection('groups')
          .document(g.documents[i].documentID)
          .delete();
    }
    // delete recipes:
    QuerySnapshot r = await db
        .collection('users')
        .document(uid)
        .collection('recipes')
        .getDocuments();
    for (int i = 0; i < r.documents.length; i++) {
      String publish = r.documents[i].data['publishID'] ?? "";
      String recipeID = r.documents[i].data['recipeID'] ?? "";
      List tags = r.documents[i].data['tags'];
      String writerId = r.documents[i].data['writerUid'] ?? "";
      RecipeFromDB.deleteRecipe(publish, recipeID, uid, tags, writerId);
    }
    await db.collection('users').document(uid).delete();
  }

  static Future getUserDirectories(String uid) async {
    QuerySnapshot directories = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .getDocuments();
    return directories;
  }

  static Future getUserSavedRecipes(String uid) async {
    QuerySnapshot savedRecipes = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('saved recipe')
        .getDocuments();
    return savedRecipes;
  }

  static getUserRecipes(String uid) async {
    QuerySnapshot recipes = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('recipes')
        .getDocuments();
    return recipes;
  }

  static changeDirectoryName(String uid, String id, String newName) async {
    await db
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(id)
        .updateData({'name': newName});
  }

  static deleteDirectory(String uid, String directoryId) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(directoryId)
        .delete();
  }

  static Future<void> deleteFromDirectory(
      String uid, Directory d, int index) async {
    DocumentSnapshot directory = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(d.id)
        .get();

    Map<dynamic, dynamic> recipes = directory.data['Recipes'] ?? {};
    Map<dynamic, dynamic> copyRecipes = Map<dynamic, dynamic>.from(recipes);
    copyRecipes.remove(d.recipes[index].id);
    d.recipes.removeAt(index);
    await db
        .collection('users')
        .document(uid)
        .collection('Directory')
        .document(d.id)
        .updateData({'Recipes': copyRecipes});
  }

  static Future getUserTags(String uid) async {
    DocumentSnapshot snap =
        await Firestore.instance.collection("users").document(uid).get();
    Map<dynamic, dynamic> tagsCount = snap.data['tags'];
    return tagsCount;
  }
}
