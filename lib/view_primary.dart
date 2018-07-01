import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'progress_bar.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'animated_logo.dart';
import 'color_override.dart';

class ViewPrimaryPage extends StatefulWidget {
  final String currentUserId;
  ViewPrimaryPage({Key key, this.currentUserId}): super(key: key);

  @override
  ViewPrimaryPageState createState() => ViewPrimaryPageState();
}

class ViewPrimaryPageState extends State<ViewPrimaryPage>  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

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
//  static String bankAcctNo = "";
//  static String bankName = "";
  static String insurance = "";
  static String insuranceNo = "";
  static String insuranceCpy = "";
  static String tin = "";
  static String cvStatusElec = "";
  static String dob = "";
  static String nationalID = "";
  static String emergencyContactName = "";
  static String emergencyContactPhone = "";
  List<bool> changed = [false, false, false, false, false, false, false, false,false,false,false,false,false,false,false,false,false,false,false,false,false];
  static final formKey = new GlobalKey<FormState>();
  List<String> locations = ["Locations", "Gasabo", "Remera", "Kisimenti", "Gaculiro", "Kacyiru"];

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  @override
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    String editText = document['editing'] ? 'SAVE':'EDIT';
      return
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: <Widget>[

            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                AnimatedLogo(animation: animation, message: 'Your Primary Details', factor: 1.0, colorIndex: _colorIndex,),
              ],
            ),
            Form(
              key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:<Widget>[
            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                child: InputDecorator(
                  key: _userName,
                  child: Text(
                    document['userName'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                child: InputDecorator(
                  key: _role,
                  child: Text(
                    document['userRole'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Role',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                child: InputDecorator(
                  key: _userStatus,
                  child: Text(
                    document['userStatus'],
                    style: TodoColors.textStyle3.apply(
                        color: TodoColors.baseColors[_colorIndex]),
                  ),
                  decoration: InputDecoration(
                    labelText: 'User Status',
                    labelStyle: TodoColors.textStyle2,
                    border: CutCornersBorder(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'firstName', 'First Name', _firstName, _firstNameController, 0),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'lastName', 'Last Name', _lastName, _lastNameController, 1),

            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                child: InputDecorator(
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
              ),
            ),

            SizedBox(height: 12.0),
            ListTile(
              title: Container(
                  child: InputDecorator(
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
              ),
            ),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'nationalID', 'National ID', _nationalID, _nationalIDController, 4),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'passportNo', 'Passport Number', _passportNo, _passportNoController, 5),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'mainPhone', 'Main Phone', _mainPhone, _mainPhoneController, 7),


            SizedBox(height: 12.0),
            ListTile(
              title: Container(child:
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
    ),
            ),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'phone1', 'Alt Phone 1', _phone1, _phone1Controller, 8),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'phone2', 'Alt Phone 2', _phone2, _phone2Controller, 9),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'email1', 'Email 1', _email1, _email1Controller, 10),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'email2', 'Email 2', _email2, _email2Controller, 11),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'tin', 'TIN', _tin, _tinController, 17),

            SizedBox(height: 12.0),
            _buildTile(context, document, 'cvStatusElec', 'CV Status Electronic', _cvStatusElec, _cvStatusElecController, 18),

    ButtonBar(
    children: <Widget>[
    FlatButton(
    child: Text('CANCEL',),
    shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
    ),
    onPressed: () {
      setState(() {
        Firestore.instance.runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction. get (
              document.reference);
          await transaction.update(
              snapshot.reference, {
            'editing': false,
          });
        });
      });
      showInSnackBar("Leaving Edit Mode ...", TodoColors.baseColors[_colorIndex]);
      Navigator.of(context).pop();
    },
    ),
    RaisedButton(
    child:
    Text(editText
      , style: TextStyle(color: TodoColors.baseColors[0]),),
    elevation: 8.0,
    shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
    ),
    onPressed: () {

        setState(() {
          if(editText == 'SAVE') {
            showInSnackBar("Saving Changes ...", TodoColors.baseColors[_colorIndex]);

        bool valid = validateAndSave();

            firstName = changed[0] ? _firstNameController.text : document['firstName'];
            lastName = changed[1] ? _lastNameController.text : document['lastName'];
            dob = changed[2] ? _dobController.text : document['dob'];
            country = changed[3] ? _countryController.text : document['country'];
            nationalID = changed[4] ? _nationalIDController.text : document['nationalID'];
            passportNo = changed[5] ? _passportNoController.text : document['passportNo'];
            sex = changed[6] ? _sexController.text : document['sex'];
            mainPhone = changed[7] ? _mainPhoneController.text : document['mainPhone'];
            phone1 = changed[8] ? _phone1Controller.text : document['phone1'];
            phone2 = changed[9] ? _phone2Controller.text : document['phone2'];
            email1 = changed[10] ? _email1Controller.text : document['email1'];
            email2 = changed[11] ? _email2Controller.text : document['email2'];
//            bankName = changed[12] ? _bankNameController.text : document['bankName'];
//            bankAcctNo = changed[13] ? _bankAcctNoController.text : document['bankAcctNo'];
            insurance = changed[14] ? _insuranceController.text : document['insurance'];
            insuranceNo = changed[15] ? _insuranceNoController.text : document['insuranceNo'];
            insuranceCpy = changed[16] ? _insuranceCpyController.text : document['insuranceCpy'];
            tin = changed[17] ? _tinController.text : document['tin'];
            cvStatusElec = changed[18] ? _cvStatusElecController.text : document['cvStatusElec'];


            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
              await transaction.get(document.reference);

              await transaction.update(snapshot.reference, {
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
//                'bankAcctNo': bankAcctNo,
//                'bankName': bankName,
//                'insurance': insurance,
//                'insuranceNo': insuranceNo,
//                'insuranceCpy': insuranceCpy,
                'tin': tin,
                'cvStatusElec': cvStatusElec,
                'dob': dob,
                'nationalID': nationalID,
//                'emergencyContactName': emergencyContactName,
//                'emergencyContactPhone': emergencyContactPhone,
                'editing':!snapshot['editing'],
              });
            });
    }else {
    Firestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction. get (
    document.reference);
    await transaction.update(
    snapshot.reference, {
    'editing': !snapshot['editing']
    });
    });
    showInSnackBar("Entering Edit Mode ...", Colors.redAccent);
    }
    });
    }


    )
    ],
    ),],),),
    ],
    );
  }


  Widget _buildTile(BuildContext context, DocumentSnapshot document, String fieldName, String label, GlobalKey mkey,
      TextEditingController controller, int idx){
   changed[idx] = true;
    return ListTile(
      title: Container(
              child: !document['editing']
                  ? InputDecorator(
                key: mkey,
                child: Text(
                  document[fieldName],
                  style: TodoColors.textStyle3.apply(
                      color: TodoColors.baseColors[_colorIndex]),
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TodoColors.textStyle2,
                  border: CutCornersBorder(),
                ),
              ): PrimaryColorOverride(
                color: TodoColors.baseColors[_colorIndex],
                child: TextFormField(
                  key: mkey,
                  initialValue: document[fieldName],
                  onSaved: (text) {
                  controller.text = text;
                  },
                  onFieldSubmitted: (text) {
                    controller.text = text;
                  },
                  decoration: InputDecoration(
                    labelText: label,
                    hintText: document[fieldName],
                    border: CutCornersBorder(),
                  ),
                ),
              ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final padding = Padding(padding: _padding);

    return new StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.document('users/${widget.currentUserId}').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData)
    {
      return new Center(
          child: new CircularProgressIndicator()
      );
    }else if (snapshot.data != null) {
//            DocumentSnapshot document = snapshot.data.documents.where((doc){
//    return (doc['userName'] == widget.currentUserId) ? true : false;
//              }).first;

            final converter = _buildListItem(context, snapshot.data);

            return Padding(
              padding:
              _padding,
              child: OrientationBuilder(
                builder: (BuildContext
                context, Orientation orientation) {
                  if (orientation == Orientation.portrait) {
                    return
                       converter;
                  } else {
                    return Center(
                      child: Container(
                        width: 450.0,
                          child:converter,
                      ),
                    );
                  }
                }
                ,
              ),
            );
          }

        });
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}


