import 'package:flutter/material.dart';

// paths
String noImagePath = 'lib/images/no_image.jpg';
String chefImagePath = 'lib/images/chef.png';
String yourGroupsPath = 'lib/images/your_groups.png';
String createGroupPath = 'lib/images/create_group.png';
String galleryPath = 'lib/images/gallery.png';
String cameraPath = 'lib/images/camera.png';
String uploadImagePath = 'lib/images/upload_image.png';

// colors
Color backgroundColor = Colors.blueGrey[50];
Color appBarBackgroundColor = Colors.blueGrey[900];
Color titleColor = Colors.blueGrey[800];
Color borderColor = Colors.blueGrey;
Color mainButtonColor = Colors.blueGrey[500];
Color subButtonColor = Colors.blueGrey[300];
Color errorColor = Colors.red;
Color appBarTextColor = Colors.grey[700];

// collections names
String usersCollectionName = 'users';
String publishCollectionName = 'publish recipe';

// widgets
Padding padding = new Padding(padding: EdgeInsets.only(top: 15.0));

Widget loadingIndicator() {
  return Container(
      padding: EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.8),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getLoadingIndicator(),
            _getHeading(),
          ]));
}

Widget _getLoadingIndicator() {
  return Padding(
      child: Container(
          child: CircularProgressIndicator(strokeWidth: 3),
          width: 32,
          height: 32),
      padding: EdgeInsets.only(bottom: 16));
}

Widget _getHeading() {
  return Padding(
      child: Text(
        'Loading …',
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      padding: EdgeInsets.only(bottom: 4));
}

Widget box = SizedBox(
  height: 20.0,
);

Widget heightBox(double _height) {
  return SizedBox(
    height: _height,
  );
}

Widget widthBox(double _width) {
  return SizedBox(
    width: _width,
  );
}

// names
String appName = 'Cook Book';
List tagList = [
  'choose recipe tag',
  'fish',
  'meat',
  'dairy',
  'desert',
  'for children',
  'other',
  'vegetarian',
  'Gluten free',
  'without sugar',
  'vegan',
  'Without milk',
  'No eggs',
  'kosher',
  'baking',
  'cakes and cookies',
  'Food toppings',
  'Salads',
  'Soups',
  'Pasta',
  'No carbs',
  'Spreads',
];

// fonts
String ralewayFont = 'Raleway';
String logoFont = 'LogoFont';

// errors messages
String errorInvalidEmail =
    'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null, null)';
String errorEmailAlreadyInUse =
    'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)';
String errorNetworkRequestFaild =
    'PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null, null)';
String errorHasNoUser =
    'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null, null)';
String errorPassword =
    'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null, null)';

Future<void> showAlertDialogError(String error, BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(error),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
