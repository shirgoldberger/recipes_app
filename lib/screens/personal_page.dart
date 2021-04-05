// import 'package:flutter/material.dart';
// import 'package:recipes_app/screens/book_page.dart';

// class PersonalPage extends StatelessWidget {
//   static String tag = 'home-page';
//   static const TextStyle optionStyle = TextStyle(
//       fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey);
//   @override
//   Widget build(BuildContext context) {
//     final title = Title(
//       color: Colors.lightBlue[600],
//       child: Text(
//         "Hello! Choose What You Want To Do:",
//         style: optionStyle,
//       ),
//     );

//     final recipesBookButton = ButtonTheme(
//       minWidth: 600.0,
//       child: RaisedButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => RecipesBookPage()),
//           );
//         },
//         color: Colors.lightBlueAccent,
//         child: Text('My Recipes Book', style: TextStyle(color: Colors.white)),
//       ),
//     );

//     final seetingsButton = ButtonTheme(
//       minWidth: 600.0,
//       child: RaisedButton(
//         onPressed: null,
//         color: Colors.lightBlueAccent,
//         child: Text('Settings', style: TextStyle(color: Colors.white)),
//       ),
//     );

//     final addRecipeButton = ButtonTheme(
//       minWidth: 600.0,
//       child: RaisedButton(
//         onPressed: null,
//         color: Colors.lightBlueAccent,
//         child: Text('Add New Recipe', style: TextStyle(color: Colors.white)),
//       ),
//     );

//     final body = Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 100.0),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(colors: [
//           Colors.lightBlue[50],
//           Colors.lightBlue[50],
//         ]),
//       ),
//       child: Column(
//         children: <Widget>[
//           title,
//           SizedBox(height: 30),
//           recipesBookButton,
//           SizedBox(height: 7),
//           seetingsButton,
//           SizedBox(height: 7),
//           addRecipeButton
//         ],
//       ),
//     );

//     return Scaffold(
//       body: body,
//     );
//   }
// }
