import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'loading_screen.dart';
import 'package:flutter/material.dart';
import 'color_override.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_tag_actions.dart';
import 'animated_logo.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

class EditTagPage extends StatefulWidget {
  @override
  EditTagPageState createState() => EditTagPageState();
}

class EditTagPageState extends State<EditTagPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final _tagNameController = TextEditingController();
  final _tagTypeController = TextEditingController();
  final _tagDescriptionController = TextEditingController();
  final _tagName = GlobalKey(debugLabel: 'Tag Name');
  final _tagDescription = GlobalKey(debugLabel: 'Tag Description');
  int _colorIndex = 0;
  List<String> tagTypes = ["Tag Type", "User Related", "Project Related"];
  List<String> ages = ["Age"] + new List<String>.generate(20, (int index) => (index * 5 + 5).toString());
  List<String> symbol = ["Symbol", "  =  ", "  >  ", "  >=  ", "  <=  ", "  <  "];
  List<String> symbol2 = ["Symbol", "  =  "];
  List<String> menu = ["Menu", "Age", "Sex"];
  List<String> sex = ["Sex", "Male", "Female"];
  List<DropdownMenuItem> _tagTypeMenuItems, _ageMenuItems, _symbolMenuItems, _symbol2MenuItems, _menuMenuItems, _sexMenuItems;
  String _tagTypeValue, _ageValue, _symbolValue, _symbol2Value, _menuValue, _sexValue;
  List<bool> changed = [false, false, false];
  String tagName = "", tagType = "", tagDescription = "";

  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();

    _createDropdownMenuItems(3, tagTypes);
    _createDropdownMenuItems(4, menu);
    _createDropdownMenuItems(5, ages);
    _createDropdownMenuItems(6, sex);
    _createDropdownMenuItems(7, symbol);
    _createDropdownMenuItems(8, symbol2);
    _setDefaults();
    _setUserTypeDefaults();
    _setMenuDefaults(5);
    _setMenuDefaults(6);
    _setMenuDefaults(7);

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
      if(idx == 3) { //if location drop down
        _tagTypeMenuItems = newItems;
      } else if (idx == 4){
        _menuMenuItems = newItems;
      }else if (idx == 5){
        _ageMenuItems = newItems;
      }else if (idx == 6){
        _sexMenuItems = newItems;
      }else if (idx == 7) {
        _symbolMenuItems = newItems;
      }else if (idx == 8) {
        _symbol2MenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _tagTypeValue = tagTypes[0];
    });
  }

  void _setUserTypeDefaults() {
    setState(() {
      _menuValue = menu[0];
    });
  }
  void _setMenuDefaults(int idx){
//    _setUserTypeDefaults();
    if (idx == 5){
      _ageValue = ages[0];
    }else if (idx == 6){
      _sexValue = sex[0];
    }
    _symbolValue = symbol[0];
    _symbol2Value = symbol2[0];
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
            items: (idx == 3)?_tagTypeMenuItems: (idx == 4) ? _menuMenuItems : (idx == 5) ? _ageMenuItems : (idx == 6) ? _sexMenuItems : (idx == 7) ?_symbolMenuItems:_symbol2MenuItems,
            onChanged: onChanged,
            style: TodoColors.textStyle2,
          ),
  ],)
        ),
      ),
    ),),),
    );
  }

  void _updateTagTypeValue(dynamic name) {
    setState(() {
      _tagTypeValue = name;
      changed[1] = true;
    });
  }

  void _updateMenuValue(dynamic name) {
    setState(() {
      _menuValue = name;
    });
  }

  void _updateAgeValue(dynamic name) {
    setState(() {
      _ageValue = name;
    });
  }

  void _updateSexValue(dynamic name) {
    setState(() {
      _sexValue = name;
    });
  }

  void _updateSymbolValue(dynamic name) {
    setState(() {
      _symbolValue = name;
    });
  }

  void _updateSymbol2Value(dynamic name) {
    setState(() {
      _symbol2Value = name;
    });
  }

   Widget _createMenuAndSymbol(){
    return new Container(
      child: Row(
     children: <Widget>[
       _createDropdown(4, _menuValue, _updateMenuValue),
       SizedBox(width: 10.0,),
       (_menuValue == "Age") ?
       _createDropdown(7, _symbolValue, _updateSymbolValue): _createDropdown(8, _symbol2Value, _updateSymbol2Value),
       SizedBox(width: 10.0,),
       (_menuValue == "Age" || _menuValue == "Menu" ) ?
       _createDropdown(5, _ageValue, _updateAgeValue):
       (_menuValue == "Sex") ?
       _createDropdown(6, _sexValue, _updateSexValue): new Container(),
      ],
      ),
     );
  }

  dispose() {
    controller.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
  bool allFalse(List<bool> lst){
    for(bool l in lst){
      if (l == true) return false;
    }
    return true;

  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          new QuickTagActions(),

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              AnimatedLogo(animation: animation,
                message: 'Create A New Tag',
                factor: 1.0,
                colorIndex: _colorIndex,),
            ],
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _tagName,
              controller: _tagNameController,
              onChanged: (text) { changed[0] = true; tagName = text;},
              decoration: InputDecoration(
                labelText: 'Tag Name',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),
          _createDropdown(3, _tagTypeValue, _updateTagTypeValue),

          (_tagTypeValue == "User Related") ? SizedBox(height: 12.0) : SizedBox(
            height: 0.0,),
          (_tagTypeValue == "User Related") ?
          _createMenuAndSymbol() : Container(),

          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _tagDescription,
              controller: _tagDescriptionController,
              onChanged: (text) { changed[1] = true; tagDescription = text;},
              decoration: InputDecoration(
                labelText: 'Tag Description',
                border: CutCornersBorder(),
              ),
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
                  _tagNameController.clear();
                  _tagTypeController.clear();
                  _tagDescriptionController.clear();
                },
              ),
              RaisedButton(
                child: Text(_connectionStatus == 'ConnectivityResult.none' ? 'Not Connected'
                    :'CREATE'),
                textColor: _connectionStatus == 'ConnectivityResult.none' ? Colors.redAccent : TodoColors.baseColors[_colorIndex],
                elevation: 8.0,
                splashColor: Colors.blueGrey,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: _connectionStatus == 'ConnectivityResult.none' ? () => onTap() :() {
                  if (_tagNameController.value.text.trim() != "" &&
                      _tagTypeController.value.text.trim() != "" &&
                      _tagDescriptionController.value.text.trim() != "") {

                    if(!allFalse(changed)) {
                      Map<String, Object> tag_data = <String, Object>{
                        'tagName': _tagNameController.text,
                        'tagType': _tagTypeValue,
                        'tagDescription': _tagDescriptionController.text,
                      };

                      Firestore.instance.runTransaction((transaction) async {
                        CollectionReference reference =
                        Firestore.instance.collection('tags').reference();
                        await reference.add(tag_data);
                      });
                    }
                    setState(() {
                      _tagTypeValue = tagTypes[0];
                      _tagNameController.clear();
                      _tagDescriptionController.clear();
                    });

                    showInSnackBar(
                        "Tag Created Successfully", TodoColors.baseColors[_colorIndex]);
                  } else {
                    showInSnackBar("Please Specify A Value For All Fields",
                        Colors.redAccent);
                  }
                },
              ),
            ],
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    try {
      return new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('tags').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Center(
                  child: new BarLoadingScreen()
              );
            } else {
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
    } catch(_){
      return Container(child: Text("Presence Of Malformed Data In Database",),);
    }
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
  void onTap(){
    showInSnackBar(
        "You Need To Be Connected To Create A New Tag", Colors.red);
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

