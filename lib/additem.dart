import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recycle/item.dart';
import 'package:recycle/user.dart';
import 'package:toast/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class AddItemPage extends StatefulWidget {
  final User user;
  final Item item;
  const AddItemPage({Key key, @required this.user, @required this.item})
      : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _itemnamecontroller = TextEditingController();
  final TextEditingController _itemweightcontroller = TextEditingController();
  final TextEditingController categoryFilterController =
      TextEditingController();

  String _itemname = "";
  String _itemweight = "";
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';
  String category;
  Completer<GoogleMapController> _controller = Completer();
  Position _currentPosition;
  CameraPosition _userpos;
  double latitude, longitude;
  String _homeloc = "searching...";
  Set<Marker> markers = Set();
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  GoogleMapController gmcontroller;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //var getLocation = _getLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recycle Item'),
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("** 5 Credits are required for each post **",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      child: Text(
                        '   Available Credit : ' + widget.user.credit + '   ',
                        style: TextStyle(
                            backgroundColor: Colors.blueGrey[100],
                            //fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                        onTap: () => {_onPictureSelection()},
                        child: Container(
                          height: screenHeight / 3.2,
                          width: screenWidth / 1.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _image == null
                                  ? AssetImage(pathAsset)
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                            border: Border.all(
                              width: 3.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //         <--- border radius here
                                ),
                          ),
                        )),
                    SizedBox(height: 5),
                    Text("Click image to take item picture",
                        style: TextStyle(fontSize: 10.0, color: Colors.black)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Category: ",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 15),
                        DropdownButton(
                          hint: Text(categoryFilterController.text),
                          icon: Icon(Icons.arrow_drop_down),
                          items: [
                            DropdownMenuItem(
                              child: Text("Paper"),
                              value: "Paper",
                            ),
                            DropdownMenuItem(
                              child: Text("Metal"),
                              value: "Metal",
                            ),
                            DropdownMenuItem(
                              child: Text("Plastic"),
                              value: "Plastic",
                            ),
                            DropdownMenuItem(
                              child: Text("Glass"),
                              value: "Glass",
                            )
                          ],
                          onChanged: (value) {
                            setState(() {
                              categoryFilterController.text = value;
                              category = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                        controller: _itemnamecontroller,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter item name',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 15),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                gapPadding: 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.teal),
                                gapPadding: 10),
                            icon: Icon(Icons.title_outlined))),
                            SizedBox(height: 20),
                    TextField(
                        controller: _itemweightcontroller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Weight (kg)',
                            hintText: 'Enter item weight (kg)',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 42, vertical: 15),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                gapPadding: 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.teal),
                                gapPadding: 10),
                            icon: Icon(Icons.line_weight_outlined))),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                        onTap: () => {_loadmap()},
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text("Address",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_searching),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(_homeloc),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Continue'),
                      color: Colors.teal,
                      textColor: Colors.white,
                      elevation: 15,
                      onPressed: newItemDialog,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ))),
    );
  }

  _onPictureSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              height: screenHeight / 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 50,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.teal[200],
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 50,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        //color: Color.fromRGBO(101, 255, 218, 50),
                        color: Colors.teal[200],
                        textColor: Colors.black,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    //_cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 400);
    setState(() {});
  }

  void newItemDialog() {
    _itemname = _itemnamecontroller.text;
    _itemweight = _itemweightcontroller.text;

    if (_itemname == "" && _itemweight == "") {
      Toast.show(
        "Fill all required fields",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Add new Recycle Item? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: new Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _onAddItem();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onAddItem() {
    _itemname = _itemnamecontroller.text;
    _itemweight = _itemweightcontroller.text;

    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post("https://techvestigate.com/irecycle/php/additem.php", body: {
      "email": widget.user.email,
      "itemname": _itemname,
      "itemweight": _itemweight,
      "category": category,
      "encoded_string": base64Image,
      "ownername": widget.user.name,
      "phone": widget.user.phone,
      "location": _homeloc,
      "credit": widget.user.credit,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadmap() {
    _controller = null;
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Current location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 16,
      );
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              var alheight = MediaQuery.of(context).size.height;
              var alwidth = MediaQuery.of(context).size.width;
              return AlertDialog(
                  //scrollable: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Center(
                    child: Text("Select New Delivery Location",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                  //titlePadding: EdgeInsets.all(5),
                  //content: Text(_homeloc),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _homeloc,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        Container(
                          height: alheight - 300,
                          width: alwidth - 10,
                          child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: _userpos,
                              markers: markers.toSet(),
                              onMapCreated: (controller) {
                                _controller.complete(controller);
                              },
                              onTap: (newLatLng) {
                                _loadLoc(newLatLng, newSetState);
                              }),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          //minWidth: 200,
                          height: 30,
                          child: Text('Close'),
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            markers.clear(),
                            Navigator.of(context).pop(false),
                          },
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> _getLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;
        if (_currentPosition != null) {
          final coordinates = new Coordinates(
              _currentPosition.latitude, _currentPosition.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          setState(() {
            var first = addresses.first;
            _homeloc = first.addressLine;
            if (_homeloc != null) {
              latitude = _currentPosition.latitude;
              longitude = _currentPosition.longitude;
              return;
            }
          });
        }
      }).catchError((e) {
        print(e);
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 16,
      );
      markers.add(Marker(
        markerId: markerId1,
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: 'New Location',
          snippet: 'New Delivery Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        //_calculatePayment();
        return;
      }
    });
    setState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        //_calculatePayment();
        return;
      }
    });
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }
}
