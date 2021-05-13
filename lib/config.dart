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
Color appBarBackgroundColor = Colors.blueGrey[700];
Color titleColor = Colors.blueGrey[800];
Color borderColor = Colors.blueGrey;
Color mainButtonColor = Colors.blueGrey[500];
Color subButtonColor = Colors.blueGrey[300];
Color errorColor = Colors.red;

// collections names
String usersCollectionName = 'users';
String publishCollectionName = 'publish recipe';

// widgets
Padding padding = new Padding(padding: EdgeInsets.only(top: 15.0));

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
