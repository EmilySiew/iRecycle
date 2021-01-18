import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'user.dart';
import 'package:flutter/cupertino.dart';
import 'sidebar/sidebar_layout.dart';

class MainScreen extends StatelessWidget {
  final User user;

  const MainScreen({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, primaryColor: Colors.white),
      home: SideBarLayout(user: user),
    );
  }
}
