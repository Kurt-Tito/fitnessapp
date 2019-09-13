import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/widgets.dart';

class UserManagement {

  createNewUser(FirebaseUser user, context, firstName, lastName, photoURL, email) {
    Firestore.instance.collection('users').document(user.uid)
      .setData({ 
        'userid': user.uid,
        'firstName': firstName,
        'lastName': lastName,
        'photoURL': photoURL,
        'email': email
        });

    /*    
    Firestore.instance.collection('users').document(user.uid).collection('ExerciseList').document('SampleExercise').setData({
      'Exercise': 'Sample',
      'Description': 'Sample',
      'Target': 'Sample'
    }); //inits users exercise list */
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.isEmailVerified;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  addRoutine(FirebaseUser user, routineName, timestamp) {
    Firestore.instance.collection('users').document(user.uid).collection('Routines').document().setData(
      {
        "desc": "",
        "routineName": routineName,
        "timestamp": timestamp
      }
    ).catchError((e) {
      print(e);
    });
  }

  deleteAllExercise(FirebaseUser user, routineID) {
    Firestore.instance.collection('users').document(user.uid).collection('Routines').document(routineID).collection('ExerciseList').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
  }

  addExercise(FirebaseUser user, routineID, exerciseName, description, target, timestamp) {
    //Firestore.instance.collection('users').document(user.uid).collection('Routines').document(routineID
    Firestore.instance.collection('users').document(user.uid).collection('Routines').document(routineID).collection('ExerciseList').document().setData(
      {
        "exerciseName": exerciseName,
        "description": description,
        "focus": target,
        "timestamp": timestamp,
      }
    ).catchError((e) {
      print(e);
    });
  }

  deleteExercise(FirebaseUser user, exercise) {
    Firestore.instance.collection('users').document(user.uid).collection('ExerciseList').document(exercise).delete();
  }
}