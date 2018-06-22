import 'dart:async';

import 'package:flutter/material.dart';
import 'color_override.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'date_and_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'progress_bar.dart';

class EditProfilePage extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
//  static final usersRef = Firestore.instance.collection('users').snapshots();
//  usersRef.snapshots();
//  static final CollectionReference todoCollection = Firestore.instance.collection('users');
//  Future<DocumentSnapshot> newDoc = todoCollection.document().get();
  static String firstName = "";
  static String lastName = "";
  static String email1 = "";
  static String email2 = "";
  static String sex ="";
  static String country = "";
  static String mainPhone = "";
  static String phone1 = "";
  static String phone2 = "";
  static String passportNo = "";
  static String bankAcctNo = "";
  static String bankName = "";
  static String insurance = "";
  static String insuranceNo = "";
  static String insuranceCpy = "";
  static String tin = "";
  static String cvStatusElec = "";
  static String dob = "";
  static String nationalID = "";
  static String emergencyContactName = "";
  static String emergencyContactPhone = "";



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
  int _colorIndex = 0;
  List<String> countries = TodoColors.countries;
  List<String> sexes = ["Sex", "Male", "Female"];
  List<DropdownMenuItem> _countriesMenuItems, _sexMenuItems;
  String _countriesValue, _sexValue;
  DateTime _fromDate;
  TimeOfDay _fromTime;
  DateTime _toDate;
  TimeOfDay _toTime;
  List<bool> changed = [false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false];


  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(6, sexes);
    _createDropdownMenuItems(10, countries);
    _setDefaults();

    _fromDate = new DateTime.now();
    _toDate = new DateTime.now();
  }

  /// Creates fresh list of [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems(int idx, List<String> list) {
    var newItems = <DropdownMenuItem>[];
    for (var unit in list) {
      newItems.add(DropdownMenuItem(
        value: unit,
        child: Container(
          child: Text(
            unit,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      if (idx == 10) {
        _countriesMenuItems = newItems;
      } else if (idx == 6){
        _sexMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _sexValue = sexes[0];
      _countriesValue = countries[0];
    });
  }

  bool allFalse(List<bool> lst){
    for(bool l in lst){
      if (l == true) return false;
    }
    return true;

  }

  Widget _createDropdown(int idx, String currentValue, ValueChanged<dynamic>

  onChanged)

  {
    return Container(
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: TodoColors.baseColors[_colorIndex],
        border: Border.all(
          color: TodoColors.baseColors[_colorIndex],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
            child: new SingleChildScrollView(
                child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 8.0,
                    ),
                    child: DropdownButtonHideUnderline(
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            DropdownButton(
                              value: currentValue,
                              items: (idx == 6) ? _sexMenuItems : _countriesMenuItems,
                              onChanged: onChanged,
                              style: TodoColors.textStyle2,
                            ),],))))
        ),
      ),
    );
  }

  void _updateSexValue(dynamic name) {
    setState(() {
      _sexValue = name;
      changed[6] = true;
    });
  }

  void _updateCountriesValue(dynamic name) {
    setState(() {
      _countriesValue = name;
      changed[3] = true;
    });
  }

  _updateToLatestValue() {
//    _firstNameController.text = firstName;
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    String previous = " Previous Value: ";
//    _firstNameController.addListener(_updateToLatestValue);
//    String firstName = document['firstName'];

//    lastName = document['lastName'];
//    email1 = document['email1'];
//    email2 = document['email2'];
//    sex = document['sex'];
//    country = document['country'];
//    mainPhone = document['mainPhone'];
//    phone1 = document['phone1'];
//    phone2 = document['phone2'];
//    passportNo = document['passportNo'];
//    bankAcctNo = document['bankAcctNo'];
//    bankName = document['bankName'];
//    insurance = document['insurance'];
//    insuranceNo = document['insuranceNo'];
//    insuranceCpy = document['insuranceCpy'];
//    tin = document['tin'];
//    cvStatusElec = document['cvStatusElec'];
//    dob = document['dob'];
//    nationalID = document['nationalID'];
//    emergencyContactName = document['emergencyContactName'];
//    emergencyContactPhone = document['emergencyContactPhone'];

//    _firstNameController.text = firstName;
//    _lastNameController.text = lastName;
//    _email1Controller.text = email1;
//    _email2Controller.text = email2;
//    _sexController.text = sex;
//    _countryController.text = country;
//    _mainPhoneController.text = mainPhone;
//    _phone1Controller.text = phone1;
//    _phone2Controller.text = phone2;
//    _passportNoController.text = passportNo;
//    _bankAcctNoController.text = bankAcctNo;
//    _bankNameController.text = bankName;
//    _insuranceController.text = insurance;
//    _insuranceNoController.text = insuranceNo;
//    _insuranceCpyController.text = insuranceCpy;
//    _tinController.text = tin;
//    _cvStatusElecController.text = cvStatusElec;
//    _dobController.text = dob;
//    _nationalIDController.text = nationalID;
//    _emergencyContactNameController.text = emergencyContactName;
//    _emergencyContactPhoneController.text = emergencyContactPhone;


    return ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),

        children: <Widget>[

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              Image.asset('assets/diamond.png'),
              SizedBox(height: 16.0),
              Text(
                'Edit Your Profile',
                style: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex],),
              ),
            ],
          ),



          SizedBox(height: 12.0),
          InputDecorator(
            key: _userName,
            child: Text(
            document['userName'],
            style: TodoColors.textStyle3.apply(color: TodoColors.baseColors[_colorIndex]),
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
              document['userRole'],
              style: TodoColors.textStyle3.apply(color: TodoColors.baseColors[_colorIndex]),
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
              document['userStatus'],
              style: TodoColors.textStyle3.apply(color: TodoColors.baseColors[_colorIndex]),
            ),
            decoration: InputDecoration(
              labelText: 'User Status',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _firstName,
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: document['firstName'],
                border: CutCornersBorder(),
              ),
              onChanged: (text) { changed[0] = true;  firstName = text; },
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _lastName,
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: CutCornersBorder(),
                hintText: document['lastName'],
              ),
              onChanged: (text) { changed[1] = true; lastName = text;},
            ),
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: DatePicker(
              labelText: 'Date Of Birth',
              selectedDate: _toDate,
              selectDate: (DateTime date) {
                setState(() {
                  _toDate = date;
                  changed[2] = true;
                });
              },
            ),
          ),

          const SizedBox(height: 12.0),
          _createDropdown(10, _countriesValue, _updateCountriesValue),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _nationalID,
              controller: _nationalIDController,
              decoration: InputDecoration(
                labelText: 'National ID',
                border: CutCornersBorder(),
                hintText: document['nationalID'],
              ),
              onChanged: (text) { changed[4] = true; nationalID = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _passportNo,
              controller: _passportNoController,
              decoration: InputDecoration(
                labelText: 'Passport Number',
                border: CutCornersBorder(),
                hintText: document['passportNo'],
              ),
              onChanged: (text) { changed[5] = true; passportNo = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          _createDropdown(6, _sexValue, _updateSexValue),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _mainPhone,
              controller: _mainPhoneController,
              decoration: InputDecoration(
                labelText: 'Main Phone',
                border: CutCornersBorder(),
                hintText: document['mainPhone'],
              ),
              keyboardType: TextInputType.phone,
              onChanged: (text) { changed[7] = true; mainPhone = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _phone1,
              controller: _phone1Controller,
              decoration: InputDecoration(
                labelText: 'Alt Phone 1',
                border: CutCornersBorder(),
                hintText: document['phone1'],
              ),
              keyboardType: TextInputType.phone,
              onChanged: (text) { changed[8] = true; phone1 = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _phone2,
              controller: _phone2Controller,
              decoration: InputDecoration(
                labelText: 'Alt Phone 2',
                border: CutCornersBorder(),
                hintText: document['phone2'],
              ),
              keyboardType: TextInputType.phone,
              onChanged: (text) { changed[9] = true; phone2 = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _email1,
              controller: _email1Controller,
              decoration: InputDecoration(
                labelText: 'Email 1',
                border: CutCornersBorder(),
                hintText: document['email1'],
              ),
              onChanged: (text) { changed[10] = true; email1 = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _email2,
              controller: _email2Controller,
              decoration: InputDecoration(
                labelText: 'Email 2',
                border: CutCornersBorder(),
                hintText: document['email2'],
              ),
              onChanged: (text) { changed[11] = true; email2 = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _bankName,
              controller: _bankNameController,
              decoration: InputDecoration(
                labelText: 'Bank Name',
                border: CutCornersBorder(),
                hintText: document['bankName'],
              ),
              onChanged: (text) { changed[12] = true; bankName = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _bankAcctNo,
              controller: _bankAcctNoController,
              decoration: InputDecoration(
                labelText: 'Bank Account Number',
                border: CutCornersBorder(),
                hintText: document['bankAcctNo'],
              ),
              keyboardType: TextInputType.number,
              onChanged: (text) { changed[13] = true; bankAcctNo = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _insurance,
              controller: _insuranceController,
              decoration: InputDecoration(
                labelText: 'Insurance',
                border: CutCornersBorder(),
                hintText: document['insurance'],
              ),
              onChanged: (text) { changed[14] = true; insurance = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _insuranceNo,
              controller: _insuranceNoController,
              decoration: InputDecoration(
                labelText: 'Insurance Number',
                border: CutCornersBorder(),
                hintText: document['insuranceNo'],
              ),
              onChanged: (text) { changed[15] = true; insuranceNo = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _insuranceCpy,
              controller: _insuranceCpyController,
              decoration: InputDecoration(
                labelText: 'Insurance Copy',
                border: CutCornersBorder(),
                hintText: document['insuranceCpy'],
              ),
              onChanged: (text) { changed[16] = true; insuranceCpy = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _tin,
              controller: _tinController,
              decoration: InputDecoration(
                labelText: 'TIN',
                border: CutCornersBorder(),
                hintText: document['tin'],
              ),
              onChanged: (text) { changed[17] = true; tin = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _cvStatusElec,
              controller: _cvStatusElecController,
              decoration: InputDecoration(
                labelText: 'CV Status Electronic',
                border: CutCornersBorder(),
                hintText: document['cvStatusElec'],
              ),
              onChanged: (text) { changed[18] = true; cvStatusElec = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _emergencyContactName,
              controller: _emergencyContactNameController,
              decoration: InputDecoration(
                labelText: 'Emergency Contact Name',
                border: CutCornersBorder(),
                hintText: document['emergencyContactName'],
              ),
              onChanged: (text) { changed[19] = true; emergencyContactName = text;},
            ),
          ),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _emergencyContactPhone,
              controller: _emergencyContactPhoneController,
              decoration: InputDecoration(
                labelText: 'Emergency Contact Phone Number',
                border: CutCornersBorder(),
                hintText: document['emergencyContactPhone'],
              ),
              keyboardType: TextInputType.phone,
              onChanged: (text) { changed[20] = true; emergencyContactPhone = text;},
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
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('UPDATE'),
                textColor: TodoColors.baseColors[_colorIndex],
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {

                  if(!allFalse(changed)) {
                    firstName = changed[0] ? firstName : document['firstName'];
                    lastName = changed[1] ? lastName : document['lastName'];
                    dob = changed[2] ? dob : document['dob'];
                    country = changed[3] ? country : document['country'];
                    nationalID = changed[4] ? nationalID : document['nationalID'];
                    passportNo = changed[5] ? passportNo : document['passportNo'];
                    sex = changed[6] ? sex : document['sex'];
                    mainPhone = changed[7] ? mainPhone : document['mainPhone'];
                    phone1 = changed[8] ? phone1 : document['phone1'];
                    phone2 = changed[9] ? phone2 : document['phone2'];
                    email1 = changed[10] ? email1 : document['email1'];
                    email2 = changed[11] ? email2 : document['email2'];
                    bankName = changed[12] ? bankName : document['bankName'];
                    bankAcctNo = changed[13] ? bankAcctNo : document['bankAcctNo'];
                    insurance = changed[14] ? insurance : document['insurance'];
                    insuranceNo = changed[15] ? insuranceNo : document['insuranceNo'];
                    insuranceCpy = changed[16] ? insuranceCpy : document['insuranceCpy'];
                    tin = changed[17] ? tin : document['tin'];
                    cvStatusElec = changed[18] ? cvStatusElec : document['cvStatusElec'];
                    emergencyContactName = changed[19] ? emergencyContactName : document['emergencyContactName'];
                    emergencyContactPhone = changed[20] ? emergencyContactPhone : document['emergencyContactPhone'];

                      Firestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot freshSnap =
                        await transaction.get(document['users'].reference);
                        await transaction.update(freshSnap.reference, {
                          'firstName': firstName,
                          'lastName': lastName,
                          'email1': email1,
                          'email2': email2,
                          'sex': sex,
                          'country': country,
                          'mainPhone': mainPhone,
                          'phone1': phone1,
                          'phone2': phone2,
                          'passportNo': passportNo,
                          'bankAcctNo': bankAcctNo,
                          'bankName': bankName,
                          'insurance': insurance,
                          'insuranceNo': insuranceNo,
                          'insuranceCpy': insuranceCpy,
                          'tin': tin,
                          'cvStatusElec': cvStatusElec,
                          'dob': dob,
                          'nationalID': nationalID,
                          'emergencyContactName': emergencyContactName,
                          'emergencyContactPhone': emergencyContactPhone,
                        });
                      });


                    showInSnackBar("Profile Updated Successfully",
                        TodoColors.baseColors[_colorIndex]);
                    Navigator.of(context).pop();
                  }
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
  }


  @override
  Widget build(BuildContext context) {
    final padding = Padding(padding: _padding);

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
    {
    if (!snapshot.hasData) return
      new Center(
          child: new CircularProgressIndicator()
      );
//      new Text('Loading...', style: TodoColors.textStyle2.apply(color: TodoColors.baseColors[_colorIndex]),);

    _firstNameController.text = snapshot.data.documents[0]['firstName'];
    _lastNameController.text = snapshot.data.documents[0]['lastName'];
    _email1Controller.text = snapshot.data.documents[0]['email1'];
    _email2Controller.text = snapshot.data.documents[0]['email2'];
    _sexController.text = snapshot.data.documents[0]['sex'];
    _countryController.text = snapshot.data.documents[0]['country'];
    _mainPhoneController.text = snapshot.data.documents[0]['mainPhone'];
    _phone1Controller.text = snapshot.data.documents[0]['phone1'];
    _phone2Controller.text = snapshot.data.documents[0]['phone2'];
    _passportNoController.text = snapshot.data.documents[0]['passportNo'];
    _bankAcctNoController.text = snapshot.data.documents[0]['bankAcctNo'];
    _bankNameController.text = snapshot.data.documents[0]['bankName'];
    _insuranceController.text = snapshot.data.documents[0]['insurance'];
    _insuranceNoController.text = snapshot.data.documents[0]['insuranceNo'];
    _insuranceCpyController.text = snapshot.data.documents[0]['insuranceCpy'];
    _tinController.text = snapshot.data.documents[0]['tin'];
    _cvStatusElecController.text = snapshot.data.documents[0]['cvStatusElec'];
    _dobController.text = snapshot.data.documents[0]['dob'];
    _nationalIDController.text = snapshot.data.documents[0]['nationalID'];
    _emergencyContactNameController.text = snapshot.data.documents[0]['emergencyContactName'];
    _emergencyContactPhoneController.text = snapshot.data.documents[0]['emergencyContactPhone'];


    final converter = _buildListItem(context, snapshot.data.documents[0]);
//
//    _firstNameController.text = firstName;
//    _lastNameController.text = lastName;
//    _email1Controller.text = email1;
//    _email2Controller.text = email2;
//    _sexController.text = sex;
//    _countryController.text = country;
//    _mainPhoneController.text = mainPhone;
//    _phone1Controller.text = phone1;
//    _phone2Controller.text = phone2;
//    _passportNoController.text = passportNo;
//    _bankAcctNoController.text = bankAcctNo;
//    _bankNameController.text = bankName;
//    _insuranceController.text = insurance;
//    _insuranceNoController.text = insuranceNo;
//    _insuranceCpyController.text = insuranceCpy;
//    _tinController.text = tin;
//    _cvStatusElecController.text = cvStatusElec;
//    _dobController.text = dob;
//    _nationalIDController.text = nationalID;
//    _emergencyContactNameController.text = emergencyContactName;
//    _emergencyContactPhoneController.text = emergencyContactPhone;

    return new Padding(
    padding: _padding,
    child: OrientationBuilder(
    builder:
    (BuildContext context, Orientation orientation)
    {
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
    }
    ,
    ),
    );
    });
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

