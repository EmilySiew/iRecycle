import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:recycle/user.dart';
import 'package:recycle/category/paperpage.dart';
import 'package:recycle/category/metalpage.dart';
import 'package:recycle/category/plasticpage.dart';
import 'package:recycle/category/glasspage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget with NavigationStates {
  final User user;
  const HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List itemList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Category...";
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    //screenHeight = MediaQuery.of(context).size.height;
    //screenWidth = MediaQuery.of(context).size.width;
    //TextEditingController _itemnamecontroller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Recycle Category',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
        backgroundColor: Colors.teal[200],
      ),
      body: GridView(
        padding: EdgeInsets.only(left: 15, right: 5, bottom: 30, top: 100),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        children: <Widget>[
          GestureDetector(
              child: Container(
                child: Image.asset('assets/images/paper.gif'),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PaperPage(
                              //item: item,
                              user: widget.user,
                            )));
                //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyPaperClickedEvent);
              }),
              //Container(child: Text('Paper'),),
          GestureDetector(
              child: Container(
                child: Image.asset('assets/images/metal.gif'),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MetalPage(
                              //item: item,
                              user: widget.user,
                            )));
                //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyMetalClickedEvent);
              }),
          GestureDetector(
              child: Container(
                child: Image.asset('assets/images/plastic.gif'),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => PlasticPage(
                              //item: item,
                              user: widget.user,
                            )));
                //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyPlasticClickedEvent);
              }),
          GestureDetector(
              child: Container(
                child: Image.asset('assets/images/glass.gif'),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => GlassPage(
                              //item: item,
                              user: widget.user,
                            )));
                //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyGlassClickedEvent);
              }),
        ],
      ),
    );
  }
}
