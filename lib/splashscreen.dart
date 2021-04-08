import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

//String _email, _password;
//String urlLogin = "https://techvestigate.com/irecycle/php/dbconnector.php";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splashscreen.gif'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              /*SizedBox(
                height: 500,
              ),*/
              Text(
                'iRecycle',
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.teal[50],
                    fontWeight: FontWeight.bold),
              ),
              /*Image.asset(
                'assets/images/splashscreen.gif',
               scale: 1,
              ),*/
              SizedBox(
                height: 20,
              ),
              new ProgressIndicator(),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 10000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          width: 300,
          height: 12,
          
      child: LiquidLinearProgressIndicator(
        borderWidth: 2.0,
        borderRadius: 12.0,
        borderColor: Colors.blueGrey,
        //value: 0.25,
        backgroundColor: Colors.teal[50],
        direction: Axis.horizontal,
        value: animation.value,
        valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
        //valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal[50]),
      ),
    ));
  }
}
