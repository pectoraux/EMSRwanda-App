import 'package:flutter/material.dart';

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
  final _padding = EdgeInsets.all(5.0);

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
              style: TodoColors.textStyle,
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _userName,
            controller: _userNameController,
            decoration: InputDecoration(
              labelText: 'User Name',
              border: CutCornersBorder(),
            ),
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _userRole,
            controller: _userRoleController,
            decoration: InputDecoration(
              labelText: 'User Role',
              border: CutCornersBorder(),
            ),
          ),
        ),
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
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                if (_userNameController.value.text.trim() != "" &&
                    _userRoleController.value.text.trim() != "") {
                  showInSnackBar(
                      "User Created Successfully", TodoColors.accent);
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
