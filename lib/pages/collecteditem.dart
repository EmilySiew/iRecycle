import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../user.dart';

class CollectItemPage extends StatefulWidget with NavigationStates {
  final User user;
  const CollectItemPage({Key key, @required this.user}) : super(key: key);

  @override
  _CollectItemPageState createState() => _CollectItemPageState();
} 

class _CollectItemPageState extends State<CollectItemPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List itemList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Category...";
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.teal));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text('ITEM DETAILS'),
            backgroundColor: Colors.teal[100],
          ),
          //body: SingleChildScrollView(
          body: Container(
            child: Container(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: DetailInterface(
                item: widget.item,
                user: widget.user,
              ),
            ),
          )),
    );*/
  }
}