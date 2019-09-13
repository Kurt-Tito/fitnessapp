import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/pages/login.dart';
import 'package:fitnessapp/services/usermanagement.dart';
import 'package:flutter/material.dart';
import './routines.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Splash();
}

class _Splash extends State<Splash> {
  int _counter = 3;

  @override
  void initState() {
    super.initState();
    delay();
  }

  @override
  Widget build(BuildContext context) => Material (
      //color: Colors.lightBlue,
      child: Container (
        //color: Colors.lightBlue,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.9],
            colors: [
              Colors.blue[500],
              Colors.blue[300]
            ]
          )
        ),

        child: new InkWell(
          onTap: () => {/*Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Routines()))*/},
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("[ ]-----[ ]", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
              //new Divider(),
              //new Text("fitnessapp", style: new TextStyle(color: Colors.white, fontSize: 16))
            ],
          ),
        )

    ),
  );

  void delay() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      if(timer.tick >= _counter)
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Routines()));
        if (await FirebaseAuth.instance.currentUser() != null) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Routines()));
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
        }

    });
    
  }
}