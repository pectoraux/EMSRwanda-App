import 'profile_icons.dart';
import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_tag_actions.dart';

class EditTagPage extends StatefulWidget {
  @override
  EditTagPageState createState() => EditTagPageState();
}

class EditTagPageState extends State<EditTagPage> {
  final _tagNameController = TextEditingController();
  final _tagTypeController = TextEditingController();
  final _tagDescriptionController = TextEditingController();
  final _tagName = GlobalKey(debugLabel: 'Tag Name');
  final _tagType = GlobalKey(debugLabel: 'Tag Type');
  final _tagDescription = GlobalKey(debugLabel: 'Tag Description');
  final _padding = EdgeInsets.all(5.0);

  @override
  Widget build(BuildContext context) {
    final converter = ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          new QuickTagActions(),

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              Image.asset('assets/diamond.png'),
              SizedBox(height: 16.0),
              Text(
                'Create A New Tag',
                style: TodoColors.textStyle,
              ),
            ],
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.accent,

            child: TextField(
              key: _tagName,
              controller: _tagNameController,
              decoration: InputDecoration(
                labelText: 'Tag Name',
                border: CutCornersBorder(),
              ),
            ),
          ),

          const SizedBox(height: 12.0),

          PrimaryColorOverride(
            color: TodoColors.accent,

            child: TextField(
              key: _tagType,
              controller: _tagTypeController,
              decoration: InputDecoration(
                labelText: 'Tag Type',
                border: CutCornersBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          PrimaryColorOverride(
            color: TodoColors.accent,

            child: TextField(
              key: _tagDescription,
              controller: _tagDescriptionController,
              decoration: InputDecoration(
                labelText: 'Tag Description',
                border: CutCornersBorder(),
              ),
            ),
          ),

          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  _tagNameController.clear();
                  _tagTypeController.clear();
                  _tagDescriptionController.clear();
                },
              ),
              RaisedButton(
                child: Text('CREATE'),
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  if (_tagNameController.value.text.trim() != "" &&
                      _tagTypeController.value.text.trim() != "" &&
                      _tagDescriptionController.value.text.trim() != "") {
                    showInSnackBar(
                        "Tag Created Successfully", TodoColors.accent);
                  } else {
                    showInSnackBar("Please Specify A Value For All Fields",
                        Colors.redAccent);
                  }
                },
              ),
            ],
          ),
        ]);

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
