import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';

class MyUserDialog extends StatefulWidget {
  final int colorIndex;

  const MyUserDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyUserDialogState();
}

class MyUserDialogState extends State<MyUserDialog> {
  final _userNameController = TextEditingController();
  final _userName = GlobalKey(debugLabel: 'User Name');
  final _userRoleController = TextEditingController();
  final _userRole = GlobalKey(debugLabel: 'User Role');
  final _userStatusController = TextEditingController();
  final _userStatus = GlobalKey(debugLabel: 'User Status');
  final _userLocationsController = TextEditingController();
  final _tagsController = TextEditingController();
  final _userLocations = GlobalKey(debugLabel: 'Users Locations');
  final _tags = GlobalKey(debugLabel: 'Project or User Related Tags');

  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems, _roleMenuItems, _statusMenuItems;
  List<String> locations = [" Locations", " Gasabo", " Remera", " Kisimenti", " Gaculiro", " Kacyiru"];
  List<String> tags = ["Tags", "Over18", "Male", "Female", "Education", "Sensitive"];
  List<String> roles = ["Project Staff Roles", "Enumerator", "Project Lead", "Project Supervisor", "Administrator"];
  List<String> status = ["User Status", "Active", "Busy"];
  String _tagValue, _locationValue, _roleValue, _statusValue;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(0, locations);
    _createDropdownMenuItems(1, tags);
    _createDropdownMenuItems(2, roles);
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
      _tagValue = tags[0];
      _roleValue = roles[0];
      _statusValue = status[0];
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
                key: _userName,
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  labelStyle: TodoColors.textStyle2,
                  border: CutCornersBorder(),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            _createDropdown(2, _roleValue, _updateRoleValue),

            const SizedBox(height: 12.0),
            _createDropdown(11, _statusValue, _updateStatusValue),

            const SizedBox(height: 12.0),
            _createDropdown(0, _locationValue, _updateLocationValue),

            RaisedButton(
              child: Text('ADD LOCATION'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 12.0),
            _createDropdown(1, _tagValue, _updateTagValue),

            RaisedButton(
              child: Text('ADD TAG'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {},
            ),
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
          onPressed: () {},
        ),

      ],
    );
  }
}