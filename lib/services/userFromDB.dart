import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_html/html.dart';

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
    await db.collection('users').document(uid).delete();
  }
}