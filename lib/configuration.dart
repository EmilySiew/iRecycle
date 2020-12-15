import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];

List<Map> categories = [
  {'name': ' Paper', 'iconPath': 'assets/images/paper.PNG'},
  {'name': ' Glass', 'iconPath': 'assets/images/glass.PNG'},
  {'name': ' Metal', 'iconPath': 'assets/images/metal.PNG'},
  {'name': ' Plastic', 'iconPath': 'assets/images/plastic.PNG'},
  {'name': ' Electronics', 'iconPath': 'assets/images/electronics.PNG'}
];

List<Map> drawerItems=[
  {
    'icon': FontAwesomeIcons.recycle,
    'title' : 'Recycle'
  },
  {
    'icon': Icons.mail,
    'title' : 'Collect'
  },
  {
    'icon': FontAwesomeIcons.userAlt,
    'title' : 'Profile'
  },
];