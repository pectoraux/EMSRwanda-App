import 'profile_icons.dart';
import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_project_actions.dart';
import 'profile_fonts.dart';


class EditProjectPage extends StatefulWidget {
  @override
  EditProjectPageState createState() => EditProjectPageState();
}

class EditProjectPageState extends State<EditProjectPage> {
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _projectLocationsController = TextEditingController();
  final _projectTagsController = TextEditingController();
  final _projectStaffRolesController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');
  final _projectDescription = GlobalKey(debugLabel: 'Project Description');
  final _projectLocations = GlobalKey(debugLabel: 'Project Locations');
  final _projectTags = GlobalKey(debugLabel: 'Project Tags');
  final _card = GlobalKey(debugLabel: 'Card');
  final _projectStaffRoles = GlobalKey(debugLabel: 'Project Staff Roles');
  final _padding = EdgeInsets.all(5.0);
  bool _sendRequestToAvailableUsers = false;
  List<String> _mTags = new List<String>();
  List<DropdownMenuItem> _unitMenuItems;
  String dropdown2Value;
  String _value = null;
  String dropdown3Value = 'Four';
  List devices = [
    "iPad",
    "Microphone",
    "Dictaphone",
    "Phone",
  ];
  List devices_values = [false, false, false, false];
  List<Color> _mcolors = [
    Colors.brown[500], Colors.brown[500], Colors.brown[500], Colors.brown[500]];


  @override
  Widget build(BuildContext context) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        new QuickProjectActions(),

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            Image.asset('assets/diamond.png'),
            SizedBox(height: 16.0),
            Text(
              'Create A New Project',
              style: TodoColors.textStyle,
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,

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
          color: TodoColors.accent,

          child: TextField(
            key: _projectDescription,
            controller: _projectDescriptionController,
            decoration: InputDecoration(
              labelText: 'Project Description',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        const SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,

          child: TextField(
            key: _projectLocations,
            controller: _projectLocationsController,
            decoration: InputDecoration(
              helperText: _projectLocationsController.value.text,
              labelText: 'Project Location',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        RaisedButton(
          child: Text('ADD LOCATION'),
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_projectLocationsController.value.text.trim() != "") {
              _projectLocationsController.clear();
              showInSnackBar("Location Added Successfully", TodoColors.accent);
            } else {
              showInSnackBar(
                  "Please Specify A Location Before Clicking This Button",
                  Colors.redAccent);
            }
          },
        ),

        const SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,

          child: TextField(
            key: _projectTags,
            controller: _projectTagsController,
            decoration: InputDecoration(
              labelText: 'Project Tag',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        RaisedButton(
          child: Text('ADD TAG'),
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_projectTagsController.value.text.trim() != "") {
              _projectTagsController.clear();
              showInSnackBar("Tag Added Successfully", TodoColors.accent);
            } else {
              showInSnackBar("Please Specify A Tag Before Clicking This Button",
                  Colors.redAccent);
            }
          },
        ),

        const SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _projectStaffRoles,
            controller: _projectStaffRolesController,
            decoration: InputDecoration(
              labelText: 'Project Staff Roles',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        const SizedBox(height: 12.0),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          children: new List.generate(devices.length, (i) =>
          new InkWell(
            onTap: () {
              setState(() {
                if (_mcolors[i] == Colors.brown[500]) {
                  _mcolors[i] = TodoColors.baseColors[0];
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
                child: new Center(child: new Text(devices[i])),
              ),
            ),
          ),
          ),

        ),

        const SizedBox(height: 12.0),
        RaisedButton(
          child: Text('ADD'),
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_projectStaffRolesController.value.text.trim() != "") {
              _projectStaffRolesController.clear();
              setState(() {
                for (int i = 0; i < _mcolors.length; i++) {
                  _mcolors.removeAt(i);
                  _mcolors.insert(i, Colors.brown[500]);
                }
              });
              showInSnackBar(
                  "Devices Added Successfully To Role", TodoColors.accent);
            } else {
              showInSnackBar(
                  "Please Specify A Role and At Least One Device Before Clicking This Button",
                  Colors.redAccent);
            }
          },
        ),

        const SizedBox(height: 24.0),


        const SizedBox(height: 12.0),
        new CheckboxListTile(
          title: Text('Send Requests', style: TodoColors.textStyle2,),
          value: _sendRequestToAvailableUsers,
          onChanged: (bool permission) {
            setState(() {
              _sendRequestToAvailableUsers = permission;
            });
          },
          secondary: new Icon(
            LineAwesomeIcons.user, color: TodoColors.accent, size: 30.0,),
        ),

        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                _projectTitleController.clear();
                _projectDescriptionController.clear();
                setState(() {
                  _sendRequestToAvailableUsers = false;
                });
              },
            ),

            RaisedButton(
              child: Text('CREATE'),
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                if (_projectTitleController.value.text.trim() != "" &&
                    _projectDescriptionController.value.text.trim() != "") {
                  showInSnackBar(
                      "Project Created Successfully", TodoColors.accent);
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
      return TodoColors.baseColors[0];
    } else {
      return Colors.brown[500];
    }
  }
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}
