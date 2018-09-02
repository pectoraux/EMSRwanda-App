import 'dart:async';

import 'profile_icons.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_role_actions.dart';
import 'color_override.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'animated_logo.dart';
import 'loading_screen.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

class EditRolesPage extends StatefulWidget {
  @override
  EditRolesPageState createState() => EditRolesPageState();
}

class EditRolesPageState extends State<EditRolesPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final _roleNameController = TextEditingController();
  final _roleName = GlobalKey(debugLabel: 'Role Name');
  bool _createUserPermission = false;
  bool _createProjectPermission = false;
  bool _createRolePermission = false;
  bool _createTagPermission = false;
  bool _grantUserPermission = false;
  bool _createDevicePermission = false;
  List devices = [
    "ipad",
    "Microphone",
    "Dictaphone",
    "Phone",
  ];
  int _colorIndex = 0;
  List<bool> changed = [false];
  String roleName = "";

  bool allFalse(List<bool> lst){
    for(bool l in lst){
      if (l == true) return false;
    }
    return true;

  }

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
        });
  }


    Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          new QuickRoleActions(),

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              AnimatedLogo(animation: animation, message: 'Create A New Role', factor: 1.0, colorIndex: _colorIndex,),
            ],
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _roleName,
              controller: _roleNameController,
              decoration: InputDecoration(
                labelText: 'Role Name',
                labelStyle: TodoColors.textStyle2,
                border: CutCornersBorder(),
              ),
              onChanged: (text) { changed[0] = true; roleName = text;},
            ),
          ),


          new CheckboxListTile(
            title: Text('Can Create User', style: TodoColors.textStyle2,),
            value: _createUserPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createUserPermission = permission;
              });
            },
            secondary: new Icon(
              LineAwesomeIcons.user, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Create Project', style: TodoColors.textStyle2,),
            value: _createProjectPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createProjectPermission = permission;
              });
            },
            secondary: new Icon(
              Icons.work, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Create Role', style: TodoColors.textStyle2,),
            value: _createRolePermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createRolePermission = permission;
              });
            },
            secondary: new Icon(
              Icons.library_add, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Create Tag', style: TodoColors.textStyle2,),
            value: _createTagPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createTagPermission = permission;
              });
            },
            secondary: new Icon(
              Icons.title, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Create Device', style: TodoColors.textStyle2,),
            value: _createDevicePermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createDevicePermission = permission;
              });
            },
            secondary: new Icon(
              Icons.devices, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Grant Permission', style: TodoColors.textStyle2,),
            value: _grantUserPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _grantUserPermission = permission;
              });
            },
            secondary: new Icon(
              LineAwesomeIcons.thumbsUp,
              color: TodoColors.baseColors[_colorIndex], size: 30.0,),
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
                  _roleNameController.clear();
                  setState(() {
                    _createUserPermission = false;
                    _createProjectPermission = false;
                    _createRolePermission = false;
                    _createTagPermission = false;
                    _createDevicePermission = false;
                    _grantUserPermission = false;
                  });
                },
              ),
              RaisedButton(
                child: Text(_connectionStatus == 'ConnectivityResult.none' ? 'Not Connected'
                    :'CREATE'),
                textColor: _connectionStatus == 'ConnectivityResult.none' ? Colors.redAccent : TodoColors.baseColors[_colorIndex],
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: _connectionStatus == 'ConnectivityResult.none' ? () => onTap() :() {
                  if (_roleNameController.value.text.trim() != "") {
      if(!allFalse(changed)) {
        Map<String, Object> role_data = <String, Object>{
          'roleName': roleName,
          'canCreateUser': _createUserPermission,
          'canCreateProject': _createProjectPermission,
          'canCreateTag':_createTagPermission,
          'canCreateRole':_createRolePermission,
          'canCreateDevice': _createDevicePermission,
          'canGrantPermission':_grantUserPermission,
        };

        Firestore.instance.runTransaction((transaction) async {
          CollectionReference reference =
          Firestore.instance.collection('roles').reference();
          await reference.add(role_data);
        });
      }

      _roleNameController.clear();
      setState(() {
        _createUserPermission = false;
        _createProjectPermission = false;
        _createRolePermission = false;
        _createTagPermission = false;
        _createDevicePermission = false;
        _grantUserPermission = false;
      });
      showInSnackBar(
      "Role Created Successfully", TodoColors.baseColors[_colorIndex]);
      
                  } else {
                    showInSnackBar(
                        "Please Specify A Value For Role Name",
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
    _connectivitySubscription.cancel();
    super.dispose();
  }
    
      @override
      Widget build(BuildContext context) {
    try {
      return new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('roles').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Center(
                  child: new BarLoadingScreen()
              );
            } else {
              final converter = _buildListItem(
                  context, snapshot.data.documents.first);

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
    } catch(_){
      return Container(child: Text("Presence Of Malformed Data In Database",),);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  void onTap(){
    showInSnackBar(
        "You Need To Be Connected To Create A New Role", Colors.red);
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}
