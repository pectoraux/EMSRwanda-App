import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'view_projects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPendingDialog extends StatefulWidget {
  final int colorIndex;

  const MyPendingDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyPendingDialogState();
}

class MyPendingDialogState extends State<MyPendingDialog> {
  final _projectTitleController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');
  final _requestTypeController = TextEditingController();
  final _requestType = GlobalKey(debugLabel: 'Request Type');

  List<DropdownMenuItem> _typeMenuItems;
  List<String> types = ["Request Type", "Made To You", "Made By You"];
  String _typeValue;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(21, types);
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
        _typeMenuItems = newItems;
    });
  }

  void _setDefaults() {
    setState(() {
      _typeValue = types[0];
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
                      items: _typeMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),]
              ),),
          ),
        ),
      ),);
  }

  void _updateTypeValue(dynamic name) {
    setState(() {
      _typeValue = name;
    });
  }

  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Search Requests',
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
            _createDropdown(0, _typeValue, _updateTypeValue),
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
          onPressed: () {
            Map<String, Object> search_data = <String, Object>{};
            if (_projectTitleController.value.text.trim() != "") {
              search_data['projectTitle'] = _projectTitleController.value.text;
            }
            if (_typeValue != types[0]) {
              search_data['type'] = _typeValue;
            }
            Navigator.of(context).pop([search_data]);
//            Navigator.of(context).pushReplacement(
//                MaterialPageRoute(builder: (_) => ViewProjectsPage(colorIndex: widget.colorIndex, roles: null, tags: tags, devices: null, res: [search_data]),)
//            );
          },
        ),

      ],
    );
  }


  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}