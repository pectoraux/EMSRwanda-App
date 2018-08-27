import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'date_and_time_picker.dart';
import 'profile_icons.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_project_actions.dart';
import 'color_override.dart';
import 'animated_logo.dart';
import 'loading_screen.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

class EditProjectPage extends StatefulWidget {
  EditProjectPage({Key key, this.roles, this.tags, this.devices}) : super(key: key);
  final List<String> roles;
  final List<String> tags;
  final List<String> devices;
//  static int len;
  @override
  EditProjectPageState createState() => EditProjectPageState();
}

class EditProjectPageState extends State<EditProjectPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _teamCountController = TextEditingController();
  final _staffCountController = TextEditingController();
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');
  final _staffCount = GlobalKey(debugLabel: 'Staff Count');
  final _teamCount = GlobalKey(debugLabel: 'Team Count');
  final _myProjectDescription = GlobalKey(debugLabel: 'Project Description');
  static final formKey = new GlobalKey<FormState>();
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();


  bool _sendRequestToAvailableUsers = false;
  String dropdown2Value;
  String _value = null;
  String dropdown3Value = 'Four';
  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems, _roleMenuItems;
  List<String> locations = ["Locations", "Kigali Only", "Kigali Upcountry",];
  String _tagValue, _locationValue, _roleValue;
  int _colorIndex = 0;
  Set<String> selectedLocations = new Set(), selectedTags = new Set(), selectedDevices = new Set();
  Map<String, Object> devicesWithRole = new Map<String, Object>();
  List devices_values;
  List<Color> _mcolors;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
    _createDropdownMenuItems(0, locations);
    _createDropdownMenuItems(1, widget.tags);
    _createDropdownMenuItems(2, widget.roles);
    _setDefaults();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
        });

    _fromDate = new DateTime.now();
    _toDate = new DateTime.now();
  }

  /// Creates fresh list of [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems(int idx, List<String> list) {
    var newItems = <DropdownMenuItem>[];
    for (var unit in list) {
      newItems.add(DropdownMenuItem(
        value: unit,
        child: Container(
          child: Text(
            'unit',
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      if(idx == 0) { //if location drop down
        _locationMenuItems = newItems;
      } else if (idx == 1){
        _tagMenuItems = newItems;
      } else if (idx == 2) {
        _roleMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      devices_values = List<bool>.generate(widget.devices.toSet().length, (int index) => (false));
      _mcolors = List<Color>.generate(widget.devices.toSet().length, (int index) => (Colors.brown[500]));
      _locationValue = locations[0];
      _tagValue = widget.tags[0];
      _roleValue = widget.roles[0];
    });
  }

  Widget _createDropdown(int idx, String currentValue, ValueChanged<dynamic>

  onChanged)

  {
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
              items: (idx == 0) ? _locationMenuItems : (idx == 1) ? _tagMenuItems : _roleMenuItems,
              onChanged: onChanged,
              style: TodoColors.textStyle2,
          ),]
            ),),
    ),
      ),
    ),);
  }

  void _updateLocationValue(dynamic name) {
    setState(() {
  _locationValue = name;
    });
  }

  void _updateTagValue(dynamic name) {
    setState(() {
      _tagValue = name;
    });
  }

  void _updateRoleValue(dynamic name) {
    setState(() {
      _roleValue = name;
    });
  }

  bool areAllBrown(List<Color> list){
    for (int i = 0; i < list.length; i++) {
      if (list[i] != Colors.brown[500]){
        return false;
      }
    }
    return true;
  }


    Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        new QuickProjectActions(roles: widget.roles, tags: widget.tags, devices: widget.devices,),

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            AnimatedLogo(animation: animation, message: 'Create A New Project', factor: 1.0, colorIndex: _colorIndex,),
          ],
        ),

