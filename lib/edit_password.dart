import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'animated_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final _newPasswordController = TextEditingController();
  final _secretKeyController = TextEditingController();
  final _newPasswordConfirmationController = TextEditingController();
  final _newPassword = GlobalKey(debugLabel: 'New Password');
  final _secretKey = GlobalKey(debugLabel: 'secret key');
  final _newPasswordConfirmation = GlobalKey(debugLabel: 'New Password Confirmation');
  int _colorIndex = 0;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
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

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _secretKey,
            controller: _secretKeyController,
            decoration: InputDecoration(
              labelText: 'Secret Key',
              border: CutCornersBorder(),
            ),
          ),
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
              onPressed: () async {
                if (_newPasswordController.value.text.trim() != "" && _newPasswordConfirmationController.value.text.trim() != "" && _secretKeyController.value.text != "") {
    if(_newPasswordController.value.text == _newPasswordConfirmationController.value.text) {

      Map<String, Object> user_data = <String, Object>{
        'userPassword': _newPasswordConfirmationController.value.text,
        'secretKey': _secretKeyController.value.text
      };
      FirebaseAuth _auth = FirebaseAuth.instance;
      String uid = (await _auth.currentUser()).uid;
//      print("Your User ID ${(await _auth.currentUser()).uid}");
      Firestore.instance.runTransaction((transaction) async {
        DocumentReference reference = Firestore.instance.document('users/${uid}');
        await transaction.update(reference, user_data);
      });
        showInSnackBar(
            "Password Changed Successfully", TodoColors.baseColors[_colorIndex]);
        Navigator.of(context).pop();
      } else {
      showInSnackBar("Password Confirmation is Different from Password",
          Colors.redAccent);
    }

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

