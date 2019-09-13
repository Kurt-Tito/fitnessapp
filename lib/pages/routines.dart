import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessapp/animation/transitions.dart';
import 'package:fitnessapp/pages/exercises.dart';
import 'package:fitnessapp/services/usermanagement.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/appdrawer/drawer.dart';

class Routines extends StatefulWidget {
    @override
    State<StatefulWidget> createState() => new RoutineState();
  }
  
class RoutineState extends State<Routines>{

  TextEditingController routineController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //return new Stack (
    //  children: <Widget>[],
    //)
    return new WillPopScope(
      onWillPop: () async => false, //prevents current activity from being popped by the system (back button)
      child: new Scaffold( 

        backgroundColor: Colors.blue[300],

        drawer: new MyDrawer(),

        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text("Routines"), 
          automaticallyImplyLeading: true, 
          backgroundColor: Colors.blue[300],
          iconTheme: new IconThemeData(color: Colors.white),),

        body: new RoutineList(),

        /*floatingActionButton: Container(
          height: 75.0,
          width: 75.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () => _addRoutineDialogue(),
              backgroundColor: Colors.greenAccent,
              child: Icon(Icons.add), 
            ),
          ),
        )*/

      ),
    );
  }

  void _addRoutineDialogue() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter a name for the routine: "),
            content: TextField(
              controller: routineController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  routineController.clear();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () async {
                  print("ADDED ROUTINE");
                  String timestamp = DateTime.now().toString();
                  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
                  UserManagement().addRoutine(currentUser, routineController.text, timestamp);
                  routineController.clear();
                  Navigator.of(context).pop();
                  
                },
              )
            ],
          );
        }
      );
    }
}


/*
 * Builds the Routine List widget and functionality
 */

class RoutineList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RoutineListState();
}

class RoutineListState extends State<RoutineList> {

  bool isEmpty = false;
  TextEditingController routineController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future getRoutines() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    QuerySnapshot querySnapshot = await Firestore.instance.collection('users').document(currentUser.uid).collection('Routines').orderBy('timestamp').getDocuments();
    //var time = DateTime.now();
    //print("timestamp: " +time.toString());
      if (querySnapshot.documents.isEmpty) {
      setState(() {
       isEmpty = true; 
      });
    } else {
      setState(() {
       isEmpty = false; 
      });
    }

    return querySnapshot.documents;
  }

  void _addRoutineDialogue() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter a name for the routine: "),
            content: TextField(
              controller: routineController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  routineController.clear();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Confirm"),
                onPressed: () async {
                  print("ADDED ROUTINE");
                  String timestamp = DateTime.now().toString();
                  FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
                  UserManagement().addRoutine(currentUser, routineController.text, timestamp);
                  routineController.clear();
                  Navigator.of(context).pop();
                  getRoutines();
                },
              )
            ],
          );
        }
      );
    }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      floatingActionButton: Container(
        width: 75.0,
        height: 75.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => _addRoutineDialogue(),
            backgroundColor: Colors.greenAccent,
            child: Icon(Icons.add),
          ),
        ),
      ),

      body: isEmpty ? 
      Center(child: Text("Routine list is empty\nAdd (+) a new routine", style: TextStyle(color: Colors.white),)) : 
        FutureBuilder(
          future: getRoutines(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(backgroundColor: Colors.white,));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      //height: 100.0,
                      child: Material(
                        color: Colors.blue[400],
                        elevation: 12.0,
                        borderRadius: BorderRadius.circular(16.0),
                        shadowColor: Color(0x802196F3),
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: ListTile(
                            onTap: ()=>enterRoutine(snapshot.data[index].data["routineName"], snapshot.data[index].documentID), //code for enterRoutine needed
                            onLongPress: ()=>_showDialog(() {}, () {
                              
                              //functions for edit, delete, and cancel
                              _showDeleteDialogue(() async {
                                  await Firestore.instance.runTransaction((Transaction myTransaction) async {
                                  await myTransaction.delete(snapshot.data[index].reference);
                                });
                                setState(() {});
                              });
                            
                            }),
                            title: Align(alignment: Alignment.centerLeft, child: Text(snapshot.data[index].data["routineName"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                            subtitle: Text("\n" +snapshot.data[index].data["desc"], style: TextStyle(color: Colors.white),),
                            trailing: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.edit),
                              onPressed: () {print("Pressed Edit Routine");},),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
    );
  }

  void enterRoutine(String routineName, String documentID) {
    print("Entering routine...");
    //set isInitialRoute to true for default route animation
    //MaterialPageRoute route = new MaterialPageRoute(settings: RouteSettings(isInitialRoute: false), builder: (BuildContext context) => new Exercises(routine: routineName),);
    Navigator.of(context).push(SlideLeftRoute(page: Exercises(routine: routineName, documentID: documentID,)));
  }

  void _showDeleteDialogue(void function()) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete routine?"),
          content: Text("This will permanently delete this routine from the list"),
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

  void _showDialog(void editFunctin(), void deleteFunction()) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AlertDialog(
              backgroundColor: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
              //title: Text("Delete this routine?"),
              content: Column(
                children: <Widget>[
                  Container( 
                    width: 1200.0,
                      child: ListTile(
                        onTap: () {
                          //Navigator.of(context).pop();
                          editFunctin();
                        },
                        title: Align(
                          alignment: Alignment.center, 
                          child: Text("EDIT", style: TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),)),

                  new Divider(height: 4.0,),

                  Container( 
                    width: 1200.0,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          deleteFunction();
                        },
                        title: Align(
                          alignment: Alignment.center, 
                          child: Text("DELETE", style: TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),)),

                  new Divider(height: 4.0,),

                  Container( 
                    width: 1200.0,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        title: Align(
                          alignment: Alignment.center, 
                          child: Text("CANCEL", style: TextStyle(color:Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)),)),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

/*
  Widget _createDialogContent() {
    return Center(
      child: ,
    );
  } */
}