//        Form(
//        key: formKey,
//        child: new Column(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children:<Widget>[
//        SizedBox(height: 12.0),
//        PrimaryColorOverride(
//          color: TodoColors.baseColors[_colorIndex],
//          child: TextField(
//            key: _projectTitle,
//            controller: _projectTitleController,
//            decoration: InputDecoration(
//              labelText: 'Project Title',
//              labelStyle: TodoColors.textStyle2,
//              border: CutCornersBorder(),
//            ),
//          ),
//        ),
//
//
//        const SizedBox(height: 12.0),
//        PrimaryColorOverride(
//          color: TodoColors.baseColors[_colorIndex],
//          child: TextField(
//            key: _myProjectDescription,
//            maxLines: null,
//            controller: _projectDescriptionController,
//            decoration: InputDecoration(
//              labelText: 'Project Description',
//              labelStyle: TodoColors.textStyle2,
//              border: CutCornersBorder(),
//            ),
//          ),
//        ),
//
//        SizedBox(height: 12.0),
//        PrimaryColorOverride(
//          color: TodoColors.baseColors[_colorIndex],
//          child: TextField(
//            key: _staffCount,
//            controller: _staffCountController,
//            decoration: InputDecoration(
//              labelText: 'Number of Employees on Project',
//              labelStyle: TodoColors.textStyle2,
//              border: CutCornersBorder(),
//            ),
//          ),
//        ),
//
//        SizedBox(height: 12.0),
//        PrimaryColorOverride(
//          color: TodoColors.baseColors[_colorIndex],
//          child: TextField(
//            key: _teamCount,
//            controller: _teamCountController,
//            decoration: InputDecoration(
//              labelText: 'Number of Employees per Team',
//              labelStyle: TodoColors.textStyle2,
//              border: CutCornersBorder(),
//            ),
//          ),
//        ),
//
//        const SizedBox(height: 12.0),
//        _createDropdown(0, _locationValue, _updateLocationValue),
//
//        SizedBox(height: 3.0,),
//
//       selectedLocations.isNotEmpty? SingleChildScrollView(
//          scrollDirection: Axis.horizontal,
//      child: Chip(
//        backgroundColor: TodoColors.baseColors[_colorIndex],
//      label: new Text(selectedLocations.toString()
//          .substring(selectedLocations.toString().indexOf('{')+1, selectedLocations.toString().indexOf('}'))),
//      ),
//      ):Container(),
//        SizedBox(height: 3.0,),
//        RaisedButton(
//          child: Text('ADD LOCATION'),
//          textColor: TodoColors.baseColors[_colorIndex],
//          elevation: 6.0,
//          shape: BeveledRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//          ),
//          onPressed: () {
//            if (_locationValue != "Locations") {
//              setState(() {
//                selectedLocations.add(_locationValue);
//                _locationValue = locations[0];
//              });
//              showInSnackBar("Location Added Successfully", TodoColors.baseColors[_colorIndex]);
//            } else {
//              showInSnackBar(
//                  "Please Specify A Location Before Clicking This Button",
//                  Colors.redAccent);
//            }
//          },
//        ),
//
//        const SizedBox(height: 12.0),
//        _createDropdown(1, _tagValue, _updateTagValue),
//
//        SizedBox(height: 3.0,),
//        selectedTags.isNotEmpty? SingleChildScrollView(
//          scrollDirection: Axis.horizontal,
//          child: Chip(
//            backgroundColor: TodoColors.baseColors[_colorIndex],
//            label: new Text(selectedTags.toString()
//                .substring(selectedTags.toString().indexOf('{')+1, selectedTags.toString().indexOf('}'))),
//          ),
//        ):Container(),
//        SizedBox(height: 3.0,),
//
//        RaisedButton(
//          child: Text('ADD TAG'),
//          textColor: TodoColors.baseColors[_colorIndex],
//          elevation: 6.0,
//          shape: BeveledRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//          ),
//          onPressed: () {
//            if (_tagValue != "Tags") {
//              setState(() {
//                selectedTags.add(_tagValue);
//                _tagValue = widget.tags[0];
//              });
//
//              showInSnackBar("Tag Added Successfully", TodoColors.baseColors[_colorIndex]);
//            } else {
//              showInSnackBar("Please Specify A Tag Before Clicking This Button",
//                  Colors.redAccent);
//            }
//          },
//        ),
//
//        const SizedBox(height: 12.0),
//        _createDropdown(2, _roleValue, _updateRoleValue),
//
//        GridView.count(
//          shrinkWrap: true,
//          crossAxisCount: 3,
//          children: new List.generate(widget.devices.toSet().length, (i) =>
//          new InkWell(
//            onTap: () {
//              setState(() {
//                if (_mcolors[i] == Colors.brown[500]) {
//                  _mcolors[i] = TodoColors.baseColors[_colorIndex];
//                  selectedDevices.add(widget.devices.toSet().elementAt(i));
//                } else {
//                  _mcolors[i] = Colors.brown[500];
//                }
//              });
//            },
//            child: new Card(
//              elevation: 15.0,
//              color: _mcolors[i],
//              child: new Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: new Center(child: new Text(widget.devices.toSet().elementAt(i))),
//              ),
//            ),
//          ),
//          ),
//
//        ),
//        SizedBox(height: 3.0,),
//        devicesWithRole.isNotEmpty? SingleChildScrollView(
//          scrollDirection: Axis.horizontal,
//          child: Chip(
//            backgroundColor: TodoColors.baseColors[_colorIndex],
//            label: new Text(devicesWithRole.toString()),
//          ),
//        ):Container(),
//        SizedBox(height: 3.0,),
//        const SizedBox(height: 12.0),
//        RaisedButton(
//          child: Text('ADD DEVICES TO ROLE'),
//          textColor: TodoColors.baseColors[_colorIndex],
//          elevation: 6.0,
//          shape: BeveledRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(7.0)),
//          ),
//          onPressed: () {
//            if (_roleValue != "Project Staff Roles" && !areAllBrown(_mcolors)) {
//
//              setState(() {
//                for (int i = 0; i < _mcolors.length; i++) {
//                    _mcolors.removeAt(i);
//                  _mcolors.insert(i, Colors.brown[500]);
//                }
//                devicesWithRole.addAll({_roleValue: selectedDevices});
//                _roleValue = widget.roles[0];
//                selectedDevices = new Set();
//              });
//              showInSnackBar(
//                  "Device(s) Added Successfully To Role", TodoColors.baseColors[_colorIndex]);
//            } else {
//              showInSnackBar(
//                  "Please Specify A Role and At Least One Device Before Clicking This Button",
//                  Colors.redAccent);
//            }
//          },
//        ),
//
//        SizedBox(height: 12.0),
//        DatePicker(
//          labelText: 'Start Date',
//          selectedDate: _fromDate,
//          selectDate: (DateTime date) {
//            setState(() {
//              _fromDate = date;
//            });
//          },
//        ),
//
//        SizedBox(height: 12.0),
//        PrimaryColorOverride(
//          color: TodoColors.baseColors[_colorIndex],
//          child: DatePicker(
//            labelText: 'End Date',
//            selectedDate: _toDate,
//            selectDate: (DateTime date) {
//              setState(() {
//                _toDate = date;
//              });
//            },
//          ),
//        ),
//        const SizedBox(height: 12.0),
//        new CheckboxListTile(
//          title: Text('Send Requests', style: TodoColors.textStyle2,),
//          value: _sendRequestToAvailableUsers,
//          activeColor: TodoColors.baseColors[_colorIndex],
//          onChanged: (bool permission) {
//            setState(() {
//              _sendRequestToAvailableUsers = permission;
//            });
//          },
//          secondary: new Icon(
//            LineAwesomeIcons.user, color: TodoColors.baseColors[_colorIndex], size: 30.0,),
//        ),
//
//
//        ButtonBar(
//          children: <Widget>[
//            FlatButton(
//              child: Text('CANCEL'),
//              textColor: TodoColors.baseColors[_colorIndex],
//              shape: BeveledRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(7.0)),
//              ),
//              onPressed: () {
//                _projectTitleController.clear();
//                _projectDescriptionController.clear();
//                setState(() {
//                  _sendRequestToAvailableUsers = false;
//                  _roleValue = widget.roles[0];
//                  _tagValue = widget.tags[0];
//                  _locationValue = locations[0];
//                });
//              },
//            ),
//
//            RaisedButton(
//              child: Text(_connectionStatus == 'ConnectivityResult.none' ? 'Not Connected'
//                  :'CREATE'),
//              textColor: _connectionStatus == 'ConnectivityResult.none' ? Colors.redAccent :TodoColors.baseColors[_colorIndex],
//              elevation: 8.0,
//              shape: BeveledRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(7.0)),
//              ),
//              onPressed: _connectionStatus == 'ConnectivityResult.none' ? () => onTap2() :()  async {
//
//                if (_projectTitleController.text.trim() != "" &&
//                    _projectDescriptionController.text.trim() != "" &&
//                    _teamCountController.text.trim() != "" &&
//                    _staffCountController.text.trim() != "" &&
//                    _fromDate.isBefore(_toDate) && _toDate.isAfter(DateTime.now())) {
//                  String muid = (await _auth.currentUser()).uid;
//                  Map<String, Object> project_data = <String, Object>{
//                    'projectTitle': _projectTitleController.text,
//                    'projectDescription': _projectDescriptionController.text,
//                    'locations':selectedLocations.toList(),
//                    'tags': selectedTags.toList(),
//                    'devicesPerRole': devicesWithRole.toString(),
//                    'author': muid,
//                    'startDate': _fromDate,
//                    'endDate': _toDate,
//                    'staffCount': _staffCountController.text,
//                    'teamCount': _teamCountController.text,
//                    'currentGroup': 0,
//                    'currentGroupCount': 0,
//                  };
//                  Firestore.instance.runTransaction((transaction) async {
//                    DocumentReference reference = Firestore.instance.collection('projects').document();
//                    await transaction.set(reference, project_data);
//                    DocumentReference userRef2 = Firestore.instance.document('users/${muid}/projects/${reference.documentID}');
//                    await userRef2.setData({});
//                    DocumentReference userRef = Firestore.instance.document(
//                        'projects/${reference.documentID}/users/${muid}');
//                    await userRef.setData({
//                      'comments': [],
//                      'communicationRating': -1.0,
//                      'initiativeTakingRating': -1.0,
//                      'overAllRating': -1.0,
//                      'punctualityRating': -1.0,
//                      'reportingRating': -1.0,
//                      'userGroup': -1,
//                    });
//                  });
//                  _projectTitleController.clear();
//                  _projectDescriptionController.clear();
//                  _staffCountController.clear();
//                  _teamCountController.clear();
//                  _fromDate = DateTime.now();
//                  _toDate = DateTime.now();
//                  selectedLocations = new Set();
//                  selectedTags = new Set();
//                  devicesWithRole = new Map<String, Object>();
//                  selectedDevices = new Set();
//                  showInSnackBar(
//                      "Project Created Successfully", TodoColors.baseColors[_colorIndex]);
//                } else {
//                  showInSnackBar("Please Specify A Value For All Fields And Check All Fields",
//                      Colors.redAccent);
//                }
//              },
//            ),
//          ],
//        ),
//      ])),
      ],
    );

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

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }

  Color onTap(BuildContext context, Color c) {
    if (c == Colors.brown[500]) {
      return TodoColors.baseColors[_colorIndex];
    } else {
      return Colors.brown[500];
    }
  }

  dispose() {
    controller.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('projects').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

  void onTap2(){
    showInSnackBar(
        "You Need To Be Connected To Create A New Project", Colors.red);
  }
}

