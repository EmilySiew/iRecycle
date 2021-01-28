import 'package:flutter/material.dart';
import 'package:recycle/user.dart';
import 'package:recycle/item.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recycle/mainscreen.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItemScreen extends StatefulWidget {
  final User user;
  final Item item;

  const ItemScreen({Key key, @required this.user, @required this.item})
      : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
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
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pop(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: widget.user,
          ),
        ));
    return Future.value(false);
  }
}

class DetailInterface extends StatefulWidget {
  final Item item;
  final User user;
  DetailInterface({this.item, this.user});

  @override
  _DetailInterfaceState createState() => _DetailInterfaceState();
}

class _DetailInterfaceState extends State<DetailInterface> {
  //Completer<GoogleMapController> _controller = Completer();
  //CameraPosition _myLocation;

  @override
  /*void initState() {
    super.initState();
    _myLocation = CameraPosition(
      target: LatLng(
          double.parse(widget.item.etlat), double.parse(widget.item.etlon)),
      zoom: 17,
    );
    print(_myLocation.toString());
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          width: 280,
          height: 200,
          child: Image.network(
              "https://techvestigate.com/irecycle/images/${widget.item.image}.jpg",
              fit: BoxFit.fill),
        ),
        SizedBox(
          height: 10,
        ),
        Text(widget.item.itemname.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text(widget.item.date),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              Table(children: [
                TableRow(children: [
                  Text("Item Category : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.item.category),
                ]),
                TableRow(children: [
                  Text("Item Weight : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.item.weight + "kg"),
                ]),
                TableRow(children: [
                  Text("Location : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.item.location),
                ]),
                TableRow(children: [
                  Text("Owner : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.user.name),
                ]),
                TableRow(children: [
                  Text("Phone : ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.user.phone),
                ]),
              ]),
              SizedBox(
                height: 10,
              ),
              /*Container(
                
                height: 120,
                width: 340,
                child: GoogleMap(
                  // 2
                  initialCameraPosition: _myLocation,
                  // 3
                  mapType: MapType.normal,
                  // 4
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),*/
              SizedBox(height: 100),
              Container(
                alignment: Alignment.center,
                width: 350,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  height: 50,
                  child: Text(
                    'COLLECT ITEM',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.teal,
                  textColor: Colors.white,
                  elevation: 5,
                  onPressed: _onAcceptItem,
                ),
                //MapSample(),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _onAcceptItem() {
    _showDialog();
    print("RECYCLE ITEM");
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Accept " + widget.item.itemname),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                acceptRequest();
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

  Future<String> acceptRequest() async {
    String urlLoadItems =
        "https://techvestigate.com/irecycle/php/acceptitem.php";
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Accepting Recycle Item");
    await pr.show();
    http.post(urlLoadItems, body: {
      "itemid": widget.item.itemid,
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //pr.hide();
        _onLogin(widget.user.email, context);
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        //pr.hide();
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    await pr.hide();
    return null;
  }

  void _onLogin(String email, BuildContext ctx) {
    String urlgetuser =
        "https://techvestigate.com/irecycle/php/getuser.php";

    http.post(urlgetuser, body: {
      "email": email,
    }).then((res) {
      print(res.statusCode);
      var string = res.body;
      List dres = string.split(",");
      print(dres);
      if (dres[0] == "success") {
        User user = new User(name: dres[1], email: dres[2], phone: dres[3]);
        Navigator.push(ctx,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      }
    }).catchError((err) {
      print(err);
    });
  }
}

