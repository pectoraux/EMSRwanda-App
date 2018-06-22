import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'color_override.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'edit_profile.dart';
import 'progress_bar.dart';


class ViewEmergencyPage extends StatefulWidget {
  @override
  ViewEmergencyPageState createState() => ViewEmergencyPageState();
}

class ViewEmergencyPageState extends State<ViewEmergencyPage> {

  final _emergencyContactName = GlobalKey(debugLabel: 'Emergency Contact Name');
  final _emergencyContactPhone = GlobalKey(
      debugLabel: 'Emergency Contact Phone');
  final _padding = EdgeInsets.all(5.0);
  int _colorIndex = 0;




    Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
      return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: <Widget>[

            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16.0),
                Text(
                  'Your Emergency Details',
                  style: TodoColors.textStyle.apply(
                      color: TodoColors.baseColors[_colorIndex]),
                ),
              ],
            ),

            SizedBox(height: 12.0),
            InputDecorator(
              key: _emergencyContactName,
              child: Text(
                document['emergencyContactName'],
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
                document['emergencyContactPhone'],
                style: TodoColors.textStyle2,
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
                  textColor: TodoColors.baseColors[_colorIndex],
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                RaisedButton(
                  child: Text('EDIT'),
                  textColor: TodoColors.baseColors[_colorIndex],
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
    }

  @override
  Widget build(BuildContext context) {
    final padding = Padding(padding: _padding);
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if (!snapshot.hasData) return new Center
            (
              child: new CircularProgressIndicator()
          );
          final converter = _buildListItem
            (context, snapshot.data.documents[0
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
    );});
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

