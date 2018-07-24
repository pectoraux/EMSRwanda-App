import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'date_and_time_picker.dart';
import 'profile_icons.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'animated_logo.dart';
import 'loading_screen.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

class UpdateProjectPage extends StatefulWidget {
  UpdateProjectPage({Key key, this.projectDocumentID, this.roles, this.tags, this.devices}) : super(key: key);
  final List<String> roles;
  final List<String> tags;
  final List<String> devices;
  final String projectDocumentID;

//  static int len;
  @override
  UpdateProjectPageState createState() => UpdateProjectPageState();
}

class UpdateProjectPageState extends State<UpdateProjectPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');
  final _myProjectDescription = GlobalKey(debugLabel: 'Project Description');
  static final formKey = new GlobalKey<FormState>();


  DateTime _fromDate;
  DateTime _toDate;


  bool _sendRequestToAvailableUsers = false;
  String dropdown2Value;
  String _value = null;
  String dropdown3Value = 'Four';
  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems, _roleMenuItems;
  List<String> locations = ["Locations", "Gasabo", "Remera", "Kisimenti", "Gaculiro", "Kacyiru"];
  String _tagValue, _locationValue, _roleValue;
  int _colorIndex = 0;
  Set<String> selectedLocations = new Set(), selectedTags = new Set(), selectedDevices = new Set(), documentLocations = new Set();
  Map<String, Object> devicesWithRole = new Map<String, Object>();
  List devices_values;
  List<Color> _mcolors;
  List<bool> hasChanged = [false, false, false, false, false, false, false];
  String projectTitleStr ='', devicesPerRole = '', projectDescriptionStr = '', devicesPerRoleStr = '';
  List locationsList = List(), tagsList = List();
  DateTime startDateDd = DateTime.now(), endDateDd = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
    _createDropdownMenuItems(0, locations);
    _createDropdownMenuItems(1, widget.tags);
    _createDropdownMenuItems(2, widget.roles);
    _setDefaults();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
        });
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
      if(idx == 0) { //if location drop down
        _locationMenuItems = newItems;
      } else if (idx == 1){
        _tagMenuItems = newItems;
      } else if (idx == 2) {
        _roleMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() async {
    setState(() {
      devices_values = List<bool>.generate(widget.devices.toSet().length, (int index) => (false));
      _mcolors = List<Color>.generate(widget.devices.toSet().length, (int index) => (Colors.brown[500]));
      _locationValue = locations[0];
      _tagValue = widget.tags[0];
      _roleValue = widget.roles[0];


      Firestore.instance.document('projects/${widget.projectDocumentID}').get().then((d) {
      _fromDate = d['startDate'] == null ? _fromDate : d['startDate'];
      _toDate = d['endDate'] == null ? _toDate : d['endDate'];
    });
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
                      items: (idx == 0) ? _locationMenuItems : (idx == 1) ? _tagMenuItems : _roleMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),]
              ),),
          ),
        ),
      ),);
  }

  void _updateLocationValue(dynamic name) {
    setState(() {
      _locationValue = name;
    });
  }

  void _updateTagValue(dynamic name) {
    setState(() {
      _tagValue = name;
    });
  }

  void _updateRoleValue(dynamic name) {
    setState(() {
      _roleValue = name;
    });
  }

  bool areAllBrown(List<Color> list){
    for (int i = 0; i < list.length; i++) {
      if (list[i] != Colors.brown[500]){
        return false;
      }
    }
    return true;
  }


  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {


    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            AnimatedLogo(animation: animation, message: 'Update ${document['projectTitle']} Project', factor: 1.0, colorIndex: _colorIndex,),
          ],
        ),

        Form(
            key: formKey,
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:<Widget>[
                  SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    color: TodoColors.baseColors[_colorIndex],
                    child: TextFormField(
                      key: _projectTitle,
                      initialValue: document['projectTitle'],
                      onSaved: (text) {
                        _projectTitleController.text = text;
                        hasChanged[0] = true;
                      },
                      onFieldSubmitted: (text) {
                        _projectTitleController.text = text;
                        hasChanged[0] = true;
                      },
                      decoration: InputDecoration(
                        labelText: 'Project Title',
                        hintText: document['projectTitle'],
                        border: CutCornersBorder(),
                      ),
                    ),
                  ),


                  const SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    color: TodoColors.baseColors[_colorIndex],
                    child: TextFormField(
                      key: _myProjectDescription,
//                      maxLines: null,
                      initialValue: document['projectDescription'],
                      onSaved: (text) {
                        _projectDescriptionController.text = text;
                        hasChanged[1] = true;
                      },
                      onFieldSubmitted: (text) {
                        _projectDescriptionController.text = text;
                        hasChanged[1] = true;
                      },
                      decoration: InputDecoration(
                        labelText: 'Project Description',
                        hintText: document['projectDescription'],
                        border: CutCornersBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12.0),
                  _createDropdown(0, _locationValue, _updateLocationValue),

                  SizedBox(height: 3.0,),
                  selectedLocations.isNotEmpty? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Chip(
                      backgroundColor: TodoColors.baseColors[_colorIndex],
                      label: new Text(selectedLocations.toString()
                          .substring(selectedLocations.toString().indexOf('{')+1, selectedLocations.toString().indexOf('}'))),
                    ),
                  ):SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Chip(
                      backgroundColor: TodoColors.baseColors[_colorIndex],
                      label: new Text(document['locations'].toSet().toString()
                          .substring(document['locations'].toSet().toString().indexOf('{')+1, document['locations'].toSet().toString().indexOf('}'))),
                    ),
                  ),
                  SizedBox(height: 3.0,),
                  RaisedButton(
                    child: Text('ADD LOCATION'),
                    textColor: TodoColors.baseColors[_colorIndex],
                    elevation: 6.0,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () {
                      if (_locationValue != "Locations") {
                        hasChanged[2] = true;
                        setState(() {
                          selectedLocations.add(_locationValue);
                          _locationValue = locations[0];
                        });
                        showInSnackBar("Location Added Successfully", TodoColors.baseColors[_colorIndex]);
                      } else {
                        showInSnackBar(
                            "Please Specify A Location Before Clicking This Button",
                            Colors.redAccent);
                      }
                    },
                  ),

                  const SizedBox(height: 12.0),
                  _createDropdown(1, _tagValue, _updateTagValue),

                  SizedBox(height: 3.0,),
                  selectedTags.isNotEmpty? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Chip(
                      backgroundColor: TodoColors.baseColors[_colorIndex],
                      label: new Text(selectedTags.toString()
                          .substring(selectedTags.toString().indexOf('{')+1, selectedTags.toString().indexOf('}'))),
                    ),
                  ):SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Chip(
                      backgroundColor: TodoColors.baseColors[_colorIndex],
                      label: new Text(document['tags'].toString()
                          .substring(document['tags'].toSet().toString().indexOf('{')+1, document['tags'].toSet().toString().indexOf('}'))),
                    ),
                  ),
                  SizedBox(height: 3.0,),

                  RaisedButton(
                    child: Text('ADD TAG'),
                    textColor: TodoColors.baseColors[_colorIndex],
                    elevation: 6.0,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () {
                      hasChanged[3] = true;
                      if (_tagValue != "Tags") {
                        setState(() {
                          selectedTags.add(_tagValue);
                          _tagValue = widget.tags[0];
                        });

                        showInSnackBar("Tag Added Successfully", TodoColors.baseColors[_colorIndex]);
                      } else {
                        showInSnackBar("Please Specify A Tag Before Clicking This Button",
                            Colors.redAccent);
                      }
                    },
                  ),

                  const SizedBox(height: 12.0),
                  _createDropdown(2, _roleValue, _updateRoleValue),

                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: new List.generate(widget.devices.toSet().length, (i) =>
                    new InkWell(
                      onTap: () {
                        setState(() {
                          if (_mcolors[i] == Colors.brown[500]) {
                            _mcolors[i] = TodoColors.baseColors[_colorIndex];
                            selectedDevices.add(widget.devices.toSet().elementAt(i));
                          } else {
                            _mcolors[i] = Colors.brown[500];
                          }
                        });
                      },
                      child: new Card(
                        elevation: 15.0,
                        color: _mcolors[i],
                        child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Center(child: new Text(widget.devices.toSet().elementAt(i))),
                        ),
                      ),
                    ),
                    ),

                  ),
                  SizedBox(height: 3.0,),
                  devicesWithRole.isNotEmpty? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Chip(
                      backgroundColor: TodoColors.baseColors[_colorIndex],
                      label: new Text(devicesWithRole.toString()),
                    ),
                  ):SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Chip(
                      backgroundColor: TodoColors.baseColors[_colorIndex],
                      label: new Text(document['devicesPerRole'].toString()),
                    ),
                  ),
                  SizedBox(height: 3.0,),
                  const SizedBox(height: 12.0),
                  RaisedButton(
                    child: Text('ADD DEVICES TO ROLE'),
                    textColor: TodoColors.baseColors[_colorIndex],
                    elevation: 6.0,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0)),
                    ),
                    onPressed: () {
                      hasChanged[4] = true;
                      if (_roleValue != "Project Staff Roles" && !areAllBrown(_mcolors)) {
                        setState(() {
                          for (int i = 0; i < _mcolors.length; i++) {
                            _mcolors.removeAt(i);
                            _mcolors.insert(i, Colors.brown[500]);
                          }
                          devicesWithRole.addAll({_roleValue: selectedDevices});
                          _roleValue = widget.roles[0];
                          selectedDevices = new Set();
                        });
                        showInSnackBar(
                            "Device(s) Added Successfully To Role", TodoColors.baseColors[_colorIndex]);
                      } else {
                        showInSnackBar(
                            "Please Specify A Role and At Least One Device Before Clicking This Button",
                            Colors.redAccent);
                      }
                    },
                  ),

                  SizedBox(height: 12.0),
                  DatePicker(
                    labelText: 'Start Date',
                    selectedDate: _fromDate,
                    selectDate: (DateTime date) {
                      hasChanged[5] = true;
                      setState(() {
                        _fromDate = date;
                      });
                    },
                  ),

                  SizedBox(height: 12.0),
                  PrimaryColorOverride(
                    color: TodoColors.baseColors[_colorIndex],
                    child: DatePicker(
                      labelText: 'End Date',
                      selectedDate: _toDate,
                      selectDate: (DateTime date) {
                        hasChanged[6] = true;
                        setState(() {
                          _toDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  new CheckboxListTile(
                    title: Text('Send Requests', style: TodoColors.textStyle2,),
                    value: _sendRequestToAvailableUsers,
                    activeColor: TodoColors.baseColors[_colorIndex],
                    onChanged: (bool permission) {
                      setState(() {
                        _sendRequestToAvailableUsers = permission;
                      });
                    },
                    secondary: new Icon(
                      LineAwesomeIcons.user, color: TodoColors.baseColors[_colorIndex], size: 30.0,),
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
                        child: Text(_connectionStatus == 'ConnectivityResult.none' ? 'Not Connected'
                            :'UPDATE'),
                        textColor: _connectionStatus == 'ConnectivityResult.none' ? Colors.redAccent :TodoColors.baseColors[_colorIndex],
                        elevation: 8.0,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        onPressed: _connectionStatus == 'ConnectivityResult.none' ? () => onTap2() :()  async {
//                _projectTitleController.text.trim() != "" &&
//                    _projectDescriptionController.text.trim() != ""


                          projectTitleStr = hasChanged[0] ? _projectTitleController.text : document['projectTitle'];
                          projectDescriptionStr = hasChanged[1] ? _projectDescriptionController.text: document['projectDescription'];
                          locationsList = hasChanged[2] ? selectedLocations.toList(): document['locations'];
                          tagsList = hasChanged[3] ? selectedTags.toList(): document['tags'];
                          devicesPerRoleStr = hasChanged[4] ? devicesWithRole.toString(): document['devicesPerRole'];
                          startDateDd = hasChanged[5] ? _fromDate: document['startDate'];
                          endDateDd = hasChanged[6] ? _toDate: document['endDate'];
                          if (true) {

                            Map<String, Object> project_data = <String, Object>{
                              'projectTitle': projectTitleStr,
                              'projectDescription': projectDescriptionStr,
                              'locations': locationsList,
                              'tags': tagsList,
                              'devicesPerRole': devicesPerRoleStr,
                              'startDate': startDateDd,
                              'endDate': endDateDd,
                            };

                            Firestore.instance.runTransaction((transaction) async {
                              DocumentReference reference =
                              Firestore.instance.document('projects/${widget.projectDocumentID}');
                              await transaction.update(reference, project_data);
//                    print('YYYYYYYYYYYY => => => ${reference.documentID}');
                            });
                            Navigator.of(context).pop();
                            showInSnackBar(
                                "Project Created Successfully", TodoColors.baseColors[_colorIndex]);
                          } else {
                            showInSnackBar("Please Specify A Value For All Fields",
                                Colors.redAccent);
                          }
                        },
                      ),
                    ],
                  ),
                ])),
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

  Color onTap(BuildContext context, Color c) {
    if (c == Colors.brown[500]) {
      return TodoColors.baseColors[_colorIndex];
    } else {
      return Colors.brown[500];
    }
  }

  dispose() {
    controller.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('projects').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen()
            );
          } else {
            DocumentSnapshot mdoc = snapshot.data.documents.firstWhere((doc){
              return doc.documentID == widget.projectDocumentID;
            });
            final converter = _buildListItem(
                context, mdoc);
//print('WWWWWWWWWWWWW => => => ${mdoc['locations'].toString()}');
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

  void onTap2(){
    showInSnackBar(
        "You Need To Be Connected To Create A New Project", Colors.red);
  }
}

