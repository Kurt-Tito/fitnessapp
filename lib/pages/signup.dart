import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/customwidgets/customtextformfield.dart';
import 'package:fitnessapp/customwidgets/filledbutton.dart';
import 'package:fitnessapp/pages/routines.dart';
import 'package:fitnessapp/services/usermanagement.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override 
  SignUpState createState() => new SignUpState();
}

class SignUpState extends State<SignUp> {

  bool _isMatched = false;

  final emailController = new TextEditingController();
  //final firstNameController = new TextEditingController();
  //final lastNameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();

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
            customTextFormField(context, emailController, (input) {

              if (input.isEmpty) {
                return 'Please provide an email address';
              }
              else if (!input.contains("@"))
                return 'Please provide a valid email address';
              else 
                return null;
                
            }, (input) {}, "Email", Icon(Icons.email), false),

            Divider(color: Colors.transparent,),

            customTextFormField(context, passwordController, (input) {

              if (input.isEmpty) {
                return 'Please provide a password';
              }
              else if (input.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              else if (!_isMatched) {
                return 'Passwords do not match';
              }
              else {
                return null;
              }

            }, (input) {}, "Password", Icon(Icons.lock_open), true),

            Divider(color: Colors.transparent,),

            customTextFormField(context, confirmPasswordController, (input) {

              if (input.isEmpty) {
                return 'Please provide a password';
              }
              else if (input.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              else if (!_isMatched) {
                return 'Passwords do not match';
              }
              else {
                return null;
              }

            }, (input) {}, "Confirm Password", Icon(Icons.lock), true),

            Divider(color: Colors.transparent,),

            Row(children: <Widget>[
              Expanded(
                child: Container(
                  height: 65.0,
                  child: filledButton("CANCEL", Colors.white, Colors.blue[300], Colors.blue[300], Colors.white, () {
                    Navigator.of(context).pop();
                  }),
                ),),
              
              Expanded(
                child: Container(
                  height: 65.0,
                  child: filledButton("CONFIRM", Colors.white, Colors.blue[300], Colors.blue[300], Colors.white, () {

                    passwordController.text == confirmPasswordController.text ? _isMatched = true : _isMatched = false;

                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text
                      ).then((user) async {
                        
                        FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
                        UserManagement().createNewUser(currentUser, context, "default", "default", "default", emailController.text);

                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Routines()));

                      }).catchError((e) {
                        setState(() {
                         _scaffoldKey.currentState.showSnackBar(SnackBar(
                           content: Text(e.message),
                         )); 
                        });
                      });
                      
                    }

                  }),
                ),
              )

            ],)
          ],
        ),
      ),
    );
  }

}