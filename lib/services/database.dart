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

//userInfo from a snapshot
  List<UserInformation> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserInformation(
          firstName: doc.data['firstName'] ?? '',
          lastName: doc.data['lastName'] ?? '',
          email: doc.data['email'] ?? '',
          age: doc.data['age'] ?? 0,
          phone: doc.data['phone'] ?? '');
    }).toList();
  }

  //user data from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        firstName: snapshot.data['firstName'],
        lastName: snapshot.data['lastName'],
        email: snapshot.data['email'],
        age: snapshot.data['age'],
        phone: snapshot.data['phone']);
  }

//get user stream
  Stream<List<UserInformation>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
