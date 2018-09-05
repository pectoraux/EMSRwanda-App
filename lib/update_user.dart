import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'animated_logo.dart';
import 'loading_screen.dart';

class UpdateUserPage extends StatefulWidget {
  final int colorIndex;
  final String userDocumentID;

  const UpdateUserPage({
    @required this.colorIndex,
    @required this.userDocumentID,
  }) : assert(colorIndex != null),
        assert(userDocumentID != null);


  @override
  UpdateUserPageState createState() => UpdateUserPageState();
}

class UpdateUserPageState extends State<UpdateUserPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  final _userRoleController = TextEditingController();
  final _userRole = GlobalKey(debugLabel: 'User Role');
  int _colorIndex = 0;
  List<bool> hasChanged = [false, false, false, false, false, false, false];

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }



    Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              AnimatedLogo(animation: animation,
                message: 'Update ${document['firstName']} ${document['lastName']} Information',
                factor: 1.0,
                colorIndex: widget.colorIndex,),
            ],
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[widget.colorIndex],
            child: TextFormField(
              key: _userRole,
              initialValue: document['userRole'],
              onSaved: (text) {
                _userRoleController.text = text;
                hasChanged[0] = true;
              },
              onFieldSubmitted: (text) {
                _userRoleController.text = text;
                hasChanged[0] = true;
              },
              decoration: InputDecoration(
                labelText: 'User Role',
                hintText: document['userRole'],
                border: CutCornersBorder(),
              ),
            ),
          ),

          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                textColor: TodoColors.baseColors[_colorIndex],
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  _userRoleController.clear();
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('UPDATE'),
                textColor: TodoColors.baseColors[_colorIndex],
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  if (_userRoleController.value.text.trim() != "") {
                    showInSnackBar(
                        "User Updated Successfully", TodoColors.accent);
                  } else {
                    showInSnackBar("Please Specify A Value For All Fields",
                        Colors.redAccent);
                  }
                },
              ),
            ],
          ),
        ],
      );
    }


  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').limit(100).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen(),
            );
          } else {
            DocumentSnapshot document = snapshot.data.documents.where((doc){
              return doc.documentID == widget.userDocumentID;}).first;


            final converter = _buildListItem(
                context, document);

            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return converter;
                } else {
                  return Center(
                    child: Container(
                      width: 450.0,
                      child: converter,
                    ),
                  );
                }
              },
            );
          }
        });
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

