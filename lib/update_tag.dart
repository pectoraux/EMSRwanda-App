import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';


class UpdateTagPage extends StatefulWidget {
  @override
  UpdateTagPageState createState() => UpdateTagPageState();
}

class UpdateTagPageState extends State<UpdateTagPage> {
  final _tagNameController = TextEditingController();
  final _tagName = GlobalKey(debugLabel: 'Tag Name');
  final _tagTypeController = TextEditingController();
  final _tagType = GlobalKey(debugLabel: 'Tag Type');
  int _colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final converter = ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[

        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            Image.asset('assets/diamond.png'),
            SizedBox(height: 16.0),
            Text(
              'Update Female Tag',
              style: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
            ),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextField(
            key: _tagName,
            controller: _tagNameController,

            decoration: InputDecoration(
              hintText: "Female",
              hintStyle: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
              helperText: "Female",
              helperStyle: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
              labelText: 'Tag Name',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.accent,
          child: TextField(
            key: _tagType,
            controller: _tagTypeController,

            decoration: InputDecoration(
              hintText: "User Related Tag",
              hintStyle: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
              helperText: "User Related Tag",
              helperStyle: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),
              labelText: 'Tag Type',
              labelStyle: TodoColors.textStyle2,
              border: CutCornersBorder(),
            ),
          ),
        ),

        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              textColor: TodoColors.baseColors[_colorIndex],
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                _tagNameController.clear();
                _tagTypeController.clear();
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('UPDATE'),
              textColor: TodoColors.baseColors[_colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                if (_tagNameController.value.text.trim() != "" &&
                    _tagTypeController.value.text.trim() != "") {
                  showInSnackBar("Tag Updated Successfully", TodoColors.accent);
                } else {
                  showInSnackBar("Please Specify A Value For All Fields",
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
