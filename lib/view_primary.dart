import 'dart:async';

import 'package:flutter/material.dart';
import 'color_override.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'edit_profile.dart';


class ViewPrimaryPage extends StatefulWidget {
  @override
  ViewPrimaryPageState createState() => ViewPrimaryPageState();
}

class ViewPrimaryPageState extends State<ViewPrimaryPage> {
  final _userName = GlobalKey(debugLabel: 'Username');
  final _userStatus = GlobalKey(debugLabel: 'User Status');
  final _firstName = GlobalKey(debugLabel: 'First Name');
  final _lastName = GlobalKey(debugLabel: 'Last Name');
  final _email1 = GlobalKey(debugLabel: 'Email1');
  final _email2 = GlobalKey(debugLabel: 'Email2');
  final _sex = GlobalKey(debugLabel: 'Sex');
  final _country = GlobalKey(debugLabel: 'Country');
  final _mainPhone = GlobalKey(debugLabel: 'Main Phone');
  final _phone1 = GlobalKey(debugLabel: 'Phone1');
  final _phone2 = GlobalKey(debugLabel: 'Phone2');
  final _passportNo = GlobalKey(debugLabel: 'Passport No');
  final _tin = GlobalKey(debugLabel: 'TIN');
  final _cvStatusElec = GlobalKey(debugLabel: 'CV Status Electronic');
  final _nationalID = GlobalKey(debugLabel: 'National ID');
  final _role = GlobalKey(debugLabel: 'Role');
  final _dob = GlobalKey(debugLabel: 'Date Of Birth');
  final _padding = EdgeInsets.all(5.0);
  int _colorIndex = 0;

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
                'Your Primary Details',
                style: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
              ),
            ],
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _userName,
            child: Text(
              "emma.watson",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'User Name',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _role,
            child: Text(
              "Field Supervisor",
              style: TodoColors.textStyle3,
            ),
            decoration: InputDecoration(
              labelText: 'User Role',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _userStatus,
            child: Text(
              "Active",
              style: TodoColors.textStyle3,
            ),
            decoration: InputDecoration(
              labelText: 'User Status',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _firstName,
            child: Text(
              "Emma",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'First Name',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _lastName,
            child: Text(
              "Watson",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Last Name',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _dob,
            child: Text(
              "14th June 1983",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Date Of Birth',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _country,
            child: Text(
              "Rwanda",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Country',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _nationalID,
            child: Text(
              "3336.256.654",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'National ID',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _passportNo,
            child: Text(
              "EBB656JHOEPR",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Passport Number',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _sex,
            child: Text(
              "Female",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Sex',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _mainPhone,
            child: Text(
              "+25078963405",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Main Phone',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _phone1,
            child: Text(
              "",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Alt Phone 1',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _phone2,
            child: Text(
              "",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Alt Phone 2',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _email1,
            child: Text(
              "emmawatson@laterite.com",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Email 1',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _email2,
            child: Text(
              "",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Email 2',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _tin,
            child: Text(
              "",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'TIN',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _cvStatusElec,
            child: Text(
              "",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'CV Status Electronic',
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


