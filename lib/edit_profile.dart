import 'dart:async';

import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';


class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _email1Controller = TextEditingController();
  final _email2Controller = TextEditingController();
  final _sexController = TextEditingController();
  final _countryController = TextEditingController();
  final _mainPhoneController = TextEditingController();
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _passportNoController = TextEditingController();
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
                'Edit Your Profile',
                style: TodoColors.textStyle,
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

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _firstName,
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _lastName,
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _dob,
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date Of Birth',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _country,
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _nationalID,
              controller: _nationalIDController,
              decoration: InputDecoration(
                labelText: 'National ID',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _passportNo,
              controller: _passportNoController,
              decoration: InputDecoration(
                labelText: 'Passport Number',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _sex,
              controller: _sexController,
              decoration: InputDecoration(
                labelText: 'Sex',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _mainPhone,
              controller: _mainPhoneController,
              decoration: InputDecoration(
                labelText: 'Main Phone',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _phone1,
              controller: _phone1Controller,
              decoration: InputDecoration(
                labelText: 'Alt Phone 1',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _phone2,
              controller: _phone2Controller,
              decoration: InputDecoration(
                labelText: 'Alt Phone 2',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _email1,
              controller: _email1Controller,
              decoration: InputDecoration(
                labelText: 'Email 1',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _email2,
              controller: _email2Controller,
              decoration: InputDecoration(
                labelText: 'Email 2',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _bankName,
              controller: _bankNameController,
              decoration: InputDecoration(
                labelText: 'Bank Name',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _bankAcctNo,
              controller: _bankAcctNoController,
              decoration: InputDecoration(
                labelText: 'Bank Account Number',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _insurance,
              controller: _insuranceController,
              decoration: InputDecoration(
                labelText: 'Insurance',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _insuranceNo,
              controller: _insuranceNoController,
              decoration: InputDecoration(
                labelText: 'Insurance Number',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _insuranceCpy,
              controller: _insuranceCpyController,
              decoration: InputDecoration(
                labelText: 'Insurance Copy',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _tin,
              controller: _tinController,
              decoration: InputDecoration(
                labelText: 'TIN',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _cvStatusElec,
              controller: _cvStatusElecController,
              decoration: InputDecoration(
                labelText: 'CV Status Electronic',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _emergencyContactName,
              controller: _emergencyContactNameController,
              decoration: InputDecoration(
                labelText: 'Emergency Contact Name',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,
            child: TextField(
              key: _emergencyContactPhone,
              controller: _emergencyContactPhoneController,
              decoration: InputDecoration(
                labelText: 'Emergency Contact Phone Number',
                border: CutCornersBorder(),
              ),
            ),
          ),


          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
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
//                  if(_firstNameController.value.text.trim() != "" && _lastNameController.value.text.trim() != "" &&
//                      _dobController.value.text.trim() != "" && _countryController.value.text.trim() != "" && _nationalIDController.value.text.trim() != "" &&
//                      _emergencyContactPhoneController.value.text.trim() != "" && _emergencyContactNameController.value.text.trim() != "" &&
//                      _cvStatusElecController.value.text.trim() != "" && _tinController.value.text.trim() != "" && _insuranceCpyController.value.text.trim() != "" &&
//                      _insuranceNoController.value.text.trim() != "" && _insuranceController.value.text.trim() != "" && _bankNameController.value.text.trim() != "" &&
//                      _bankAcctNoController.value.text.trim() != "" && _email1Controller.value.text.trim() != "" && _email2Controller.value.text.trim() != "" &&
//                      _phone2Controller.value.text.trim() != "" && _phone1Controller.value.text.trim() != "" && _mainPhoneController.value.text.trim() != "" &&
//                      _sexController.value.text.trim() != "" && _passportNoController.value.text.trim() != ""
//                  ){
//                    showInSnackBar("Profile Updated Successfully", TodoColors.accent);
//                  }else{
//                    showInSnackBar("Please Specify A Value For All Fields", Colors.redAccent);
//                  }
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
