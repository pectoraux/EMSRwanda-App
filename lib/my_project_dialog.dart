import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';

class MyProjectDialog extends StatefulWidget {
  final int colorIndex;

  const MyProjectDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyProjectDialogState();
}

class MyProjectDialogState extends State<MyProjectDialog> {
  final _projectTitleController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');

  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems;
  List<String> locations = [" Locations", " Gasabo", " Remera", " Kisimenti", " Gaculiro", " Kacyiru"];
  List<String> tags = ["Tags", "Over18", "Male", "Female", "Education", "Sensitive"];
  String _tagValue, _locationValue;


  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(0, locations);
    _createDropdownMenuItems(1, tags);
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
      if(idx == 0) { //if location drop down
        _locationMenuItems = newItems;
      } else if (idx == 1){
        _tagMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _locationValue = locations[0];
      _tagValue = tags[0];
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
                      items: (idx == 0) ? _locationMenuItems : _tagMenuItems,
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


  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Search Projects',
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

            const SizedBox(height: 12.0),
            _createDropdown(0, _locationValue, _updateLocationValue),

            RaisedButton(
              child: Text('ADD LOCATION'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 12.0),
            _createDropdown(1, _tagValue, _updateTagValue),

            RaisedButton(
              child: Text('ADD TAG'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {},
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