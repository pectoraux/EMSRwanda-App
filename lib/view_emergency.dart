import 'dart:async';

import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'edit_profile.dart';


class ViewEmergencyPage extends StatefulWidget {
  @override
  ViewEmergencyPageState createState() => ViewEmergencyPageState();
}

class ViewEmergencyPageState extends State<ViewEmergencyPage> {

  final _emergencyContactName = GlobalKey(debugLabel: 'Emergency Contact Name');
  final _emergencyContactPhone = GlobalKey(
      debugLabel: 'Emergency Contact Phone');
  final _padding = EdgeInsets.all(5.0);

  @override
  Widget build(BuildContext context) {
    final padding = Padding(padding: _padding);


    final converter = ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              Image.asset('assets/diamond.png'),
              SizedBox(height: 16.0),
              Text(
                'Your Emergency Details',
                style: TodoColors.textStyle,
              ),
            ],
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _emergencyContactName,
            child: Text(
              "Lilly Jackson",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Emergency Contact Name',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _emergencyContactPhone,
            child: Text(
              "+25078321549",
              style: TodoColors.textStyle3,
            ),
            decoration: InputDecoration(
              labelText: 'Emergency Contact Phone',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),


          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('BACK'),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('EDIT'),
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => EditProfilePage()));
                },
              ),
            ],
          ),
        ]);

    return Padding(
      padding: _padding,
      child: OrientationBuilder(
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
      ),
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
