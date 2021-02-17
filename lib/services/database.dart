import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_app/models/user.dart';
import 'package:recipes_app/models/userInformation.dart';

class DataBaseService {
  final String uid;
  DataBaseService({this.uid});
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
}
