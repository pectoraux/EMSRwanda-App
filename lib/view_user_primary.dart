import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'loading_screen.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'animated_logo.dart';
import 'color_override.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_country_picker/flutter_country_picker.dart';

class ViewUserPrimaryPage extends StatefulWidget {
  final int colorIndex;
  final String currentUserId;
  final String projectDocumentId;
   bool canCreateUser;
   bool isStaff;

  ViewUserPrimaryPage({
    @required this.colorIndex,
    @required this.currentUserId,
    this.canCreateUser,
    this.projectDocumentId,
    this.isStaff,
  }) : assert(colorIndex != null),
        assert(currentUserId != null);
  @override
  ViewUserPrimaryPageState createState() => ViewUserPrimaryPageState();
}

class ViewUserPrimaryPageState extends State<ViewUserPrimaryPage>  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String imagePath;
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
  final _insurance = GlobalKey(debugLabel: 'Insurance');
  final _insuranceNo = GlobalKey(debugLabel: 'Insurance No');
  final _insuranceCpy = GlobalKey(debugLabel: 'Insurance Copy');
  final _emergencyContactName = GlobalKey(debugLabel: 'Emergency Contact Name');
  final _emergencyContactPhone = GlobalKey(debugLabel: 'Emergency Contact Phone');
  final _bankAcctNo = GlobalKey(debugLabel: 'Banc Acct No');
  final _bankName = GlobalKey(debugLabel: 'Bank Name');
  final _userGroup = GlobalKey(debugLabel: 'User Group');
  final _userGroup2 = GlobalKey(debugLabel: 'User Group2');
  final _padding = EdgeInsets.all(5.0);

  final _userGroup2Controller = TextEditingController();
  static final formKey = new GlobalKey<FormState>();
  bool showLoadingAnimation = false;
  String imageUrlStr = '';
  DateTime picked;
  int userGroup, userGroup2;

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
    if(widget.projectDocumentId != null) {
      setDefaults();
    }
  }

  void setDefaults() async {
    Firestore.instance.collection('projects/${widget.projectDocumentId}/users')
        .getDocuments()
        .then((query) {
      query.documents.forEach((doc) {
//        print('=> => => ${doc.documentID}');
        if (doc.documentID == widget.currentUserId){
          setState(() {
            userGroup = doc['userGroup'];
          });
        }
      });
    });
  }



