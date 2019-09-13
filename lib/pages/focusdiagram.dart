import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FocusDiagram extends StatefulWidget{
  
  final QuerySnapshot snapshot;
  final ValueChanged<bool> parentAction;

  FocusDiagram({Key key, this.snapshot, this.parentAction}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FocusDiagramState();
}

class FocusDiagramState extends State<FocusDiagram> {

  var frontMuscles = List<Widget>();
  var backMuscles = List<Widget>();
  //double _opacity = 0.50;
  double _frontOpacity = 0.50;
  double _backOpacity = 0.50;
  //final List<String> focus = new List<String>();

  @override
  void initState() {
    super.initState();
    
    frontMuscles.add(
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/muscles/single/front.png")
          )
        ),
      )
    );
    backMuscles.add(
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/muscles/single/back.png"),
            //fit: BoxFit.cover
          )
        ),
      )
    );

    for (int i = 0; i < widget.snapshot.documents.length; i++) {
      //focus.add(widget.snapshot.documents[i].data['focus']);
      if (widget.snapshot.documents[i].data['focus'] == "chest" || 
          widget.snapshot.documents[i].data['focus'] == "forearms" || 
          widget.snapshot.documents[i].data['focus'] == "neck" || 
          widget.snapshot.documents[i].data['focus'] == "quadriceps" || 
          widget.snapshot.documents[i].data['focus'] == "shoulders" || 
          widget.snapshot.documents[i].data['focus'] == "abdominals" || 
          widget.snapshot.documents[i].data['focus'] == "biceps") {
            frontMuscles.add(_buildFrontMuscles(widget.snapshot.documents[i].data['focus']));
            //_frontOpacity -= 0;
          }

      if (widget.snapshot.documents[i].data['focus'] == "lats" || 
          widget.snapshot.documents[i].data['focus'] == "middle back" || 
          widget.snapshot.documents[i].data['focus'] == "lower back" || 
          widget.snapshot.documents[i].data['focus'] == "hamstrings" || 
          widget.snapshot.documents[i].data['focus'] == "calves" || 
          widget.snapshot.documents[i].data['focus'] == "triceps" || 
          widget.snapshot.documents[i].data['focus'] == "traps" ||
          widget.snapshot.documents[i].data['focus'] == "glutes") {
            backMuscles.add(_buildBackMuscles(widget.snapshot.documents[i].data['focus']));
            //_backOpacity -= 10;
          }
    }
  }

  Widget _imageFile(String filepath) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(filepath)
        )
      ),
    );
  }

  Widget _buildFrontMuscles(String muscle) {
    switch(muscle) {
      case "chest":
        return Opacity(
          opacity: _frontOpacity,
          child: _imageFile("assets/muscles/single/chest.png"),
        );
        break;
      case "forearms":
        return Opacity(
          opacity: _frontOpacity,
          child: _imageFile("assets/muscles/single/forearms.png"),
        );
        break;
      case "neck":
        return Opacity(
          opacity: _frontOpacity,
          child: _imageFile("assets/muscles/single/neck.png"),
        );
        break;
      case "quadriceps":
        return Opacity(
          opacity: _frontOpacity,
          child: _imageFile("assets/muscles/single/quadriceps.png"),
        );
        break;
      case "shoulders":
        return Opacity(
          opacity: _frontOpacity,
          child: _imageFile("assets/muscles/single/shoulders.png"),
        );
        break;
      case "abdominals":
        return Opacity(
          opacity: _frontOpacity,
          child: _imageFile("assets/muscles/single/abdominals.png"),
        );
        break;
      case "biceps":
        return Opacity(
          opacity: _frontOpacity,
          child: _imageFile("assets/muscles/single/biceps.png"),
        );
        break;
      default: 
        return Text("ERROR: focus not found", style: TextStyle(color: Colors.white),);
        break;
    }
  }

  Widget _buildBackMuscles(String muscle) {
    switch(muscle) {
      case "lats":
        return Opacity(
          opacity: _backOpacity,
          child: _imageFile("assets/muscles/single/lats.png"),
        );
        break;
      case "middle back":
        return Opacity(
          opacity: _backOpacity,
          child:  _imageFile("assets/muscles/single/middleBack.png"),
        );
        break;
      case "lower back":
        return Opacity(
          opacity: _backOpacity + 0.10,
          child: _imageFile("assets/muscles/single/lowerBack.png"),
        );
        break;
      case "hamstrings":
        return Opacity(
          opacity: _backOpacity,
          child: _imageFile("assets/muscles/single/hamstrings.png"),
        );
        break;
      case "calves":
        return Opacity(
          opacity: _backOpacity,
          child: _imageFile("assets/muscles/single/calves.png"),
        );
        break;
      case "triceps":
        return Opacity(
          opacity: _backOpacity,
          child: _imageFile("assets/muscles/single/triceps.png"),
        );
        break;
      case "traps":
        return Opacity(
          opacity: _backOpacity,
          child: _imageFile("assets/muscles/single/traps.png"),
        );
        break;
      case "glutes":
        return Opacity(
          opacity: _backOpacity,
          child: _imageFile("assets/muscles/single/glutes.png"),
        );
        break;
      default:
        return Text("ERROR: focus not found", style: TextStyle(color: Colors.white),);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue[300],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: "Front",),
                Tab(text: "Rear",)
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(child: Stack(children: frontMuscles)),
              Center(child: Stack(children: backMuscles))
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

/*
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      focusMuscles.add(querySnapshot.documents[i].data['focus']);
    }*/