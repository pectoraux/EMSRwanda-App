import 'profile_icons.dart';
import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_role_actions.dart';
import 'profile_fonts.dart';


class UpdateRolePage extends StatefulWidget {
  @override
  UpdateRolePageState createState() => UpdateRolePageState();
}

class UpdateRolePageState extends State<UpdateRolePage> {
  final _roleNameController = TextEditingController();
  final _roleName = GlobalKey(debugLabel: 'Role Name');
  bool _createUserPermission = false;
  bool _createProjectPermission = false;
  bool _createRolePermission = false;
  bool _createTagPermission = false;
  bool _grantUserPermission = false;

  @override
  Widget build(BuildContext context) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            Image.asset('assets/diamond.png'),
            SizedBox(height: 16.0),
            Text(
              'Update Enumerator Role',
              style: TodoColors.textStyle,
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _roleName,
            controller: _roleNameController,

            decoration: InputDecoration(
              hintText: "Enumerator",
              hintStyle: TodoColors.textStyle,
              helperText: "Enumerator",
              helperStyle: TodoColors.textStyle,
              labelText: 'Role Name',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        const SizedBox(height: 12.0),
        new CheckboxListTile(
          title: Text('Can Create User', style: TodoColors.textStyle2,),
          value: _createUserPermission,
          onChanged: (bool permission) {
            setState(() {
              _createUserPermission = permission;
            });
          },
          secondary: new Icon(
            LineAwesomeIcons.user, color: TodoColors.accent, size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Create Project', style: TodoColors.textStyle2,),
          value: _createProjectPermission,
          onChanged: (bool permission) {
            setState(() {
              _createProjectPermission = permission;
            });
          },
          secondary: new Icon(
            Icons.work, color: TodoColors.accent, size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Create Role', style: TodoColors.textStyle2,),
          value: _createRolePermission,
          onChanged: (bool permission) {
            setState(() {
              _createRolePermission = permission;
            });
          },
          secondary: new Icon(
            Icons.library_add, color: TodoColors.accent, size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Create Tag', style: TodoColors.textStyle2,),
          value: _createTagPermission,
          onChanged: (bool permission) {
            setState(() {
              _createTagPermission = permission;
            });
          },
          secondary: new Icon(
            Icons.title, color: TodoColors.accent, size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Grant Permission', style: TodoColors.textStyle2,),
          value: _grantUserPermission,
          onChanged: (bool permission) {
            setState(() {
              _grantUserPermission = permission;
            });
          },
          secondary: new Icon(
            LineAwesomeIcons.thumbsUp, color: TodoColors.accent, size: 30.0,),
        ),


        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
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
                  _grantUserPermission = false;
                });
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('UPDATE'),
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                if (_roleNameController.value.text.trim() != "") {
                  showInSnackBar(
                      "Role Updated Successfully", TodoColors.accent);
                } else {
                  showInSnackBar(
                      "Please Specify A Value For Role Name", Colors.redAccent);
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
