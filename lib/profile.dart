import 'dart:convert';
//import 'dart:html';
import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recycle/additem.dart';
import 'package:recycle/item.dart';
import 'package:recycle/loginpage.dart';
import 'package:recycle/payment.dart';
import 'package:recycle/registrationscreen.dart';
import 'package:recycle/splashscreen.dart';
import 'package:recycle/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'package:recycle/constants.dart';
import 'package:recycle/widgets/profile_list_item.dart';

String urlgetuser = "0"; //"http://itschizo.com/emily_siew/myETrash/php/get_user.php";
String urluploadImage = "0";
    //"http://itschizo.com/emily_siew/myETrash/php/upload_imageprofile.php";
String urlupdate = '0';
    //"http://itschizo.com/emily_siew/myETrash/php/update_profile.php";
//File _image;
int number = 0;
String _value;



//import '../bloc.navigation_bloc/navigation_bloc.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key key, @required this.user}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
  

  
}

class _ProfileState extends State<ProfilePage> {
  GlobalKey<RefreshIndicatorState> refreshKey;

  List itemlist;
  double screenHeight, screenWidth;
  String titlecenter = "Loading...";
  bool visible = false;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "Searching current location...";

  

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
        return SafeArea(child: Scaffold(appBar: AppBar(centerTitle: true,
        title: Text('PROFILE PAGE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),),
        backgroundColor: Colors.teal[200],),
    /*return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomPadding: false,*/
          body: ListView.builder(
              //Step 6: Count the data
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Column(
                            children: <Widget>[
                              /*Center(
                                child: Text("MyETrash",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),*/
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                //onTap: _takePicture,
                                child: Container(
                                    width: 150.0,
                                    height: 150.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 5.0),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: new NetworkImage(
                                                "http://itschizo.com/emily_siew/myETrash/profile/${widget.user.email}.jpg")))),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  widget.user.name?.toUpperCase() ??
                                      'Not register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              Container(
                                child: Text(
                                  widget.user.email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              Container(height: 10),
                              Container(
                                child: Text(
                                  "Credit : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                              /*Container(
                                width: 350,
                                height: 200,
                                child: Card(
                                  color: Colors.white70,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(color: Colors.grey),
                                  ),
                                  elevation: 20,
                                  child: Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.phone_android,
                                            ),
                                            SizedBox(width: 10),
                                            Text(widget.user.phone ??
                                                'not registered'),
                                          ],
                                        ),
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.rate_review,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            /*RatingBar(
                                              itemCount: 5,
                                              itemSize: 12,
                                              initialRating: double.parse(widget
                                                      .user.rating
                                                      .toString() ??
                                                  0.0),
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),*/
                                          ],
                                        ),
                                        /*Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.credit_card,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text("You have " +
                                                      widget.user.credit +
                                                      " Credit" ??
                                                  "You have 0 Credit"),
                                            ),
                                          ],
                                        ),*/
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(_currentAddress),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),*/
                              SizedBox(
                                height: 25,
                              ),
                              /*Container(
                                color: Colors.grey,
                                child: Center(
                                  child: Text("My Profile ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),*/
                            ],
                          ),
                  
                  );
                }

                if (index == 1) {
                  return Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 450,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.blueGrey[50]),
                          child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.edit_outlined, color: Colors.teal[300]),
                            SizedBox(width: 20),
                            Text("Name",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:237),
                            new Container(
                             child: GestureDetector(
                            onTap: _changeName,
                            child: Icon(Icons.arrow_forward_ios),
                             ),

                            )
                          ],)
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          width: 450,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.blueGrey[50]),
                          child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.edit_outlined, color: Colors.teal[300]),
                            SizedBox(width: 20),
                            Text("Password",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:210),
                            new Container(
                             child: GestureDetector(
                            onTap: _changePassword,
                            child: Icon(Icons.arrow_forward_ios),
                             ),
                            )
                          ],)
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          width: 450,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.blueGrey[50]),
                          child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.edit_outlined, color: Colors.teal[300]),
                            SizedBox(width: 20),
                            Text("Phone",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:232),
                            new Container(
                             child: GestureDetector(
                            onTap: _changePhone,
                            child: Icon(Icons.arrow_forward_ios),
                             ),
                            )
                          ],)
                        ),
                        //SizedBox(height: 2.0),
                        /*Container(
                          width: 450,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.green[100]))),
                          child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.edit, color: Colors.green[900]),
                            SizedBox(width: 10),
                            Text("RADIUS",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:270),
                            new Container(
                             child: GestureDetector(
                            onTap: _changeRadius,
                            child: Icon(Icons.arrow_forward_ios),
                             ),
                            )
                          ],)
                        ),*/
                        SizedBox(height: 12.0),
                        Container(
                          width: 450,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.blueGrey[50]),
                          child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.add_outlined, color: Colors.teal[300]),
                            SizedBox(width: 20),
                            Text("Credit",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:235),
                            new Container(
                             child: GestureDetector(
                            onTap: _loadPayment,
                            child: Icon(Icons.arrow_forward_ios),
                             ),
                            )
                          ],)
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          width: 450,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.blueGrey[50]),
                          child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.person_add_outlined, color: Colors.teal[300]),
                            SizedBox(width: 20),
                            Text("Register",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:220),
                            new Container(
                             child: GestureDetector(
                            onTap: _registerAccount,
                            child: Icon(Icons.arrow_forward_ios),
                             ),
                            )
                          ],)
                        ),
                        SizedBox(height: 12.0),
                        Container(
                          width: 450,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.blueGrey[50]),
                          child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.lock_outline, color: Colors.teal[300]),
                            SizedBox(width: 20),
                            Text("Log In",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:235),
                            new Container(
                             child: GestureDetector(
                            onTap: _gotologinPage,
                            child: Icon(Icons.arrow_forward_ios),
                             ),
                            )
                          ],)
                        ),
                        SizedBox(height: 12.0),
                        Container(
                            width: 450,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.blueGrey[50]),
                            child: new Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width:20),
                            Icon(Icons.lock_open, color: Colors.teal[300]),
                            SizedBox(width: 20),
                            Text("Log Out",style: TextStyle(fontSize: 15.0,)),
                            SizedBox(width:222),
                            new Container(
                             child: GestureDetector(
                            onTap: _gotologout,
                            child: Icon(Icons.arrow_forward_ios),
                             ),
                            )
                          ],)),
                      ],
                    ),
                  );
                }
              }),
        ));

  }

  /*void _takePicture() async {
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Take new profile picture?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                String base64Image = base64Encode(_image.readAsBytesSync());
                http.post(urluploadImage, body: {
                  "encoded_string": base64Image,
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    setState(() {
                      number = new Random().nextInt(100);
                      print(number);
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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
  }*/

  _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name},${place.locality}, ${place.postalCode}, ${place.country}";
        //load data from database into list array 'data'
      });
    } catch (e) {
      print(e);
    }
  }


  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');
    await prefs.setString('pass', '');
    print("LOGOUT");
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _changeName() {
    TextEditingController nameController = TextEditingController();
    // flutter defined function

    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change name for " + widget.user.name + "?"),
          content: new TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (nameController.text.length < 5) {
                  Toast.show(
                      "Name should be more than 5 characters long", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "name": nameController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                    });
                    Toast.show("Success", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();
                    return;
                  } else {}
                }).catchError((err) {
                  print(err);
                });
                Toast.show("Failed", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

  void _changePassword() {
    TextEditingController passController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change Password for " + widget.user.name),
          content: new TextField(
            controller: passController,
            decoration: InputDecoration(
              labelText: 'New Password',
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (passController.text.length < 5) {
                  Toast.show("Password too short", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "password": passController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    print('in success');
                    setState(() {
                      widget.user.name = dres[1];
                      if (dres[0] == "success") {
                        Toast.show("Success", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        savepref(passController.text);
                        Navigator.of(context).pop();
                      }
                    });
                  } else {}
                }).catchError((err) {
                  print(err);
                });
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

  void _changePhone() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    if (widget.user.name == "not register") {
      Toast.show("Not allowed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Change phone for " + widget.user.name),
          content: new TextField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'phone',
                icon: Icon(Icons.phone),
              )),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                if (phoneController.text.length < 5) {
                  Toast.show("Please enter correct phone number", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                }
                http.post(urlupdate, body: {
                  "email": widget.user.email,
                  "phone": phoneController.text,
                }).then((res) {
                  var string = res.body;
                  List dres = string.split(",");
                  if (dres[0] == "success") {
                    setState(() {
                      widget.user.phone = dres[3];
                      Toast.show("Success ", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      Navigator.of(context).pop();
                      return;
                    });
                  }
                }).catchError((err) {
                  print(err);
                });
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

  void _registerAccount() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Register new account?"),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterScreen()));
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

  void _gotologinPage() {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Go to login page?" + widget.user.name),
          content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
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

  void _gotologout() async {
    // flutter defined function
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure you want to log out? " + widget.user.name),
          //content: new Text("Are your sure?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                print("LOGOUT");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp()));
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

  void savepref(String pass) async {
    print('Inside savepref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pass', pass);
  }

  void _loadPayment() async {
    // flutter defined function
    if (widget.user.name == "not register") {
      Toast.show("Not allowed please register", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Buy Credit?"),
          content: Container(
            height: 100,
            child: DropdownExample(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                var now = new DateTime.now();
                var formatter = new DateFormat('ddMMyyyyhhmmss-');
                String formatted =
                    formatter.format(now); // + randomAlphaNumeric(10);
                print(formatted);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                            user: widget.user,
                            orderid: formatted,
                            val: _value)));
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
}

class DropdownExample extends StatefulWidget {
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            child: Text('50 HCredit (RM10)'),
            value: '10',
          ),
          DropdownMenuItem<String>(
            child: Text('100 HCredit (RM20)'),
            value: '20',
          ),
          DropdownMenuItem<String>(
            child: Text('150 HCredit (RM30)'),
            value: '30',
          ),
        ],
        onChanged: (String value) {
          setState(() {
            _value = value;
          });
        },
        hint: Text('Select Credit'),
        value: _value,
      ),
    );
  }
    



}