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
  int _colorIndex = 0;
  List<String> deviceTypes = ["Device Type", "Ipad", "Microphone", "Phone", "Tablet", "Dictaphone", "Other"];
  List<DropdownMenuItem> _deviceTypeMenuItems;
  String _deviceTypeValue;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(9, deviceTypes);
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
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _deviceTypeValue = deviceTypes[0];
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
          child: DropdownButton(
            value: currentValue,
            items: _deviceTypeMenuItems,
            onChanged: onChanged,
            style: TodoColors.textStyle2,
          ),
        ),
      ),
    );
  }

  void _updateDeviceTypeValue(dynamic name) {
    setState(() {
      _deviceTypeValue = name;
    });
  }

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
              style: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _deviceName,
            controller: _deviceNameController,
            decoration: InputDecoration(
              labelText: 'Device Name',
              border: CutCornersBorder(),
            ),
          ),
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
    )):new Container(),

    (_deviceTypeValue == "Other") ?
    SizedBox(height: 12.0,):SizedBox(height: 4.0,),

        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
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
              textColor: TodoColors.baseColors[_colorIndex],
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
              textColor: TodoColors.baseColors[_colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                if (_deviceNameController.value.text.trim() != "" &&
                    _deviceConditionController.value.text.trim() != "" && _deviceTypeValue != "Other") {
                  setState(() {
                    _deviceTypeValue = "Device Type";
                    _deviceNameController.clear();
                    _deviceConditionController.clear();
                  });
                  showInSnackBar(
                      "Device Created Successfully", TodoColors.baseColors[_colorIndex]);
                } else if(_deviceNameController.value.text.trim() != "" &&
                    _deviceConditionController.value.text.trim() != "" && _deviceTypeValue == "Other") {
                  if (_deviceTypeController.value.text.trim() != "") {
                    setState(() {
                      _deviceTypeValue = "Device Type";
                      _deviceNameController.clear();
                      _deviceConditionController.clear();
                      _deviceTypeController.clear();
                    });
                    showInSnackBar(
                        "Device Created Successfully", TodoColors.baseColors[_colorIndex]);
                    _deviceTypeController.clear();
                  } else {
                    showInSnackBar("Please Specify A Device For All Fields",
                        Colors.redAccent);
                  }
                }else {
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
