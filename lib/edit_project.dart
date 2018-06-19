import 'profile_icons.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_project_actions.dart';


class EditProjectPage extends StatefulWidget {
  @override
  EditProjectPageState createState() => EditProjectPageState();
}

class EditProjectPageState extends State<EditProjectPage> {
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');
  final _projectDescription = GlobalKey(debugLabel: 'Project Description');

  bool _sendRequestToAvailableUsers = false;
  List<String> _mTags = new List<String>();
  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems, _roleMenuItems;
  String dropdown2Value;
  String _value = null;
  String dropdown3Value = 'Four';
  List devices = [
    "iPad",
    "Microphone",
    "Dictaphone",
    "Phone",
  ];
  List<String> locations = [" Locations", " Gasabo", " Remera", " Kisimenti", " Gaculiro", " Kacyiru"];
  List<String> tags = ["Tags", "Over18", "Male", "Female", "Education", "Sensitive"];
  List<String> roles = ["Project Staff Roles", "Enumerator", "Project Lead", "Project Supervisor", "Administrator"];
  String _tagValue, _locationValue, _roleValue;
  int _colorIndex = 0;

  List devices_values = [false, false, false, false];
  List<Color> _mcolors = [
    Colors.brown[500], Colors.brown[500], Colors.brown[500], Colors.brown[500]];

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(0, locations);
    _createDropdownMenuItems(1, tags);
    _createDropdownMenuItems(2, roles);
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
      _locationValue = locations[0];
      _tagValue = tags[0];
      _roleValue = roles[0];
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
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: currentValue,
              items: (idx == 0) ? _locationMenuItems : (idx == 1) ? _tagMenuItems : _roleMenuItems,
              onChanged: onChanged,
              style: TodoColors.textStyle2,
          ),
        ),
      ),
    );
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
              style: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
            ),
          ],
        ),

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
        _createDropdown(0, _locationValue, _updateLocationValue),

        RaisedButton(
          child: Text('ADD LOCATION'),
          textColor: TodoColors.baseColors[_colorIndex],
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_locationValue != "Locations") {
              _locationValue = "Locations";
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

        RaisedButton(
          child: Text('ADD TAG'),
          textColor: TodoColors.baseColors[_colorIndex],
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_tagValue != "Tags") {
              _tagValue = "Tags";
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
          children: new List.generate(devices.length, (i) =>
          new InkWell(
            onTap: () {
              setState(() {
                if (_mcolors[i] == Colors.brown[500]) {
                  _mcolors[i] = TodoColors.baseColors[_colorIndex];
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
          child: Text('ADD DEVICES TO ROLE'),
          textColor: TodoColors.baseColors[_colorIndex],
          elevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            if (_roleValue != "Project Staff Roles" && !areAllBrown(_mcolors)) {
              _roleValue = "Project Staff Roles";
              setState(() {
                for (int i = 0; i < _mcolors.length; i++) {
                  _mcolors.removeAt(i);
                  _mcolors.insert(i, Colors.brown[500]);
                }
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
                if (_projectTitleController.value.text.trim() != "" &&
                    _projectDescriptionController.value.text.trim() != "") {
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
