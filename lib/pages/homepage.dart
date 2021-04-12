import 'package:flutter/material.dart';
import 'package:recycle/category/itempage.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:recycle/user.dart';
import 'package:recycle/category/paperpage.dart';
import 'package:recycle/category/metalpage.dart';
import 'package:recycle/category/plasticpage.dart';
import 'package:recycle/category/glasspage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class HomePage extends StatefulWidget with NavigationStates {
  final User user;
  const HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List itemList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Items";
  bool visible = false;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //screenHeight = MediaQuery.of(context).size.height;
    //screenWidth = MediaQuery.of(context).size.width;
    //TextEditingController _itemnamecontroller = TextEditingController();

    return Scaffold(
        appBar: GradientAppBar(
          centerTitle: true,
          title: Text('Categories',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
              gradient: LinearGradient(colors: [Colors.white,Colors.blueGrey]),

          //backgroundColor: Colors.teal[200],
          bottom: TabBar(
            unselectedLabelColor: Colors.black38,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              border: Border.all(color: Colors.teal),
            
                color: Colors.blueGrey[50],
                
                borderRadius: BorderRadius.circular(50)),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  ),
                child: Align(
                  alignment: Alignment.center, 
                  child: Text ('All'),),),),
              Tab(text: 'Paper'),
              Tab(text: 'Metal'),
              Tab(text: 'Plastic'),
              Tab(text: 'Glass'),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          ItemPage(user: widget.user),
          PaperPage(user: widget.user),
          MetalPage(user: widget.user),
          PlasticPage(user: widget.user),
          GlassPage(user: widget.user),
        ])

        /*body: GridView(
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
      ),*/
        //   ],
        // )

        );
  }
}
