import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
//import '../item.dart';
//import '../main.dart';
import '../user.dart';
import 'package:http/http.dart' as http;

class CollectItemPage extends StatefulWidget with NavigationStates {
  final User user;

  const CollectItemPage({Key key, @required this.user}) : super(key: key);

  @override
  _CollectItemPageState createState() => _CollectItemPageState();
}

class _CollectItemPageState extends State<CollectItemPage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List itemlist;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Collected Item...";
  bool visible = false;

  @override
  void initState() {
    super.initState();
    _loadCollectedItem();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          centerTitle: true,
          title: Text('Collected Item',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
          //backgroundColor: Colors.blueGrey[200],
          gradient: LinearGradient(colors: [Colors.white,Colors.blueGrey]
        ),),
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
                        _loadCollectedItem();
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
                                          color: Colors.green[200], width: 3),
                                      bottom: BorderSide(
                                          color: Colors.green[200], width: 1)),
                                  color: Colors.grey[200],
                                  child: InkWell(
                                    onLongPress: () => _onCancelItem(
                                        itemlist[index]['itemid'].toString(),
                                        itemlist[index]['itemname'].toString()),
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
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  //border: Border.all(color: Colors.black,width: 1),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                        "https://techvestigate.com/irecycle/images/${itemlist[index]['image']}.jpg",
                                                      )))),
                                          Expanded(
                                              child: SingleChildScrollView(
                                                  child: Container(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            SizedBox(height: 15,),
                                                Text(
                                                  itemlist[index]['itemname'],
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                /*Text(
                                                    "Category : " +
                                                    itemlist[index]['category'],
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87),
                                                  ),*/
                                                Text(
                                                  "Weight : " +
                                                      itemlist[index]
                                                          ['weight'] +
                                                      "kg",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87),
                                                ),
                                                Text(
                                                  "Owner : " +
                                                      itemlist[index]
                                                          ['ownername'],
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                                Text(
                                                  "Contact No : " +
                                                      itemlist[index]['phone'],
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                ),
                                                SizedBox(height: 10,),
                                                Text("----------------------------------------------------------"),
                                                Text("Location : " +
                                                    itemlist[index]
                                                        ['location']),
                                                        Text("----------------------------------------------------------"),
                                              ])))),

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
                      )))
        ]),
      ),
    );
  }

  Future<void> _loadCollectedItem() async {
    //String urlLoadItem = "https://techvestigate.com/irecycle/php/loadAcceptItem.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading Accepted Item...");
    await pr.show();

    http.post("https://techvestigate.com/irecycle/php/loadAcceptItem.php",
        body: {
          "email": widget.user.email ?? "not available",
        }).then((res) {
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
          //itemlist.removeWhere((element) => element['itemworker'] != widget.user.email);
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onCancelItem(String itemid, String itemname) {
    print("Cancel " + itemid);
    _showDialog(itemid, itemname);
  }

  void _showDialog(String itemid, String itemname) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cancel " + itemname),
          content: new Text(
              "Are you sure you want to cancel selected accepted item?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                cancelItem(itemid);
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

  Future<String> cancelItem(String itemid) async {
    String urlLoadItems =
        "https://techvestigate.com/irecycle/php/cancelitem.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Canceling Item");
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
