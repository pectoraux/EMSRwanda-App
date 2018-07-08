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


  @override
  void initState() {
    super.initState();
    _setDefaults();
  }


  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _projectDescriptionController.text = widget.project_description;
    });
  }



  Widget build(BuildContext context) {

    return new AlertDialog(
      title: new Text('Project Description',
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
                      subtitle: Text(widget.project_description)
                  ),
                ],
              ),
            ),
            BackButton(color: TodoColors.baseColors[widget.colorIndex],),
          ],
        ),
      ),

    );
  }
}