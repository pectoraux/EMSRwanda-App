import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'date_and_time_picker.dart';

class MyNotificationDialog extends StatefulWidget {
  final int colorIndex;

  const MyNotificationDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyNotificationDialogState();
}

class MyNotificationDialogState extends State<MyNotificationDialog> {
  final _projectTitleController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');
  final _notifPriorityController = TextEditingController();
  final _notifPriority = GlobalKey(debugLabel: 'Notification Priority');
  final _fromController = TextEditingController();
  final _from = GlobalKey(debugLabel: 'From (time)');
  final _toController = TextEditingController();
  final _to = GlobalKey(debugLabel: 'To (time)');
  DateTime _fromDate;
  TimeOfDay _fromTime;
  DateTime _toDate;
  TimeOfDay _toTime;

  List<DropdownMenuItem> _notifPriorityMenuItems;
  List<String> _notifPriorities = ["Notification Priorities", "High Priority", "Medium Priority", "Low Priority"];
  String _notifPriorityValue;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(15, _notifPriorities);
    _setDefaults();

    _fromDate = new DateTime.now();
    _fromTime = const TimeOfDay(hour: 7, minute: 28);
    _toDate = new DateTime.now();
    _toTime = const TimeOfDay(hour: 7, minute: 28);
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
      if(idx == 15) { //if location drop down
        _notifPriorityMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _notifPriorityValue = _notifPriorities[0];
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
                      items: _notifPriorityMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),]
              ),),
          ),
        ),
      ),);
  }

  void _updateNotificationValue(dynamic name) {
    setState(() {
      _notifPriorityValue = name;
    });
  }


  Widget build(BuildContext context) {


    return new AlertDialog(
      title: new Text('Search Notifications',
        style: TodoColors.textStyle.apply(
            color: TodoColors.baseColors[widget.colorIndex]),),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[widget.colorIndex],
          child: TextField(
            key: _projectTitle,
            controller: _projectTitleController,
            decoration: InputDecoration(
              labelText: 'Project Title',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),
            SizedBox(height: 12.0),
            _createDropdown(15,  _notifPriorityValue, _updateNotificationValue),

            SizedBox(height: 12.0),
            DateTimePicker(
              labelText: 'From (time)',
              selectedDate: _fromDate,
              selectedTime: _fromTime,
              selectDate: (DateTime date) {
                setState(() {
                  _fromDate = date;
                });
              },
              selectTime: (TimeOfDay time) {
                setState(() {
                  _fromTime = time;
                });
              },
            ),


            SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: TodoColors.baseColors[widget.colorIndex],
              child: DateTimePicker(
                labelText: 'To (time)',
                selectedDate: _toDate,
                selectedTime: _toTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _toDate = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    _toTime = time;
                  });
                },
              ),
            ),

            SizedBox(height: 12.0,),
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