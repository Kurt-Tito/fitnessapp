import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/services/usermanagement.dart';
import 'package:flutter/material.dart';

class AllExercises extends StatefulWidget {

  final ValueChanged<bool> parentAction;
  final String routineID;

  const AllExercises({Key key, this.parentAction, this.routineID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AllExercisesState();
}

class AllExercisesState extends State<AllExercises>{
  
  FloatingActionButtonLocation location = FloatingActionButtonLocation.centerFloat;
  ScrollController _controller;
  
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent && !_controller.position.outOfRange) {
      setState(() {
       location = FloatingActionButtonLocation.endFloat; 
      });
    } else {
      setState(() {
       location = FloatingActionButtonLocation.centerFloat; 
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  Future getAllExercises() async {
    //FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    QuerySnapshot querySnapshot = await Firestore.instance.collection('allexercises').orderBy('exerciseName').getDocuments();
    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: FutureBuilder(
        future: getAllExercises(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Align(alignment: Alignment.center, child: Text("Loading...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),));
            //return CircularProgressIndicator(backgroundColor: Colors.white,);
          } else {
            return ListView.builder(
              controller: _controller,
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                
                return Card(
                  //padding: EdgeInsets.symmetric(vertical: 5.0),
                  elevation: 4.0,
                  margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [0.1, 0.9],
                        colors: [Colors.blue[500], Colors.blue[300]],
                      )
                    ),
                    child: Center(
                      child: ListTile(
                        onTap: () async {

                          print("ADDED THIS EXERCISE");
                          String timestamp = DateTime.now().toString();
                          FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
                          UserManagement().addExercise(currentUser, widget.routineID, snapshot.data[index].data["exerciseName"], snapshot.data[index].data["description"], snapshot.data[index].data["focus"], timestamp);
                          widget.parentAction(false);
                          //setState(() {});
                          },

                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        title: Text(snapshot.data[index].data["exerciseName"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        subtitle: Text(snapshot.data[index].data["description"], style: TextStyle(color: Colors.white),),
                        trailing: Text(snapshot.data[index].data["focus"], style: TextStyle(color: Colors.white),),
                        ),
                    ),
                  ),
                  );

              },
            );
          }
        },
      ),
      floatingActionButtonLocation: location,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[300],
        onPressed: () {
          widget.parentAction(false);
        },
        child: Icon(Icons.cancel, color: Colors.white,),
      ),
    );
  }
}