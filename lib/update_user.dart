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
  List<DropdownMenuItem> _roleMenuItems;
  String _roleValue;
  List<String> roles = ['Staff Member Roles'];

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();

    _createDropdownMenuItems(2, roles);
    _setDefaults();
  }

  void _setDefaults() {
    Firestore.instance.collection('roles').getDocuments().asStream()
        .forEach((snap) {
      for (var role in snap.documents) {
        roles.add(role['roleName']);
      }
    }).whenComplete((){
      setState(() {
        _createDropdownMenuItems(2, roles);
        _roleValue = roles[0];
      });
    });
  }


  Widget _createDropdown(int idx, String currentValue, ValueChanged<dynamic>

  onChanged) {

    return Container(
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: TodoColors.baseColors[_colorIndex],
        border: Border.all(
          color: TodoColors.baseColors[_colorIndex],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
            child: new SingleChildScrollView(
                child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 8.0,
                    ),
                    child: DropdownButtonHideUnderline(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            DropdownButton(
                              value: currentValue,
                              items: _roleMenuItems,
                              onChanged: onChanged,
                              style: TodoColors.textStyle2,
                            ),],))))
        ),
      ),
    );
  }

  void _updateRoleValue(dynamic name) {
    setState(() {
      _roleValue = name;
      hasChanged[0] = true;
    });
  }

  /// Creates fresh list of [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems(int idx, List<String> list) {
    var newItems = <DropdownMenuItem>[];
    for (var unit in list) {
      newItems.add(DropdownMenuItem(
        value: unit,
        child: Container(
          child: Text(
            unit,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      if (idx == 2) {
        _roleMenuItems = newItems;
      }
    });
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
          InputDecorator(
            key: _userRole,
            child:Theme(
      data: ThemeData(
//      accentColor: Colors.yellow,
      ),
      child: Text(
      document['userRole'],
      style: TodoColors.textStyle2,
      ),
      ),
            decoration: InputDecoration(
              labelText: 'User Role',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          const SizedBox(height: 12.0),
          _createDropdown(2, _roleValue, _updateRoleValue),

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
                  if (hasChanged[0] && _roleValue != roles[0]) {
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot freshSnap =
                      await transaction.get(document.reference);
                      await transaction.update(freshSnap.reference, ({
                        'userRole': _roleValue, }));
                    });
                    showInSnackBar(
                        "User Role Updated Successfully", TodoColors.baseColors[widget.colorIndex]);
                  }
                 Navigator.of(context).pop();
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

