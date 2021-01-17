import 'package:flutter/material.dart';
import 'package:recycle/user.dart';
import 'package:recycle/item.dart';

class ItemScreen extends StatelessWidget {
  final User user;
  final Item item;

  const ItemScreen({Key key, this.user, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "ItemDetail",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}