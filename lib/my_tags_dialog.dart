import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'star_rating.dart';

class MyTagsDialog extends StatefulWidget {
  final int colorIndex;

  const MyTagsDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyTagsDialogState();
}

class MyTagsDialogState extends State<MyTagsDialog> {
  final _tagNameController = TextEditingController();
  final _tagName = GlobalKey(debugLabel: 'Tag Name');

  List<String> tagTypes = ["Tag Type", "User Related", "Project Related"];
  List<DropdownMenuItem> _tagTypeMenuItems;
  String _tagTypeValue;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(3, tagTypes);
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
      if(idx == 3) { //if location drop down
        _tagTypeMenuItems = newItems;
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
                      items: _tagTypeMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),]
              ),),
          ),
        ),
      ),);
  }

  void _updateTagTypeValue(dynamic name) {
    setState(() {
      _tagTypeValue = name;
    });
  }


  Widget build(BuildContext context) {

    return new AlertDialog(
      title: new Text('Search  Tags',
        style: TodoColors.textStyle.apply(
            color: TodoColors.baseColors[widget.colorIndex]),),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[

            SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: TodoColors.baseColors[widget.colorIndex],
              child: TextField(
                key: _tagName,
                controller: _tagNameController,
                decoration: InputDecoration(
                  labelText: 'Tag Name',
                  labelStyle: TodoColors.textStyle2,
                  border: CutCornersBorder(),
                ),
              ),
            ),

            const SizedBox(height: 12.0),
            _createDropdown(3, _tagTypeValue, _updateTagTypeValue),
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