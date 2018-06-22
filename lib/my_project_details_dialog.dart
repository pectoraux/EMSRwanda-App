import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';

class MyProjectDetailsDialog extends StatefulWidget {
  final int colorIndex;
  final String title;
  final String locations;
  final String project_description;

  const MyProjectDetailsDialog({
    @required this.colorIndex,
    @required this.title,
  @required this.locations,
  @required this.project_description,
  }) : assert(colorIndex != null),
  assert(title != null),
  assert(locations!=null),
  assert(project_description != null);

  @override
  State createState() => new MyProjectDetailsDialogState();
}

class MyProjectDetailsDialogState extends State<MyProjectDetailsDialog> {

  int people_surveyed = 100;
  final _projectDescriptionController = TextEditingController();
  final _projectDescription = GlobalKey(debugLabel: 'Project Description');
  bool _update;


  @override
  void initState() {
    super.initState();
    _setDefaults();
  }


  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _update= false;
      _projectDescriptionController.text = widget.project_description;
    });
  }



  Widget build(BuildContext context) {

    return new AlertDialog(
      title: new Text('Update Project Description',
        style: TodoColors.textStyle.apply(
            color: TodoColors.baseColors[widget.colorIndex]),),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Card(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      title: Text("Project Title: ${widget.title}\nProject Location: ${widget.locations}",
                        style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]),),
                      subtitle: _update ?
                      PrimaryColorOverride(
                        color: TodoColors.baseColors[widget.colorIndex],
                        child: new Container(
                          child: TextField(
                            style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            key: _projectDescription,
                            controller: _projectDescriptionController,
                            decoration: InputDecoration(
                              border: CutCornersBorder(),
                            ),
                          ),
                        ),
                      ):Text(widget.project_description)
                  ),
                ],
              ),
            )
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
          child: Text('UPDATE'),
          textColor: TodoColors.baseColors[widget.colorIndex],
          elevation: 8.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          onPressed: () {
            setState(() {
              _update= true;
            });
          },
        ),

      ],
    );
  }
}