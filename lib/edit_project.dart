import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_icons.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_project_actions.dart';
import 'color_override.dart';
import 'animated_logo.dart';

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


  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');
  final _myProjectDescription = GlobalKey(debugLabel: 'Project Description');
  static final formKey = new GlobalKey<FormState>();

  bool _sendRequestToAvailableUsers = false;
  String dropdown2Value;
  String _value = null;
  String dropdown3Value = 'Four';
//  List devices = [
//    "iPad",
//    "Microphone",
//    "Dictaphone",
//    "Phone",
//  ];
  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems, _roleMenuItems;
  List<String> locations = ["Locations", "Gasabo", "Remera", "Kisimenti", "Gaculiro", "Kacyiru"];
//  List<String> tags = ["Tags", "Over18", "Male", "Female", "Education", "Sensitive"];
//  List<String> roles = ["Project Staff Roles", "Enumerator", "Project Lead", "Project Supervisor", "Administrator"];
  String _tagValue, _locationValue, _roleValue;
  int _colorIndex = 0;
  Set<String> selectedLocations = new Set(), selectedTags = new Set(), selectedDevices = new Set();
  Map<String, Object> devicesWithRole = new Map<String, Object>();
//  static int len = widget.len;
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
      devices_values = List<bool>.generate(widget.devices.length, (int index) => (false));
      _mcolors = List<Color>.generate(widget.devices.length, (int index) => (Colors.brown[500]));
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
        new QuickProjectActions(),

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            AnimatedLogo(animation: animation, message: 'Create A New Project', factor: 1.0, colorIndex: _colorIndex,),
          ],
        ),

        Form(
        key: formKey,
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:<Widget>[
        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _projectTitle,
            controller: _projectTitleController,
            decoration: InputDecoration(
              labelText: 'Project Title',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),


        const SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _myProjectDescription,
            maxLines: null,
            controller: _projectDescriptionController,
            decoration: InputDecoration(
              labelText: 'Project Description',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        const SizedBox(height: 12.0),
        _createDropdown(0, _locationValue, _updateLocationValue),

        SizedBox(height: 3.0,),

       selectedLocations.isNotEmpty? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
      child: Chip(
        backgroundColor: TodoColors.baseColors[_colorIndex],
      label: new Text(selectedLocations.toString()
          .substring(selectedLocations.toString().indexOf('{')+1, selectedLocations.toString().indexOf('}'))),
      ),
      ):Container(),
        SizedBox(height: 3.0,),
        RaisedButton(
          child: Text('ADD LOCATION'),
          textColor: TodoColors.baseColors[_colorIndex],
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_locationValue != "Locations") {
              setState(() {
                selectedLocations.add(_locationValue);
                _locationValue = locations[0];
              });
              showInSnackBar("Location Added Successfully", TodoColors.baseColors[_colorIndex]);
            } else {
              showInSnackBar(
                  "Please Specify A Location Before Clicking This Button",
                  Colors.redAccent);
            }
          },
        ),

        const SizedBox(height: 12.0),
        _createDropdown(1, _tagValue, _updateTagValue),

        SizedBox(height: 3.0,),
        selectedTags.isNotEmpty? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Chip(
            backgroundColor: TodoColors.baseColors[_colorIndex],
            label: new Text(selectedTags.toString()
                .substring(selectedTags.toString().indexOf('{')+1, selectedTags.toString().indexOf('}'))),
          ),
        ):Container(),
        SizedBox(height: 3.0,),

        RaisedButton(
          child: Text('ADD TAG'),
          textColor: TodoColors.baseColors[_colorIndex],
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_tagValue != "Tags") {
              setState(() {
                selectedTags.add(_tagValue);
                _tagValue = widget.tags[0];
              });

              showInSnackBar("Tag Added Successfully", TodoColors.baseColors[_colorIndex]);
            } else {
              showInSnackBar("Please Specify A Tag Before Clicking This Button",
                  Colors.redAccent);
            }
          },
        ),

        const SizedBox(height: 12.0),
        _createDropdown(2, _roleValue, _updateRoleValue),

        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          children: new List.generate(widget.devices.length, (i) =>
          new InkWell(
            onTap: () {
              setState(() {
                if (_mcolors[i] == Colors.brown[500]) {
                  _mcolors[i] = TodoColors.baseColors[_colorIndex];
                  selectedDevices.add(widget.devices[i]);
                } else {
                  _mcolors[i] = Colors.brown[500];
                }
              });
            },
            child: new Card(
              elevation: 15.0,
              color: _mcolors[i],
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Center(child: new Text(widget.devices[i])),
              ),
            ),
          ),
          ),

        ),
        SizedBox(height: 3.0,),
        devicesWithRole.isNotEmpty? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Chip(
            backgroundColor: TodoColors.baseColors[_colorIndex],
            label: new Text(devicesWithRole.toString()),
          ),
        ):Container(),
        SizedBox(height: 3.0,),
        const SizedBox(height: 12.0),
        RaisedButton(
          child: Text('ADD DEVICES TO ROLE'),
          textColor: TodoColors.baseColors[_colorIndex],
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_roleValue != "Project Staff Roles" && !areAllBrown(_mcolors)) {

              setState(() {
                for (int i = 0; i < _mcolors.length; i++) {
                    _mcolors.removeAt(i);
                  _mcolors.insert(i, Colors.brown[500]);
                }
                devicesWithRole.addAll({_roleValue: selectedDevices});
                _roleValue = widget.roles[0];
                selectedDevices = new Set();
              });
              showInSnackBar(
                  "Device(s) Added Successfully To Role", TodoColors.baseColors[_colorIndex]);
            } else {
              showInSnackBar(
                  "Please Specify A Role and At Least One Device Before Clicking This Button",
                  Colors.redAccent);
            }
          },
        ),

        const SizedBox(height: 12.0),
        new CheckboxListTile(
          title: Text('Send Requests', style: TodoColors.textStyle2,),
          value: _sendRequestToAvailableUsers,
          activeColor: TodoColors.baseColors[_colorIndex],
          onChanged: (bool permission) {
            setState(() {
              _sendRequestToAvailableUsers = permission;
            });
          },
          secondary: new Icon(
            LineAwesomeIcons.user, color: TodoColors.baseColors[_colorIndex], size: 30.0,),
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
                _projectTitleController.clear();
                _projectDescriptionController.clear();
                setState(() {
                  _sendRequestToAvailableUsers = false;
                  _roleValue = widget.roles[0];
                  _tagValue = widget.tags[0];
                  _locationValue = locations[0];
                });
              },
            ),

            RaisedButton(
              child: Text('CREATE'),
              textColor: TodoColors.baseColors[_colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
//                _projectTitleController.text.trim() != "" &&
//                    _projectDescriptionController.text.trim() != ""
                if (true) {
                  Map<String, Object> project_data = <String, Object>{
                    'projectTitle': _projectTitleController.text,
                    'projectDescription': _projectDescriptionController.text,
                    'locations':selectedLocations.toList(),
                    'tags': selectedTags.toList(),
                    'devicesPerRole': devicesWithRole.toString(),
                  };

                  Firestore.instance.runTransaction((transaction) async {
                    CollectionReference reference =
                    Firestore.instance.collection('projects').reference();
                    await reference.add(project_data);
                  });
                  _projectTitleController.clear();
                  _projectDescriptionController.clear();
                  selectedLocations = new Set();
                  selectedTags = new Set();
                  devicesWithRole = new Map<String, Object>();
                  selectedDevices = new Set();

                  showInSnackBar(
                      "Project Created Successfully", TodoColors.baseColors[_colorIndex]);
                } else {
                  showInSnackBar("Please Specify A Value For All Fields",
                      Colors.redAccent);
                }
              },
            ),
          ],
        ),
      ])),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('projects').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new CircularProgressIndicator()
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
}

