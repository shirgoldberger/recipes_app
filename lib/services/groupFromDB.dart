import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/services/recipeFromDB.dart';
import 'package:recipes_app/services/userFromDB.dart';

import '../shared_screen/config.dart';

class GroupFromDB {
  static final db = Firestore.instance;

  static insertUserToGroup(String groupId, String groupName, String uid) async {
    await db.collection('Group').document(groupId).updateData({'users': uid});
    await db
        .collection('users')
        .document(uid)
        .collection('groups')
        .add({'groupName': groupName, 'groupId': groupId});
  }

  static Future<List> getUsersGroup(String groupId) async {
    DocumentSnapshot snap2 =
        await Firestore.instance.collection('Group').document(groupId).get();
    return snap2.data['users'] ?? [];
  }

  static Future<QuerySnapshot> getRecipesGroupSnapshot(String groupId) async {
    return await db
        .collection('Group')
        .document(groupId)
        .collection('recipes')
        .getDocuments();
  }

  static Future<List<Recipe>> getGroupRecipes(String groupId) async {
    QuerySnapshot recipes = await db
        .collection('Group')
        .document(groupId)
        .collection('recipes')
        .getDocuments();
    List<Recipe> recipesList = [];
    for (int i = 0; i < recipes.documents.length; i++) {
      DocumentSnapshot recipeSnapshot = recipes.documents[i];
      String uid = await UserFromDB.getUserIdFromElement(recipeSnapshot);
      String recipeId =
          await RecipeFromDB.getRecipeIdFromElement(recipeSnapshot);
      DocumentSnapshot recipeSnapshotFromUser = await db
          .collection('users')
          .document(uid)
          .collection('recipes')
          .document(recipeId)
          .get();
      Recipe recipe =
          RecipeFromDB.convertSnapshotToRecipe(recipeSnapshotFromUser);
      recipesList.add(recipe);
    }
    return recipesList;
  }

  static Future<void> deleteUserFromGroup(String uid, String groupId) async {
    DocumentSnapshot group =
        await Firestore.instance.collection('Group').document(groupId).get();
    List usersList = [];
    List users = group.data['users'] ?? '';
    usersList.addAll(users);
    usersList.remove(uid);
    // update users - delete user from group
    db.collection('Group').document(groupId).updateData({'users': usersList});

    // delete group if no user there
    if (usersList.length == 0) {
      QuerySnapshot recipeInGroup = await Firestore.instance
          .collection('Group')
          .document(groupId)
          .collection('recipes')
          .getDocuments();
      for (int i = 0; i < recipeInGroup.documents.length; i++) {
        db
            .collection('Group')
            .document(groupId)
            .collection('recipes')
            .document(recipeInGroup.documents[i].documentID)
            .delete();
      }
      db.collection('Group').document(groupId).delete();
    }

    // get user groups
    QuerySnapshot user = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('groups')
        .getDocuments();

    for (int i = 0; i < user.documents.length; i++) {
      if (user.documents[i].data['groupId'] == groupId) {
        // delete group from user
        db
            .collection('users')
            .document(uid)
            .collection('groups')
            .document(user.documents[i].documentID)
            .delete();
      }
    }
  }

  static Future<void> updateGroupName(
      String groupId, String newName, List<String> membersIds) async {
    // update name in group
    db.collection('Group').document(groupId).updateData({'groupName': newName});
    // update name in group's members
    for (int i = 0; i < membersIds.length; i++) {
      // take all groups of the user
      QuerySnapshot userGroups = await Firestore.instance
          .collection('users')
          .document(membersIds[i])
          .collection('groups')
          .getDocuments();
      for (int j = 0; j < userGroups.documents.length; i++) {
        if (userGroups.documents[j].data['groupId'] == groupId) {
          // update name of the specific group
          db
              .collection('users')
              .document(membersIds[i])
              .collection('groups')
              .document(userGroups.documents[j].documentID)
              .updateData({'groupName': newName});
        }
      }
    }
  }

  static Future<void> createNewGroup(
      String groupName, List<String> usersID) async {
    var newGroup = await db
        .collection('Group')
        .add({'groupName': groupName, 'users': usersID});
    String id = newGroup.documentID.toString();
    for (int i = 0; i < usersID.length; i++) {
      await db
          .collection('users')
          .document(usersID[i])
          .collection('groups')
          .add({'groupName': groupName, 'groupId': id});
    }
  }

  static Future<void> deleteUserFromAllGroups(String uid) async {
    QuerySnapshot groups = await db.collection('Group').getDocuments();
    for (int i = 0; i < groups.documents.length; i++) {
      List users = groups.documents[i].data["users"];
      if (users.contains(uid)) {
        await deleteUserFromGroup(uid, groups.documents[i].documentID);
      }
    }
  }
}
