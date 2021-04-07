import 'package:flutter/material.dart';
import 'package:recycle/loginpage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:recycle/registrationscreen.dart';
import 'package:toast/toast.dart';


final TextEditingController _emcontroller = TextEditingController();
String _email = "";
String urlpw = "https://techvestigate.com/irecycle/php/forgetPassword.php";


class ForgotpwScreen extends StatefulWidget {
  @override
  _ForgotpwState createState() => _ForgotpwState();
}

class _ForgotpwState extends State<ForgotpwScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Reset Password'),
          //backgroundColor: Colors.teal[200],
        ),
        body: new Container( 
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                child: Text('Forgot Password',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.teal[900]))),
            SizedBox(height: 10),
            Container(
                child: Text('Please enter your email and we will send you a link to return to your account', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15))),
              SizedBox(height: 100),
              TextField(
                  controller: _emcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    //filled: true,
                    //fillColor: Colors.greenAccent[50],
                    labelText: 'Email',
                    hintText: 'example@gmail.com',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 42, vertical: 20),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        gapPadding: 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.teal),
                        gapPadding: 10),
                    icon: Icon(Icons.email_outlined))),
              SizedBox(height: 100),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 350,
                height: 50,
                child: Text('Continue'),
                color: Colors.teal,
                textColor: Colors.white,
                elevation: 15,
                onPressed: _onSubmit,
              ),
              SizedBox(height: 30),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account? ", style: TextStyle(fontSize: 16)),
                GestureDetector(
                  onTap: _onRegister,
                  child: Text('Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.teal)),
                ),
              ],
            )
              
            ],
          ),
        ),
      ),
    );
  }

  void _onRegister() {
    print('onBackpress from Forgot Password');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }

  void _onSubmit() {
    _email = _emcontroller.text;
    if (_checkEmail(_email)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Sending link to your email.");
      pr.show();
      http.post(urlpw, body: {
        "email": _email,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        
        _emcontroller.text = '';
        pr.hide();
        
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        
      }).catchError((err) {
        pr.hide();
        print(err);
      });
    } else {}
  }

  bool _checkEmail(String email) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    return emailValid;
  }
} 
