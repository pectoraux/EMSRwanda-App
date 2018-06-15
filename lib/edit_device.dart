import 'profile_icons.dart';
import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_device_actions.dart';


class EditDevicePage extends StatefulWidget {
  @override
  EditDevicePageState createState() => EditDevicePageState();
}

class EditDevicePageState extends State<EditDevicePage> {
  final _deviceNameController = TextEditingController();
  final _deviceTypeController = TextEditingController();
  final _deviceConditionController = TextEditingController();
  final _deviceName = GlobalKey(debugLabel: 'Device Name');
  final _deviceType = GlobalKey(debugLabel: 'Device Type');
  final _deviceCondition = GlobalKey(debugLabel: 'Device Condition');
  final _padding = EdgeInsets.all(5.0);


  @override
  Widget build(BuildContext context) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        new QuickDeviceActions(),

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            Image.asset('assets/diamond.png'),
            SizedBox(height: 16.0),
            Text(
              'Create A New Device',
              style: TodoColors.textStyle,
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,

          child: TextField(
            key: _deviceName,
            controller: _deviceNameController,
            decoration: InputDecoration(
              labelText: 'Device Name',
              border: CutCornersBorder(),
            ),
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,

          child: TextField(
            key: _deviceType,
            controller: _deviceTypeController,
            decoration: InputDecoration(
              labelText: 'Device Type',
              border: CutCornersBorder(),
            ),
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,

          child: TextField(
            key: _deviceCondition,
            controller: _deviceConditionController,
            decoration: InputDecoration(
              labelText: 'Device Condition',
              border: CutCornersBorder(),
            ),
          ),
        ),


        const SizedBox(height: 12.0),


        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                _deviceNameController.clear();
                _deviceTypeController.clear();
                _deviceConditionController.clear();
              },
            ),
            RaisedButton(
              child: Text('CREATE'),
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                if (_deviceNameController.value.text.trim() != "" &&
                    _deviceTypeController.value.text.trim() != "" &&
                    _deviceConditionController.value.text.trim() != "") {
                  showInSnackBar(
                      "Device Created Successfully", TodoColors.accent);
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
