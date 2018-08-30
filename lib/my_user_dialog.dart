import 'dart:async';

import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loading_screen.dart';

class MyUserDialog extends StatefulWidget {
  final int colorIndex;

  const MyUserDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyUserDialogState();
}

class MyUserDialogState extends State<MyUserDialog> {
  final _firstNameController = TextEditingController();
  final _firstName = GlobalKey(debugLabel: 'First Name');
  final _lastNameController = TextEditingController();
  final _lastName = GlobalKey(debugLabel: 'Last Name');

  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems, _roleMenuItems, _statusMenuItems;
  List<String> locations = ["Locations", "Kigali Only", "Kigali Upcountry",];
  List<String> tags = ["Tags"];
  List<String> roles = ["Project Staff Roles"];
  List<String> status = ["User Status", "Active", "Busy"];
  String _tagValue, _locationValue, _roleValue, _statusValue;
  Set<String> selectedLocations = new Set(), selectedTags = new Set(), selectedDevices = new Set();

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(0, locations);
    _createDropdownMenuItems(11, status);
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
      } else if (idx == 11) {
        _statusMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _locationValue = locations[0];
      _statusValue = status[0];
    });

    Firestore.instance.collection('tags').getDocuments().asStream()
        .forEach((snap) {
      for (var tag in snap.documents) {
        tags.add(tag['tagName']);
      }
    }).whenComplete((){
      setState(() {
        _createDropdownMenuItems(1, tags);
        _tagValue = tags[0];
      });
    });

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

  onChanged)

  {
    return Container(
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: TodoColors.baseColors[widget.colorIndex],
        border: Border.all(
          color: TodoColors.baseColors[widget.colorIndex],
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
                      items: (idx == 0) ? _locationMenuItems : (idx == 1) ? _tagMenuItems : (idx == 2) ? _roleMenuItems : _statusMenuItems,
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

  void _updateStatusValue(dynamic name) {
    setState(() {
      _statusValue = name;
    });
  }


  Widget build(BuildContext context) {

    try {
      return new AlertDialog(
        title: new Text('Search User',
          style: TodoColors.textStyle.apply(
              color: TodoColors.baseColors[widget.colorIndex]),),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              SizedBox(height: 12.0),
              PrimaryColorOverride(
                color: TodoColors.baseColors[widget.colorIndex],
                child: TextField(
                  key: _firstName,
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),

              SizedBox(height: 12.0),
              PrimaryColorOverride(
                color: TodoColors.baseColors[widget.colorIndex],
                child: TextField(
                  key: _lastName,
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 12.0),
              _createDropdown(2, _roleValue, _updateRoleValue),

              const SizedBox(height: 12.0),
              _createDropdown(11, _statusValue, _updateStatusValue),

//              const SizedBox(height: 12.0),
//              _createDropdown(0, _locationValue, _updateLocationValue),
//              SizedBox(height: 3.0,),
//
//              selectedLocations.isNotEmpty ? SingleChildScrollView(
//                scrollDirection: Axis.horizontal,
//                child: Chip(
//                  backgroundColor: TodoColors.baseColors[widget.colorIndex],
//                  label: new Text(selectedLocations.toString()
//                      .substring(selectedLocations.toString().indexOf('{') + 1,
//                      selectedLocations.toString().indexOf('}'))),
//                ),
//              ) : Container(),
//
//              RaisedButton(
//                child: Text('ADD LOCATION'),
//                textColor: TodoColors.baseColors[widget.colorIndex],
//                elevation: 8.0,
//                shape: BeveledRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                ),
//                onPressed: () {
//                  if (_locationValue != "Locations") {
//                    setState(() {
//                      selectedLocations.add(_locationValue);
//                      _locationValue = locations[0];
//                    });
//                    showInSnackBar("Location Added Successfully",
//                        TodoColors.baseColors[widget.colorIndex]);
//                  } else {
//                    showInSnackBar(
//                        "Please Specify A Location Before Clicking This Button",
//                        Colors.redAccent);
//                  }
//                },
//              ),
//              const SizedBox(height: 12.0),
//              _createDropdown(1, _tagValue, _updateTagValue),
//
//              SizedBox(height: 3.0,),
//              selectedTags.isNotEmpty ? SingleChildScrollView(
//                scrollDirection: Axis.horizontal,
//                child: Chip(
//                  backgroundColor: TodoColors.baseColors[widget.colorIndex],
//                  label: new Text(selectedTags.toString()
//                      .substring(selectedTags.toString().indexOf('{') + 1,
//                      selectedTags.toString().indexOf('}'))),
//                ),
//              ) : Container(),
//
//              SizedBox(height: 3.0,),
//              RaisedButton(
//                child: Text('ADD TAG'),
//                textColor: TodoColors.baseColors[widget.colorIndex],
//                elevation: 8.0,
//                shape: BeveledRectangleBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
//                ),
//                onPressed: () {
//                  if (_tagValue != "Tags") {
//                    setState(() {
//                      selectedTags.add(_tagValue);
//                      _tagValue = tags[0];
//                    });
//
//                    showInSnackBar("Tag Added Successfully",
//                        TodoColors.baseColors[widget.colorIndex]);
//                  } else {
//                    showInSnackBar(
//                        "Please Specify A Tag Before Clicking This Button",
//                        Colors.redAccent);
//                  }
//                },
//              ),
              SizedBox(height: 12.0,),
            ],
          ),

        ),

        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            textColor: TodoColors.baseColors[widget.colorIndex],
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          RaisedButton(
            child: Text('SEARCH'),
            textColor: TodoColors.baseColors[widget.colorIndex],
            elevation: 8.0,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () {
              Map<String, Object> search_data = <String, Object>{};
              if (_firstNameController.value.text.trim() != "") {
                search_data['firstName'] = _firstNameController.value.text;
              }
              if (_lastNameController.value.text.trim() != "") {
                search_data['lastName'] = _lastNameController.value.text;
              }
              if (_roleValue != "Project Staff Roles") {
                search_data['userRole'] = _roleValue;
              }
              if (_statusValue != "User Status") {
                search_data['userStatus'] = _statusValue;
              }
//              if (selectedLocations.isNotEmpty) {
//                search_data['locations'] = selectedLocations;
//              }
//              if (selectedTags.isNotEmpty) {
//                search_data['tags'] = selectedTags;
//              }
              Navigator.of(context).pop([search_data]);
            },
          ),

        ],
      );
    } catch(_){
      return BarLoadingScreen();
    }
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

