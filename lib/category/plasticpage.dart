import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:recycle/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:recycle/additem.dart';
import 'package:recycle/item.dart';
import 'package:recycle/itemscreen.dart';

class PlasticPage extends StatefulWidget {
  final User user;
  const PlasticPage({Key key, this.user}):super(key:key);

  @override
  _PlasticPageState createState() => _PlasticPageState();
}

class _PlasticPageState extends State<PlasticPage>{
  GlobalKey<RefreshIndicatorState> refreshKey;

  List itemlist;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Item..";
  bool visible = false;

  @override
  void initState() {
    super.initState();
    _loadPlastic();
  }

  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //TextEditingController _itemnamecontroller = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Category : Plastic',
              style: TextStyle(fontSize: 20)),
          backgroundColor: Colors.teal[200],
          actions: <Widget>[
            Flexible(
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.white, size: 30),
                onPressed: () {
                  _addItemScreen();
                },
              ),
            ),
          ],
        ),
        body: Column(children: [
          itemlist == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ))))
              : Flexible(
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(itemlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                          shape: Border(
                          right: BorderSide(color: Colors.green[200], width:5),
                          bottom: BorderSide(color: Colors.green[200], width: 1)
                        ),
                            color: Colors.grey[200],
                            child: InkWell(
                              onTap: () => _loadItemDetail(index),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                              //child: SingleChildScrollView(
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  //children: [
                                    //SizedBox(height: 3),
                                    //Stack(
                                      children: <Widget>[
                                        Container(
                                          /*height: 150,
                                            width: 150,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://techvestigate.com/irecycle/images/${itemlist[index]['image']}.jpg",
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  new CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(
                                                Icons.broken_image,
                                                size: screenWidth / 2,
                                              ),
                                            )*/
                                          height:150,
                                          width:150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(color: Colors.black,width: 1),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                "https://techvestigate.com/irecycle/images/${itemlist[index]['image']}.jpg",
                                              )
                                            )
                                            )
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisSize:MainAxisSize.min,
                                                children: <Widget>[
                                                  
                                                  Text(
                                                    itemlist[index]['itemname'],
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.indigo[900]),
                                                  ),
                                                  Text(
                                                    "Category : " +
                                                    itemlist[index]['category'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.indigo[800]),
                                                  ),
                                                  Text(
                                                    "Weight : " +
                                                        itemlist[index]['weight'] +
                                                        "kg",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.indigo[700]),
                                                  ),
                                                  Text(itemlist[index]['date']),

                                                ]
                                              ))
                                    ),
                                    
                                    /*Text(
                                      itemlist[index]['itemname'],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[900]),
                                    ),
                                    Text(
                                      "Weight : " +
                                          itemlist[index]['weight'] +
                                          "kg",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.indigo[800]),
                                    ),*/
                                  ],
                                ),
                              ),
                            )));
                  }),
                ))
        ]),
      ),
    );
  }

  Future<void> _loadPlastic() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    http.post("https://techvestigate.com/irecycle/php/loaditem.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        itemlist = null;
        setState(() {
          titlecenter = "No Item Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          itemlist = jsondata["item"];
          itemlist.removeWhere((element) => element['category'] != "Plastic");
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _addItemScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddItemPage(
                  user: widget.user,
                )));
  }

  _loadItemDetail(int index) {
    print(itemlist[index]['itemname']);
    Item item = new Item(
        itemid: itemlist[index]['itemid'],
        category: itemlist[index]['category'],
        itemname: itemlist[index]['itemname'],
        weight: itemlist[index]['weight'],
        image: itemlist[index]['image'],
        date: itemlist[index]['date'],
        itemworker: itemlist[index][null]);
        
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ItemScreen(
                  item: item,
                  user: widget.user,
                )));
  }





}