//  dispose() {
//    controller.dispose();
//    super.dispose();
//  }

  void _changeUserGroup(String newGrp){
    Firestore.instance.runTransaction((transaction) async {
      DocumentReference reference =
      Firestore.instance.document('projects/${widget.projectDocumentId}/users/${widget.currentUserId}');
      await transaction.update(reference,
      {'userGroup': int.parse(newGrp)});
      setState(() {
        userGroup = int.parse(newGrp);
        formKey.currentState.setState(null);
      });
    });
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    return Scaffold(
      appBar: AppBar
    (
    leading: new BackButton(key: _bkey, color: Colors.black,),
    elevation: 2.0,
    backgroundColor: Colors.white,
    title: Container(padding: EdgeInsets.all(5.0),
        child:Text("${document['firstName']}'s Details", textAlign: TextAlign.center,
    style: TodoColors.textStyle6)),
    ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            Center(
              child: new Container(
                width: 70.0, height: 60.0,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: Image.network(document['photoUrl']).image,
                      fit: BoxFit.cover),
                  borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                        color: Colors.black26, blurRadius: 5.0, spreadRadius: 1.0),
                  ],
                ),
              ),
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
                              color: TodoColors.baseColors[widget.colorIndex]),
                        ),
                        decoration: InputDecoration(
                          labelText: 'User Name',
                          labelStyle: TodoColors.textStyle2,
                          border: CutCornersBorder(),
                        ),
                      ),
                    ),
                  ),

                  widget.projectDocumentId != null ? SizedBox(height: 12.0):SizedBox(height: 0.0),
                  widget.projectDocumentId != null ?
                  ListTile(
                    title: Container(
                      child: InputDecorator(
                        key: _userGroup,
                        child: Text(
                          '$userGroup',
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
                        ),
                        decoration: InputDecoration(
                          labelText: 'User Group',
                          labelStyle: TodoColors.textStyle2,
                          border: CutCornersBorder(),
                        ),
                      ),
                    ),
                  ):Container(),
                  widget.isStaff ?
                  RaisedButton(
                    child: Text('CHANGE USER GROUP'),
                    textColor: TodoColors.baseColors[widget.colorIndex],
                    elevation: 6.0,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () {
                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text(
                              'CHANGE  USER  GROUP', style: TodoColors.textStyle3,
                            ),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  SizedBox(height: 12.0),
                                  PrimaryColorOverride(
                                    color: TodoColors.baseColors[widget.colorIndex],
                                    child: TextFormField(
                                      key: _userGroup2,
                                      controller: _userGroup2Controller,
                                      decoration: InputDecoration(
                                        labelText: 'User Group',
                                        hintText: '$userGroup',
                                        border: CutCornersBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text('CANCEL'),
                                textColor: TodoColors.baseColors[0],
                                elevation: 8.0,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),

                              FlatButton(
                                child: Text('CHANGE'),
                                textColor: TodoColors.baseColors[0],
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                ),
                                onPressed: () {
                                  _changeUserGroup(_userGroup2Controller.text);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ):Container(),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(
                      child: InputDecorator(
                        key: _role,
                        child: Text(
                          document['userRole'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
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
                              color: TodoColors.baseColors[widget.colorIndex]),
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
                  ListTile(
                    title: Container(
                      child: InputDecorator(
                        key: _firstName,
                        child: Text(
                          document['firstName'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
                        ),
                        decoration: InputDecoration(
                          labelText: 'First Name',
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
                        key: _lastName,
                        child: Text(
                          document['lastName'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Last Name',
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
                        key: _dob,
                        child: Text(
                          document['dob'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
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
                          document['country'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),

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
                  ListTile(
                    title: Container(
                      child: InputDecorator(
                        key: _nationalID,
                        child: Text(
                          document['nationalID'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),

                        ),
                        decoration: InputDecoration(
                          labelText: 'National ID',
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
                        key: _passportNo,
                        child: Text(
                          document['passportNo'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),

                        ),
                        decoration: InputDecoration(
                          labelText: 'Passport Number',
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
                        key: _mainPhone,
                        child: Text(
                          document['mainPhone'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),

                        ),
                        decoration: InputDecoration(
                          labelText: 'Main Phone',
                          labelStyle: TodoColors.textStyle2,
                          border: CutCornersBorder(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _sex,
                      child: Text(
                        document['sex'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
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
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _phone1,
                      child: Text(
                        document['phone1'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Alt Phone 1',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _phone2,
                      child: Text(
                        document['phone2'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Alt Phone 2',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _email1,
                      child: Text(
                        document['email1'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email 1',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _email2,
                      child: Text(
                        document['email2'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email 2',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _tin,
                      child: Text(
                        document['tin'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'TIN',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _cvStatusElec,
                      child: Text(
                        document['cvStatusElec'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'CV Status Electronic',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _insurance,
                      child: Text(
                        document['insurance'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Insurance',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _insuranceNo,
                      child: Text(
                        document['insuranceNo'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Insurance Number',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _insuranceCpy,
                      child: Text(
                        document['insuranceCpy'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Insurance Copy',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _emergencyContactName,
                      child: Text(
                        document['emergencyContactName'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Emergency Contact Name',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _emergencyContactPhone,
                      child: Text(
                        document['emergencyContactPhone'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Emergency Contact Phone',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ),

                  SizedBox(height: 12.0),
                  widget.canCreateUser ?
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _bankName,
                      child: Text(
                        document['bankName'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Bank Name',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ):Container(),

                  SizedBox(height: 12.0),
                  widget.canCreateUser ?
                  ListTile(
                    title: Container(child:
                    InputDecorator(
                      key: _bankAcctNo,
                      child: Text(
                        document['bankAcctNo'],
                        style: TodoColors.textStyle3.apply(
                            color: TodoColors.baseColors[widget.colorIndex]),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Bank Account Number',
                        labelStyle: TodoColors.textStyle2,
                        border: CutCornersBorder(),
                      ),
                    ),
                    ),
                  ):Container(),
                ],
              ),
            ),
          ],
        ),
      );
  }


  void onTap(){

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
              child: new BarLoadingScreen(),
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


