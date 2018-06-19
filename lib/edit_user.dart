import 'package:flutter/material.dart';
import 'color_override.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_user_actions.dart';


class EditUserPage extends StatefulWidget {
  @override
  EditUserPageState createState() => EditUserPageState();
}

class EditUserPageState extends State<EditUserPage> {
  final _userNameController = TextEditingController();
  final _userRoleController = TextEditingController();
  final _userName = GlobalKey(debugLabel: 'User Name');
  final _userRole = GlobalKey(debugLabel: 'User Role');
  final _userPassword = GlobalKey(debugLabel: 'User Password');
  int _colorIndex = 0;
  List<String> roles = ["Project Staff Roles", "Enumerator", "Project Lead", "Project Supervisor", "Administrator"];
  List<DropdownMenuItem> _roleMenuItems;
  String _roleValue;

  @override
  void initState() {
    super.initState();
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
      if (idx == 2) {
        _roleMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        new QuickUserActions(),

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            Image.asset('assets/diamond.png'),
            SizedBox(height: 16.0),
            Text(
              'Create A New User',
              style: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _userName,
            controller: _userNameController,
            decoration: InputDecoration(
              labelText: 'User Name',
              border: CutCornersBorder(),
            ),
          ),
        ),

        const SizedBox(height: 12.0),
        _createDropdown(2, _roleValue, _updateRoleValue),

        SizedBox(height: 12.0),
        InputDecorator(
          key: _userPassword,
          child: Text(
            "Laterite",
            style: TodoColors.textStyle2,
          ),
          decoration: InputDecoration(
            labelText: 'User Password',
            labelStyle: TodoColors.textStyle2,
            border: CutCornersBorder(),
          ),
        ),

        const SizedBox(height: 12.0),


        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              textColor: TodoColors.baseColors[_colorIndex],
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                _userNameController.clear();
                _userRoleController.clear();
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
                if (_userNameController.value.text.trim() != "" &&
                    _roleValue != "Project Staff Roles") {
                  setState(() {
                    _roleValue = "Project Staff Roles";
                    _userNameController.clear();
                  });
                  showInSnackBar(
                      "User Created Successfully", TodoColors.baseColors[_colorIndex]);
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
}

