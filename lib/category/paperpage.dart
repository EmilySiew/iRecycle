import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';

class PaperPage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Paper",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}