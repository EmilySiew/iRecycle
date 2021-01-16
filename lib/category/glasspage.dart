import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';

class GlassPage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Glass",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}