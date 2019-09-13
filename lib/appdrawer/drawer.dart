import 'package:fitnessapp/pages/login.dart';
import 'package:fitnessapp/pages/splash.dart';
import 'package:fitnessapp/services/usermanagement.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          new MyHeader(),
          ListTile(
            title: Row(
              children: <Widget>[
                Text("Home"),
                Expanded(child: Text("(WIP)", textAlign: TextAlign.end, style: TextStyle(color: Colors.blue),))
              ],
            ),
            leading: Icon(Icons.home),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Text("Statistics"),
                Expanded(child: Text("(WIP)", textAlign: TextAlign.end, style: TextStyle(color: Colors.blue),))
              ],
            ),
            leading: Icon(Icons.insert_chart),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Text("Settings"),
                Expanded(child: Text("(WIP)", textAlign: TextAlign.end, style: TextStyle(color: Colors.blue),))
              ],
            ),
            leading: Icon(Icons.settings),
          ),
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () => _showLogoutDialogue(context),
          )
        ],
      )
    );
  }
}

void _showLogoutDialogue(BuildContext context) {
  Navigator.of(context).pop();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Log out of fitness app?"),
        content: Text("This will log you out and redirect you to the login page."),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {Navigator.of(context).pop();},
          ),
          FlatButton(
            child: Text("ACCEPT"),
            onPressed: () {
              UserManagement().signOut();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
            },
          )
        ],
      );
    }
  );
}

class MyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        //image: DecorationImage(
        //  fit: BoxFit.fill,
        //  image: AssetImage('lib/res/orange.jpg'),
        //),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.9],
          colors: [
            Colors.blue[500],
            Colors.blue[300]
          ]
        )
      ),
      child: Stack(children: <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text("fitnessapp", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),),
        )
      ],),
    );
  }
}

Widget _createHeader() {
  return DrawerHeader(
    margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        //image: DecorationImage(
        //  fit: BoxFit.fill,
        //  image: AssetImage('lib/res/orange.jpg'),
        //),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [
            Colors.green[600],
            Colors.green[500]
          ]
        )
      ),
      child: Stack(children: <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text("fitnessapp", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),),
        )
      ],),
  );
}