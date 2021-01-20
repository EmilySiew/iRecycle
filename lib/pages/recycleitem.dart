import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recycle/additem.dart';
import 'package:recycle/item.dart';
import 'package:recycle/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';


import '../bloc.navigation_bloc/navigation_bloc.dart';

class RecycleItemPage extends StatefulWidget with NavigationStates {
  final User user;
  const RecycleItemPage({Key key, @required this.user}) : super(key: key);

  @override
  _RecycleItemState createState() => _RecycleItemState();
}

class _RecycleItemState extends State<RecycleItemPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List itemlist;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Recycle Item...";
  bool visible = false;

  @override
  void initState() {
    super.initState();
    _loadRecycleItem();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Recycle Item",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
        backgroundColor: Colors.teal[200],
        actions: <Widget>[
            Flexible(
              child: IconButton(
                icon: Icon(Icons.add, size: 35),
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
                child: RefreshIndicator(
                  key: refreshKey,
                  color: Colors.deepOrange,
                  onRefresh: () async {
                    _loadRecycleItem();
                  },
                  child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (screenWidth / screenHeight) / 0.2,
                  children: List.generate(itemlist.length, (index) {
                    return Padding(
                        padding: EdgeInsets.all(1),
                        child: Card(
                            shape: Border(
                                right: BorderSide(
                                    color: Colors.green[200], width: 5),
                                bottom: BorderSide(
                                    color: Colors.green[200], width: 1)),
                            color: Colors.grey[200],
                            child: InkWell(
                              onLongPress: () => _deleteItem(
                                itemlist[index]['itemid'].toString(),
                                itemlist[index]['itemname'].toString()
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                        height: 150,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  "https://techvestigate.com/irecycle/images/${itemlist[index]['image']}.jpg",
                                                )))),
                                    Expanded(
                                        child: Container(
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                        ]))),
                                  ],
                                ),
                              ),
                            )
                            ));
                  }),
                )))
        ]),
      ),
    );
  }
  Future<void> _loadRecycleItem() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Posted Recycle Item...");
    await pr.show();
    http.post("https://techvestigate.com/irecycle/php/loadRecycleitem.php",
        body: {
          "email": widget.user.email ?? "not available",
        }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        itemlist = null;
        setState(() {
          titlecenter = "There is no Recycle Item";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          itemlist = jsondata["item"];
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

  void _deleteItem(String itemid, String itemname) {
    print("Delete " + itemid);
    _showDialog(itemid, itemname);
  }

  void _showDialog(String itemid, String itemname) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete " + itemname),
          content: new Text("Are you sure you want to delete selected item?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteItem(itemid);
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> deleteItem(String itemid) async {
    String urlLoadItems = "https://techvestigate.com/irecycle/php/cancelitem.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting Item");
    await pr.show();
    http.post(urlLoadItems, body: {
      "itemid": itemid,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
           
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        
      }
    }).catchError((err) {
      print(err);
      
    });
    await pr.hide();
    return null;
  }




}