import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/pages/allexercises.dart';
import 'package:fitnessapp/pages/focusdiagram.dart';
import 'package:fitnessapp/services/usermanagement.dart';
import 'package:flutter/material.dart';

class Exercises extends StatefulWidget {

  final String routine; //value is computed at runtime, declare as final rather than const
  final String documentID;

  Exercises({Key key, this.routine, this.documentID}) : super(key: key); 

  @override
  State<StatefulWidget> createState() => new ExerciseState();
}

class ExerciseState extends State<Exercises> {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.blue[300],

      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(widget.routine, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        //automaticallyImplyLeading: true,
        leading: IconButton(icon: Icon(Icons.chevron_left), onPressed: () {Navigator.of(context).pop();},),
        backgroundColor: Colors.blue[300],
        iconTheme: new IconThemeData(color: Colors.white),),
      
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (DragUpdateDetails details) {
          if (details.delta.dx > 0) {
            //swipe right
            Navigator.of(context).pop();
          }
        },
        child: new ExerciseList(routineID: widget.documentID)), 
    );

  }
}

/*
 * Builds the Routine List widget and functionality
 */

class ExerciseList extends StatefulWidget {

  final String routineID;
  
  ExerciseList({Key key, this.routineID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new ExerciseListState();
}

class ExerciseListState extends State<ExerciseList> {

  var snap;

  bool isEmpty = false;
  bool _isVisible = false;
  bool _muscleGraphVisibility =false;
  Duration _myDuration = new Duration(
    seconds: 5
  );
  GlobalKey _addExercisePanel = GlobalKey();
  double widgetWidth = 0;
  double widgetHeight = 0;

  bool _isButtonDisabled = false;

  @override
  void initState() {
    //super.initState();
    //WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  Future getExercises() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    QuerySnapshot querySnapshot = await Firestore.instance.collection('users').document(currentUser.uid).collection('Routines').document(widget.routineID).collection('ExerciseList').orderBy('timestamp').getDocuments();

    if (querySnapshot.documents.isEmpty) {
      setState(() {
       isEmpty = true; 
      });
    } else {
      setState(() {
       isEmpty = false; 
      });
    }
    //var time = DateTime.now();
    //print("timestamp: " +time.toString());
    snap = querySnapshot;
    return querySnapshot.documents;
  }

  void _toggleVisibility() {
    _isVisible = !_isVisible;
  }   

  _updateVisibility(bool status) {
    setState(() {
     _isVisible = status; 
    });
    getExercises(); //must be called to reload list when adding and set the the proper isEmpty bool
  }

  _updateMuscleGraphVisibility(bool status) {
    setState(() {
      _muscleGraphVisibility = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
              child: isEmpty ? _createEmptyExercises() : 
              FutureBuilder(
                future: (getExercises()),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    _isButtonDisabled = true;
                    return Align(alignment: Alignment.center, child: Text("Loading...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),));
                  } else {
                    _isButtonDisabled = false;
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                      //final String exercise = _sampleExercises[index];
                      
                      /*
                      if (exercise == "Chest" || exercise == "Core" || exercise == "Legs") {
                        return ListTile (
                          title: Text(exercise, style: Theme.of(context).textTheme.headline,),
                        );
                      } 
                      else {
                        return ListTile (
                          title: Text(exercise),
                        );
                      } */

                      return Padding(
                        padding: EdgeInsets.all(0.0),
                        //elevation: 4.0,
                        //margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              stops: [0.1, 0.9],
                              colors: [Colors.blue[500], Colors.blue[300]],
                            )
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            /*
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                border: new Border(
                                  right: new BorderSide(width: 1.0, color: Colors.white)
                                )
                              ),
                              child: Icon(Icons.fiber_manual_record, color: Colors.white,),
                            ),
                            */
                            title: Text(snapshot.data[index].data["exerciseName"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),),
                            trailing: IconButton(icon: Icon(Icons.close, color: Colors.white,), onPressed: () {
                              
                              _showDialog(() async {
                                  await Firestore.instance.runTransaction((Transaction myTransaction) async {
                                  await myTransaction.delete(snapshot.data[index].reference);
                                });
                                //setState(() {});
                              });
                              
                            },),
                            onLongPress: () {
                              _showDeleteAllDialog(() async{
                                FirebaseUser user = await FirebaseAuth.instance.currentUser();
                                UserManagement().deleteAllExercise(user, widget.routineID);
                              });
                            },
                            ),
                        ),
                        );

                      },);
                  }
                },
              )),

            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.orange[300],
                      height: 75.0,
                      //width: double.infinity,
                      child: FlatButton(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Text("", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        new Divider(indent: 10.0,),
                        Icon(Icons.add, color: Colors.white, size: 32.0,)
                      ],), onPressed: () {
                        setState(() {
                          _toggleVisibility(); 
                        });
                      },),
                    ),
                  ),
                  
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.green[300],
                      height: 75.0,
                      //width: double.infinity,
                      child: FlatButton(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        //Icon(Icons.show_chart, color: Colors.white,),
                        Text("MUSCLE HIGHLIGHT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        new Divider(indent: 10.0,),
                        //Icon(Icons.play_arrow, color: Colors.white,)
                      ],), onPressed: _isButtonDisabled? null : () {
                        setState(() {
                         _muscleGraphVisibility = true; 
                        });
                      },),
                    ),
                  ),
                ],
              ),
            ),
            ]),

        Visibility(
          visible: _isVisible,
          child: AnimatedContainer(
            key: _addExercisePanel,
            //height: widgetHeight,
            color: Colors.blue[300], 
            duration: _myDuration,
            child: AllExercises(
              parentAction: _updateVisibility,
              routineID: widget.routineID
            ),),
        ),

        Visibility(
          visible: _muscleGraphVisibility,
          child: FocusDiagram(
            snapshot: snap,
            parentAction: _updateMuscleGraphVisibility),
        )    

      ],
    );
  }

  _getSizes() {
    final RenderBox renderBox = _addExercisePanel.currentContext.findRenderObject();
    final size = renderBox.size;
    widgetWidth = size.width;
    widgetHeight = size.height;
    print("SIZE of widgets: $size");
  }

  _getPositions() {
    final RenderBox renderBox = _addExercisePanel.currentContext.findRenderObject();
    final position = renderBox.size;
    print("SIZE of widget: $position");
  }

  _afterLayout(_) {
    _getSizes();
    _getPositions();
  }

  void _showDeleteAllDialog(void function()) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete ALL exercises?"),
          content: Text("This will permanently delete ALL the exercises from the list"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Accept"),
              onPressed: () {
                function();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  void _showDialog(void function()) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete exercise?"),
          content: Text("This will permanently delete this exercise from the list"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Accept"),
              onPressed: () {
                function();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  Widget _createEmptyExercises () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: <Widget>[
        Text("Exercise list is empty", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        Text("Edit this routine and an exercise", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)],);
  }

}