import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'animated_logo.dart';

class EditPasswordPage extends StatefulWidget {
  final String currentUserId;
  EditPasswordPage({Key key, this.currentUserId}): super(key: key);

  @override
  EditPasswordPageState createState() => EditPasswordPageState();
}

class EditPasswordPageState extends State<EditPasswordPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  static String oldPassword = "", newPassword = "", newPasswordConfirmation ='';
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();
  final _oldPassword = GlobalKey(debugLabel: 'Old Password');
  final _newPassword = GlobalKey(debugLabel: 'New Password');
  final _newPasswordConfirmation = GlobalKey(
      debugLabel: 'New Password Confirmation');
  int _colorIndex = 0;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[

        SizedBox(height: 30.0),
        Column(
          children: <Widget>[
            AnimatedLogo(animation: animation, message: 'Change Your Password', factor: 2.0, colorIndex: _colorIndex,),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _oldPassword,
            controller: _oldPasswordController,
            decoration: InputDecoration(
              labelText: 'Old Password',
              border: CutCornersBorder(),
            ),
            obscureText: true,
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _newPassword,
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: 'New Password',
              border: CutCornersBorder(),
            ),
            obscureText: true,
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _newPasswordConfirmation,
            controller: _newPasswordConfirmationController,
            decoration: InputDecoration(
              labelText: 'New Password Confirmation',
              border: CutCornersBorder(),
            ),
            obscureText: true,
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
                _oldPasswordController.clear();
                _newPasswordController.clear();
                _newPasswordConfirmationController.clear();
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('CHANGE'),
              textColor: TodoColors.baseColors[_colorIndex],
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
        SizedBox(height: 300.0,),
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

