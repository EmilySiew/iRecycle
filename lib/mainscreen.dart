  
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'user.dart';
import 'drawerScreen.dart';
import 'homeScreen.dart';

class MainScreen extends StatelessWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          HomeScreen()

        ],
      ),
    );
  }
}
