import 'package:flutter/material.dart';
import 'package:recycle/user.dart';

class AddItemPage extends StatelessWidget {
  final User user;
  const AddItemPage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "My Accounts",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}
