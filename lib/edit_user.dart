import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'color_override.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_user_actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'animated_logo.dart';
import 'loading_screen.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({Key key, this.auth, this.currentUserPassword, this.roles}) : super(key: key);

  final BaseAuth auth;
  final String currentUserPassword;
  final List<String> roles;

  @override
  EditUserPageState createState() => EditUserPageState();
}

class EditUserPageState extends State<EditUserPage>  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final _userNameController = TextEditingController();
  final _userRoleController = TextEditingController();
  final _userName = GlobalKey(debugLabel: 'User Name');
  final _userRole = GlobalKey(debugLabel: 'User Role');
  final _userPassword = GlobalKey(debugLabel: 'User Password');
  int _colorIndex = 0;
//  List<String> roles = ["Project Staff Roles"];
  List<DropdownMenuItem> _roleMenuItems;
  String _roleValue;
  String defaultPassword = "Laterite";
  bool error = false;
  String oldEmail, oldPassword;
FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<String> results = [];

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
      if (idx == 2) {
        _roleMenuItems = newItems;
      }
    });
  }

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();

    _createDropdownMenuItems(2, widget.roles);
    _setDefaults();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
        });

  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _roleValue = widget.roles[0];
    });
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
                              items: _roleMenuItems,
                              onChanged: onChanged,
                              style: TodoColors.textStyle2,
                            ),],))))
        ),
      ),
    );
  }

  void _updateRoleValue(dynamic name) {
    setState(() {
      _roleValue = name;
    });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        new QuickUserActions(),

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            AnimatedLogo(animation: animation, message: 'Create A New User', factor: 1.0, colorIndex: _colorIndex,),
          ],
        ),

//    new Center(
//    child: new Text('Connection Status: $_connectionStatus\n')),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _userName,
            controller: _userNameController,
            decoration: InputDecoration(
              labelText: 'User Name',
              border: CutCornersBorder(),
            ),
          ),
        ),

        const SizedBox(height: 12.0),
        _createDropdown(2, _roleValue, _updateRoleValue),

        SizedBox(height: 12.0),
        InputDecorator(
          key: _userPassword,
          child: Text(
            defaultPassword,
            style: TodoColors.textStyle2,
          ),
          decoration: InputDecoration(
            labelText: 'User Password',
            labelStyle: TodoColors.textStyle2,
            border: CutCornersBorder(),
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
                setState(() {
                  _userNameController.clear();
                  _roleValue = widget.roles[0];
                });
              },
            ),
            RaisedButton(
              child: Text(_connectionStatus == 'ConnectivityResult.none' ? 'Not Connected'
              :'CREATE'),
              textColor: _connectionStatus == 'ConnectivityResult.none' ? Colors.redAccent :TodoColors.baseColors[_colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: _connectionStatus == 'ConnectivityResult.none' ? () => onTap() : () {
//                _userNameController.value.text.trim() != "" &&
//                    _roleValue != "Project Staff Roles"
                if (true) {
                String email = _userNameController.text+'@laterite.com';
                String mrole = _roleValue;
                List<String> userLocations = [], items = ['0'];

                widget.auth.createUser(email, defaultPassword).then((newId) {
                  if(newId != null) {

                    Map<String, Object> user_data = <String, Object>{
                      'userName': newId,
                      'userRole': mrole,
                      'userPassword': defaultPassword,
                      'userStatus': 'Active',
                      'firstName': '',
                      'lastName': '',
                      'email1': email,
                      'email2': '',
                      'sex': '',
                      'country': '',
                      'mainPhone': '',
                      'phone1': '',
                      'phone2': '',
                      'passportNo': '',
                      'bankAcctNo': '',
                      'bankName': '',
                      'insurance': '',
                      'insuranceNo': '',
                      'insuranceCpy': '',
                      'tin': '',
                      'cvStatusElec': '',
                      'dob': '',
                      'nationalID': '',
                      'emergencyContactName': '',
                      'emergencyContactPhone': '',
                      'locations': userLocations.toString(),
                      '_list': items,
                      '_list2': items,
                      'initiativeTakingRating': -1.0,
                      'communicationRating': -1.0,
                      'punctualityRating': -1.0,
                      'reportingRating': -1.0,
                      'overAllRating': -1.0,
                      'editing': false,
                    };
                    Firestore.instance.runTransaction((transaction) async {
                      DocumentReference reference =
                      Firestore.instance.document('users/${newId}');
                      await reference.setData(user_data);
                    });
                  }else{
                    error = true;
                  }

                }).catchError((err){
                  error = true;
                  showInSnackBar(
                      "Unable To Create User  $err", Colors.red);
                });
                    _roleValue = widget.roles[0];
                    _userNameController.clear();
                    error? '':showInSnackBar(
                        "User Created Successfully", TodoColors.baseColors[_colorIndex]);
//                  widget.auth.signOut();
                  widget.auth.signIn(oldEmail, widget.currentUserPassword);
                } else {
                  showInSnackBar("Please Specify A Value For All Fields",
                      Colors.redAccent);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  dispose() {
    controller.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }


  @override
  Widget build(BuildContext context) {


//    print("=> => => => => => => ${roles.toString()}");

//, "Enumerator", "Project Lead", "Project Supervisor", "Administrator"
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen(),
            );
          } else {

          print("=> => => => ${_firebaseAuth.currentUser().then((user) async {

            setState(() {
              oldEmail = user.email;
            });
          })}");
            final converter = _buildListItem(
                context, snapshot.data.documents.first);

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
        });
  }

  void onTap(){
    showInSnackBar(
        "You Need To Be Connected To Create A User", Colors.red);
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }


}

