import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycle/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:recycle/registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:recycle/mainscreen.dart';
import 'package:recycle/forgotpw.dart';

String urlLogin = "https://techvestigate.com/irecycle/php/login.php";

bool _isChecked = true;
final TextEditingController _emcontroller = TextEditingController();
String _email = "";
final TextEditingController _pscontroller = TextEditingController();
String _password = "";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: new Container(
        decoration: BoxDecoration(
          /*image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover),*/
        ),
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              scale: 2.5,
            ),
            TextField(
                controller: _emcontroller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.lightGreenAccent[50],
                    labelText: 'Email',
                    icon: Icon(Icons.email))),
            SizedBox(height: 10.0),
            TextField(
              controller: _pscontroller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightGreenAccent[50],
                  labelText: 'Password',
                  icon: Icon(Icons.lock)),
              obscureText: true,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                ),
                Text('Remember Me', style: TextStyle(fontSize: 16))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 300,
              height: 50,
              child: Text('Login'),
              color: Colors.teal[800],
              textColor: Colors.white,
              elevation: 20,
              onPressed: _onLogin,
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                    onTap: _onRegister,
                    child: Text('Register New Account',
                        style: TextStyle(fontSize: 16, color: Colors.blue)
                        ),
                        ),
                Spacer(),
                GestureDetector(
                    onTap: _onForgot,
                    child:
                        Text('Forgot Password', 
                        style: TextStyle(fontSize: 16,color: Colors.blue),
                        ),
                        ),
              ],
            )
            
          ],
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://techvestigate.com/irecycle/php/login.php", body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      print(res.body);
      List userdata = res.body.split(",");
      if (userdata[0] == "success") {
        Toast.show(
          "Login Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        User user = new User(
            email: _email,
            name: userdata[1],
            password: _password,
            phone: userdata[2],
            date: userdata[3]);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen(user: user)));
      } else {
        Toast.show(
          "Login failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      print('Check value $value');
      savePref(value);
    });
  }

  bool _checkEmail(String _email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    return emailValid;
  }

  void _onRegister() {
    print('onRegister');
    Navigator.push(
      context, MaterialPageRoute(builder: (context)=>RegisterScreen())
    );
  }

  void _onForgot() {
    print('Forgot');
    Navigator.push(
      context, MaterialPageRoute(builder: (context)=>ForgotpwScreen())
    );
  }

  void savePref(bool value) async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;
    if (value) {
      if (_checkEmail(_email) && (_password.length > 5)) {
        await prefs.setString('email', _email);
        await prefs.setString('pass', _password);
        print('Pref Stored');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
      //store value in pref
    } else {
      //remove value from pref
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      setState(() {
        _emcontroller.text = '';
        _pscontroller.text = '';
        _isChecked = false;
      });
      Toast.show('Preferences have been removed', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _loadpref() async {
    print('Inside loadpref');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);
    if (_email.length > 1) {
      _emcontroller.text = _email;
      _pscontroller.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      setState(() {
        _isChecked = false;
      });
    }
  }

}