// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:recipes_app/shared_screen/loading.dart';

// class PublishGroup extends StatefulWidget {
//   PublishGroup(String _uid, String _recipeId) {
//     this.uid = _uid;
//     this.recipeId = _recipeId;
//   }
//   String uid;
//   String recipeId;
//   List<String> groupName = [];
//   List<String> groupName2 = [];
//   List<String> groupId = [];
//   List<bool> isCheck = [];
//   List<String> publish = [];
//   bool doneLoad = false;
//   bool _isChaked = false;
//   @override
//   _PublishGroupState createState() => _PublishGroupState();
// }

// class _PublishGroupState extends State<PublishGroup> {
//   void convertToCheck() {
//     widget.groupName2 = widget.groupName;
//     print("convert to shack");
//     for (int i = 0; i < widget.publish.length; i++) {
//       for (int j = 0; j < widget.groupName.length; j++) {
//         //   print(widget.groupName[j]);
//         //   print(widget.publish[i]);
//         if (widget.groupName[j] == widget.publish[i]) {
//           setState(() {
//             //    print("convert");
//             //   print(j);
//             widget.isCheck[j] = !widget.isCheck[j];
//           });
//         }
//       }
//     }
//     print("check list");
//     print(widget.isCheck);
//   }

//   Future<void> getGroups() async {
//     // print(getGroups());
//     QuerySnapshot snap = await Firestore.instance
//         .collection('users')
//         .document(widget.uid)
//         .collection('groups')
//         .getDocuments();
//     snap.documents.forEach((element) async {
//       setState(() {
//         widget.groupId.add(element.data['groupId']);
//         widget.groupName.add(element.data['groupName']);
//         widget.isCheck.add(false);
//       });

//       //  print("b");
//       // print(widget.groupName);

//       QuerySnapshot snap2 = await Firestore.instance
//           .collection('Group')
//           .document(element.data['groupId'])
//           .collection('recipes')
//           .getDocuments();
//       //    print(element.data['groupId']);
//       //  print(snap2.documents.length);
//       if (snap2.documents.length != 0) {
//         snap2.documents.forEach((element2) async {
//           if (element2.data['recipeId'] == widget.recipeId) {
//             //  print('sucses');
//             setState(() {
//               widget.publish.add(element.data['groupName']);
//             });
//             //widget.publish.add(element.data['groupName']);
//           }
//         });
//       }
//     });

//     setState(() {
//       //convert();
//       widget.doneLoad = true;
//       // convertToCheck();
//     });
//     // convertToCheck();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!widget.doneLoad) {
//       getGroups();
//       //convert();
//       return Loading();
//     } else {
//       //  print(widget.groupName.length);
//       //  print(widget.publish);
//       // return Text("A");
//       convertToCheck();
//       return ListView.builder(
//           itemCount: widget.groupName.length,
//           itemBuilder: (context, index) {
//             return

//                 //padding: EdgeInsets.all(8.0),

//                 CheckboxListTile(
//               title: Text(widget.groupName[index]),
//               value: widget.isCheck[index],
//               onChanged: (val) {
//                 print("noa       " + widget.groupName[index]);
//                 print(widget.isCheck);
//                 if (val) {
//                   //       print("push");
//                   //      print(val);
//                   publishInGroup(index);
//                 } else {
//                   unPublishGroup(index);
//                 }
//                 setState(() {
//                   widget.isCheck[index] = val;
//                 });

//                 //  print(val);
//               },
//             );
//           });
//     }
//   }

//   void publishInGroup(int index) async {
//     final db = Firestore.instance;
//     var currentRecipe = await db
//         .collection('Group')
//         .document(widget.groupId[index])
//         .collection('recipes')
//         .add({'userId': widget.uid, 'recipeId': widget.recipeId});
//   }

//   Future<void> unPublishGroup(int index) async {
//     final db = Firestore.instance;

//     QuerySnapshot snap = await Firestore.instance
//         .collection('Group')
//         .document(widget.groupId[index])
//         .collection('recipes')
//         .getDocuments();
//     snap.documents.forEach((element) async {
//       if (element.data['recipeId'] == widget.recipeId) {
//         db
//             .collection('Group')
//             .document(widget.groupId[index])
//             .collection('recipes')
//             .document(element.documentID)
//             .delete();
//       }
//     });
//   }
// }
