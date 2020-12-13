import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _email, _password;
String urlLogin = "https://techvestigate.com/irecycle/php/dbconnector.php";

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.green));
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        accentColor: Colors.greenAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            /*image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),*/
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: 600,
                height: 450,
              ),
              SizedBox(
                height: 30,
              ),
              new ProgressIndicator(),
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
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            loadpref(this.context);
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
                  width: 200,
                  height: 20,
                  color: Colors.redAccent,
                  child: LinearProgressIndicator(
                    value: animation.value,
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                ));
              }

              void loadpref(BuildContext ctx) async {
                print('Inside loadpref()');
  
      Navigator.push(
          ctx, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  
        
}
    
