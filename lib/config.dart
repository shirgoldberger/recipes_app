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

// widgets
Widget box = SizedBox(
  height: 20.0,
);

// names
String appName = 'Cook Book';

// errors messages
String errorInvalidEmail =
    'PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null, null)';
String errorEmailAlreadyInUse =
    'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null, null)';
