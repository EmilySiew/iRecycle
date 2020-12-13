import 'package:flutter/material.dart';



class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hello',
      home: Scaffold(
        body: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}