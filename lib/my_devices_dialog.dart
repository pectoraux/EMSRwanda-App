import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'star_rating.dart';

class MyDevicesDialog extends StatefulWidget {
  final int colorIndex;

  const MyDevicesDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyDevicesDialogState();
}

class MyDevicesDialogState extends State<MyDevicesDialog> {
  final _deviceNameController = TextEditingController();
  final _deviceName = GlobalKey(debugLabel: 'Device Name');

  List<String> deviceTypes = ["Device Type", "Ipad", "Microphone", "Phone", "Tablet", "Dictaphone", "Other"];
  List<String> deviceConditions = ["Device Condition", "1", "2", "3", "4", "5"];
  List<DropdownMenuItem> _deviceTypeMenuItems, _deviceConditionMenuItems;
  String _deviceTypeValue, _deviceConditionValue;
  double rating;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(9, deviceTypes);
    _createDropdownMenuItems(14, deviceConditions);
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
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _deviceTypeValue = deviceTypes[0];
      _deviceConditionValue = deviceConditions[0];
      rating = 0.0;
    });
  }

  Widget _createDropdown(int idx, String currentValue, ValueChanged<dynamic>

  onChanged)

  {
    return Container(
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: TodoColors.baseColors[widget.colorIndex],
        border: Border.all(
          color: TodoColors.baseColors[widget.colorIndex],
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
                      items: (idx == 14) ? _deviceConditionMenuItems : _deviceTypeMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),]
              ),),
          ),
        ),
      ),);
  }

  void _updateDeviceTypeValue(dynamic name) {
    setState(() {
      _deviceTypeValue = name;
    });
  }

  void _updateDeviceConditionValue(dynamic name) {
    setState(() {
      _deviceConditionValue = name;
      rating = double.parse(name);
    });
  }


  Widget build(BuildContext context) {

    return new AlertDialog(
      title: new Text('Search  Devices',
        style: TodoColors.textStyle.apply(
            color: TodoColors.baseColors[widget.colorIndex]),),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[

            SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: TodoColors.baseColors[widget.colorIndex],
              child: TextField(
                key: _deviceName,
                controller: _deviceNameController,
                decoration: InputDecoration(
                  labelText: 'Device Name',
                  labelStyle: TodoColors.textStyle2,
                  border: CutCornersBorder(),
                ),
              ),
            ),

            const SizedBox(height: 12.0),
            _createDropdown(9, _deviceTypeValue, _updateDeviceTypeValue),

            const SizedBox(height: 12.0),
            _createDropdown(14, _deviceConditionValue, _updateDeviceConditionValue),

            SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: TodoColors.baseColors[widget.colorIndex],
              child: new StarRating(
                rating: rating,
                onRatingChanged: (rating) => setState(() => rating = rating),
              ),
            ),
          ],
        ),

      ),

      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          textColor: TodoColors.baseColors[widget.colorIndex],
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        RaisedButton(
          child: Text('SEARCH'),
          textColor: TodoColors.baseColors[widget.colorIndex],
          elevation: 8.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {},
        ),

      ],
    );
  }
}