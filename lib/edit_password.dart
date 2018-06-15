import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_user_actions.dart';


class EditPasswordPage extends StatefulWidget {
  @override
  EditPasswordPageState createState() => EditPasswordPageState();
}

class EditPasswordPageState extends State<EditPasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();
  final _oldPassword = GlobalKey(debugLabel: 'Old Password');
  final _newPassword = GlobalKey(debugLabel: 'New Password');
  final _newPasswordConfirmation = GlobalKey(
      debugLabel: 'New Password Confirmation');


  @override
  Widget build(BuildContext context) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[

        SizedBox(height: 30.0),
        Column(
          children: <Widget>[
            Image.asset('assets/diamond.png'),
            SizedBox(height: 16.0),
            Text(
              'Change Your Password',
              style: TodoColors.textStyle,
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _oldPassword,
            controller: _oldPasswordController,
            decoration: InputDecoration(
              labelText: 'Old Password',
              border: CutCornersBorder(),
            ),
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _newPassword,
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              border: CutCornersBorder(),
            ),
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _newPasswordConfirmation,
            controller: _newPasswordConfirmationController,
            decoration: InputDecoration(
              labelText: 'New Password Confirmation',
              border: CutCornersBorder(),
            ),
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
                _oldPasswordController.clear();
                _newPasswordController.clear();
                _newPasswordConfirmationController.clear();
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('CHANGE'),
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                if (_oldPasswordController.value.text.trim() != "" &&
                    _newPasswordController.value.text.trim() != "" &&
                    _newPasswordConfirmationController.value.text.trim() !=
                        "") {
                  showInSnackBar(
                      "Password Changed Successfully", TodoColors.accent);
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
