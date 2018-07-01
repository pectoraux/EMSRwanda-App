import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_device_actions.dart';
import 'color_override.dart';
import 'star_rating.dart';
import 'qrcode_scanner.dart';
import 'package:flutter/services.dart';
import 'animated_logo.dart';

class EditDevicePage extends StatefulWidget {
  EditDevicePage({Key key, this.deviceTypes}) : super(key: key);
  final List<String> deviceTypes;

  @override
  EditDevicePageState createState() => EditDevicePageState();
}

class EditDevicePageState extends State<EditDevicePage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  final _deviceNameController = TextEditingController();
  final _deviceTypeController = TextEditingController();
  final _deviceStatusController = TextEditingController();
  final _deviceConditionController = TextEditingController();
  final _deviceStatus = GlobalKey(debugLabel: 'Device Status');
  final _deviceType = GlobalKey(debugLabel: 'Device Type');
  final _deviceCondition = GlobalKey(debugLabel: 'Device Condition');
  int _colorIndex = 0;
//  List<String> deviceTypes = ["Device Type", "Ipad", "Microphone", "Phone", "Tablet", "Dictaphone", "Other"];
  List<String> deviceConditions = ["Device Condition", "1", "2", "3", "4", "5"];
  List<String> deviceStatus = ["Device Status", "Available", 'In Use'];
  List<DropdownMenuItem> _deviceTypeMenuItems, _deviceConditionMenuItems, _deviceStatusMenuItems;
  String _deviceTypeValue, _deviceConditionValue, _deviceStatusValue;
  double rating = 0.0;
  static String display_instructions = "Tap Here To Scan The Device Name";
  String deviceName = display_instructions;
  final String display_permission_denied = "Camera permission was denied";
  final String display_unknown = "Unknown Error";
  final String display_no_scan = "You pressed the back button before scanning anything";


  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();

    _createDropdownMenuItems(9, widget.deviceTypes);
    _createDropdownMenuItems(14, deviceConditions);
    _createDropdownMenuItems(20, deviceStatus);
    _setDefaults();
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
      if(idx == 9) { //if location drop down
        _deviceTypeMenuItems = newItems;
      } else if (idx == 14){
        _deviceConditionMenuItems = newItems;
      } else if (idx == 20) {
        _deviceStatusMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _deviceTypeValue = widget.deviceTypes[0];
      _deviceConditionValue = deviceConditions[0];
      _deviceStatusValue = deviceStatus[0];
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
            items: (idx == 9) ? _deviceTypeMenuItems : (idx == 14 )? _deviceConditionMenuItems : _deviceStatusMenuItems,
            onChanged: onChanged,
            style: TodoColors.textStyle2,
          ),]))))
        ),
      ),
    );
  }

  void _updateDeviceTypeValue(dynamic name) {
    setState(() {
      _deviceTypeValue = name;
    });
  }

  Future scanQR2() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
      deviceName = qrResult.toUpperCase();
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
        deviceName = display_permission_denied;
        });
      } else {
        setState(() {
        deviceName = display_unknown + " $ex";
        });
      }
    } on FormatException {
      setState(() {
      deviceName = display_no_scan;
      });
    } catch (ex) {
      setState(() {
      deviceName = display_unknown + " $ex";
      });
    }
  }

  void _updateDeviceConditionValue(dynamic name) {
    setState(() {
      _deviceConditionValue = name;
      rating = double.parse(name);
    });
  }

  void _updateDeviceStatusValue(dynamic name) {
    setState(() {
      _deviceStatusValue = name;
    });
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        new QuickDeviceActions(),

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            AnimatedLogo(animation: animation,
              message: 'Create A New Device',
              factor: 1.0,
              colorIndex: _colorIndex,),
          ],
        ),

        SizedBox(height: 12.0),
        FlatButton(
          child: Text(deviceName, style: TodoColors.textStyle.apply(color: Theme
              .of(context)
              .disabledColor),),
          padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
          color: TodoColors.baseColors[_colorIndex],
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            scanQR2();
            setState(() {
              _deviceNameController.clear();
              _deviceTypeController.clear();
              _deviceConditionController.clear();
              _deviceConditionValue = "Device Condition";
              _deviceTypeValue = "Device Type";
              rating = 0.0;
            });
          },
        ),

        const SizedBox(height: 12.0),
        _createDropdown(9, _deviceTypeValue, _updateDeviceTypeValue),

        SizedBox(height: 12.0,),

        (_deviceTypeValue == "Other") ?
        PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _deviceType,
              controller: _deviceTypeController,
              decoration: InputDecoration(
                labelText: 'Device Type',
                border: CutCornersBorder(),
              ),
            )) : new Container(),

        (_deviceTypeValue == "Other") ?
        SizedBox(height: 12.0,) : SizedBox(height: 4.0,),

        const SizedBox(height: 12.0),
        _createDropdown(14, _deviceConditionValue, _updateDeviceConditionValue),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: Container(
            margin: const EdgeInsets.only(left: 100.0, right: 100.0),
            child: new StarRating(
              rating: rating,
              onRatingChanged: (rating) => setState(() => rating = rating),
            ),
          ),
        ),

        const SizedBox(height: 12.0),
        _createDropdown(20, _deviceStatusValue, _updateDeviceStatusValue),


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
                  _deviceNameController.clear();
                  _deviceTypeController.clear();
                  _deviceConditionController.clear();
                  _deviceConditionValue = "Device Condition";
                  _deviceTypeValue = "Device Type";
                  _deviceStatusValue = "Device Status";
                  deviceName = display_instructions;
                  rating = 0.0;
                });
              },
            ),
            RaisedButton(
              child: Text('CREATE'),
              textColor: TodoColors.baseColors[_colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
//                if (_deviceNameController.value.text.trim() != "" &&
//                    _deviceConditionController.value.text.trim() != "" && _deviceTypeValue != "Other" && _deviceConditionValue != "Device Condition") {
                if (true) {
                  Map<String, Object> device_data = <String, Object>{
                    'deviceName': deviceName,
                    'deviceType': _deviceTypeValue,
                    'deviceCondition': _deviceConditionValue,
                    'deviceStatus': _deviceStatusValue,
                  };

                  Firestore.instance.runTransaction((transaction) async {
                    CollectionReference reference =
                    Firestore.instance.collection('devices').reference();
                    await reference.add(device_data);
                  });

                  setState(() {
                    _deviceTypeValue = "Device Type";
                    _deviceConditionValue = "Device Condition";
                    _deviceNameController.clear();
                    _deviceConditionController.clear();
                    _deviceStatusValue = "Device Status";
                    deviceName = display_instructions;
                    rating = 0.0;
                  });
                  showInSnackBar(
                      "Device Created Successfully",
                      TodoColors.baseColors[_colorIndex]);
                } else if (_deviceNameController.value.text.trim() != "" &&
                    _deviceConditionController.value.text.trim() != "" &&
                    _deviceTypeValue == "Other" &&
                    _deviceConditionValue != "Device Condition") {
                  if (_deviceTypeController.value.text.trim() != "") {
                    setState(() {
                      _deviceTypeValue = "Device Type";
                      _deviceConditionValue = "Device Condition";
                      _deviceNameController.clear();
                      _deviceConditionController.clear();
                      _deviceTypeController.clear();
                    });
                    showInSnackBar(
                        "Device Created Successfully",
                        TodoColors.baseColors[_colorIndex]);
                    _deviceTypeController.clear();
                  } else {
                    showInSnackBar("Please Specify A Device For All Fields",
                        Colors.redAccent);
                  }
                } else {
                  showInSnackBar("Please Specify A Device For All Fields",
                      Colors.redAccent);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('devices').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new CircularProgressIndicator()
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
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

