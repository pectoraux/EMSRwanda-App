import 'dart:async';

import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'edit_profile.dart';


class ViewInsurancePage extends StatefulWidget {
  @override
  ViewInsurancePageState createState() => ViewInsurancePageState();
}

class ViewInsurancePageState extends State<ViewInsurancePage> {
  final _bankAcctNoController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _insuranceNoController = TextEditingController();
  final _insuranceCpyController = TextEditingController();
  final _tinController = TextEditingController();
  final _cvStatusElecController = TextEditingController();
  final _dobController = TextEditingController();
  final _nationalIDController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
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
  final _bankAcctNo = GlobalKey(debugLabel: 'Banc Acct No');
  final _bankName = GlobalKey(debugLabel: 'Bank Name');
  final _insurance = GlobalKey(debugLabel: 'Insurance');
  final _insuranceNo = GlobalKey(debugLabel: 'Insurance No');
  final _insuranceCpy = GlobalKey(debugLabel: 'Insurance Copy');
  final _tin = GlobalKey(debugLabel: 'TIN');
  final _cvStatusElec = GlobalKey(debugLabel: 'CV Status Electronic');
  final _nationalID = GlobalKey(debugLabel: 'National ID');
  final _role = GlobalKey(debugLabel: 'Role');
  final _dob = GlobalKey(debugLabel: 'Date Of Birth');
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
                'Your Insurance Details',
                style: TodoColors.textStyle,
              ),
            ],
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _insurance,
            child: Text(
              "Be Safe Insurance Ltd.",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Insurance',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _insuranceNo,
            child: Text(
              "14",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Insurance Number',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          SizedBox(height: 12.0),
          InputDecorator(
            key: _insuranceCpy,
            child: Text(
              "Billy Jean",
              style: TodoColors.textStyle2,
            ),
            decoration: InputDecoration(
              labelText: 'Insurance Copy',
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
