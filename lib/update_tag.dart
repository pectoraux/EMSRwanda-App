import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'animated_logo.dart';
import 'loading_screen.dart';

class UpdateTagPage extends StatefulWidget {
  final int colorIndex;
  final String tagDocumentID;

  const UpdateTagPage({
    @required this.colorIndex,
    @required this.tagDocumentID
  }) : assert(colorIndex != null),
        assert(tagDocumentID != null);


  @override
  UpdateTagPageState createState() => UpdateTagPageState();
}

class UpdateTagPageState extends State<UpdateTagPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  final _tagNameController = TextEditingController();
  final _tagName = GlobalKey(debugLabel: 'Tag Name');
  final _tagTypeController = TextEditingController();
  final _tagType = GlobalKey(debugLabel: 'Tag Type');
  int _colorIndex = 0;
  List<bool> hasChanged = [false, false, false, false, false, false, false];

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }



    Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              AnimatedLogo(animation: animation,
                message: 'Update ${document['tagName']} Tag',
                factor: 1.0,
                colorIndex: widget.colorIndex,),
            ],
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[widget.colorIndex],
            child: TextFormField(
              key: _tagName,
              initialValue: document['tagName'],
              onSaved: (text) {
                _tagNameController.text = text;
                hasChanged[0] = true;
              },
              onFieldSubmitted: (text) {
                _tagNameController.text = text;
                hasChanged[0] = true;
              },
              decoration: InputDecoration(
                labelText: 'Tag Name',
                hintText: document['tagName'],
                border: CutCornersBorder(),
              ),
            ),
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[widget.colorIndex],
            child: TextFormField(
              key: _tagType,
              initialValue: document['tagType'],
              onSaved: (text) {
                _tagTypeController.text = text;
                hasChanged[1] = true;
              },
              onFieldSubmitted: (text) {
                _tagTypeController.text = text;
                hasChanged[1] = true;
              },
              decoration: InputDecoration(
                labelText: 'Tag Type',
                hintText: document['tagType'],
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
                    showInSnackBar(
                        "Tag Updated Successfully", TodoColors.accent);
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
    }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('tags').limit(100).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen(),
            );
          } else {
            DocumentSnapshot document = snapshot.data.documents.where((doc){
              return doc.documentID == widget.tagDocumentID;}).first;


            final converter = _buildListItem(
                context, document);

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
        });
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

