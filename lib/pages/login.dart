import 'package:fitnessapp/customwidgets/customtextformfield.dart';
import 'package:fitnessapp/customwidgets/filledbutton.dart';
import 'package:fitnessapp/pages/routines.dart';
import 'package:fitnessapp/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {

  String _email = '';
  String _password = '';

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            customTextFormField(
              context, emailController, 
              (input) {

                if (input.isEmpty) 
                  return 'Please provide an email';
                else if (!input.contains("@")) 
                  return 'Please provide a valid email address';
                else 
                  return null;
                  
            }, (value) => _email = value, 'Email', Icon(Icons.email), false),

            new Divider(color: Colors.transparent,),
            
            customTextFormField(
              context, passwordController, 
              (input) {

                if (input.isEmpty) 
                  return 'Please provide a passowrd';
                else if (input.length < 4) 
                  return 'Password must be at least 4 characters long';
                else
                  return null;

              }, (value) => _password = value, 'Password', Icon(Icons.lock), true),

            new Divider(color: Colors.transparent,),

            Row(children: <Widget>[
              Expanded(
                child: Container(
                height: 65.0,
                child: filledButton("REGISTER", Colors.white, Colors.blue[300], Colors.blue[300], Colors.white, () {
                  //Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUp()));
                })),
              ),

              Expanded(
                child: Container(
                height: 65.0,
                child: filledButton("LOGIN", Colors.white, Colors.blue[300], Colors.blue[300], Colors.white, ()=>validateLogin())
              )),
            ],)

          ],
        )
      ),
    );
  }

  void validateLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text)
      .then((onValue) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Routines()));
      }).catchError((e) {
        setState(() {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: new Text(e.message),
          )); 
        });
      });
    }
  }
}