import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'edit_profile.dart';
import 'color_override.dart';
import 'animated_logo.dart';


class ViewEmergencyPage extends StatefulWidget {
  final String currentUserId;
  ViewEmergencyPage({Key key, this.currentUserId}): super(key: key);

  @override
  ViewEmergencyPageState createState() => ViewEmergencyPageState();
}

class ViewEmergencyPageState extends State<ViewEmergencyPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  final _emergencyContactName = GlobalKey(debugLabel: 'Emergency Contact Name');
  final _emergencyContactPhone = GlobalKey(
      debugLabel: 'Emergency Contact Phone');
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  static String emergencyContactName = "";
  static String emergencyContactPhone = "";
  List<bool> changed = [false, false];
  static final formKey = new GlobalKey<FormState>();
  final _padding = EdgeInsets.all(5.0);
  int _colorIndex = 0;


  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }


  @override
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    String editText = document['editing'] ? 'SAVE':'EDIT';
    return
      ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              AnimatedLogo(animation: animation, message: 'Your Emergency Details', factor: 1.0, colorIndex: _colorIndex,),
            ],
          ),
          Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:<Widget>[

                SizedBox(height: 12.0),
                _buildTile(context, document, 'emergencyContactName', 'Emergency Contact Name', _emergencyContactName, _emergencyContactNameController, 0),

                SizedBox(height: 12.0),
                _buildTile(context, document, 'emergencyContactPhone', 'Emergency Contact Phone', _emergencyContactPhone, _emergencyContactPhoneController, 1),

                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text('CANCEL',),
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                      ),
                      onPressed: () {
                        setState(() {
                          Firestore.instance.runTransaction((transaction) async {
                            DocumentSnapshot snapshot = await transaction. get (
                                document.reference);
                            await transaction.update(
                                snapshot.reference, {
                              'editing': false,
                            });
                          });
                        });

                        showInSnackBar("Leaving Edit Mode ...", TodoColors.baseColors[_colorIndex]);
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                        child:
                        Text(editText
                          , style: TextStyle(color: TodoColors.baseColors[0]),),
                        elevation: 8.0,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        onPressed: () {

                          setState(() {
                            if(editText == 'SAVE') {
                              showInSnackBar("Saving Changes ...", TodoColors.baseColors[_colorIndex]);

                              bool valid = validateAndSave();
                              emergencyContactName= changed[0] ? _emergencyContactNameController.text : document['emergencyContactName'];
                              emergencyContactPhone = changed[1] ? _emergencyContactPhoneController.text : document['emergencyContactPhone'];


                              Firestore.instance.runTransaction((transaction) async {
                                DocumentSnapshot snapshot =
                                await transaction.get(document.reference);

                                await transaction.update(snapshot.reference, {
                                  'emergencyContactPhone': emergencyContactPhone,
                                  'emergencyContactName': emergencyContactName,
                                  'editing':!snapshot['editing'],
                                });
                              });
                            }else {
                              Firestore.instance.runTransaction((transaction) async {
                                DocumentSnapshot snapshot = await transaction. get (
                                    document.reference);
                                await transaction.update(
                                    snapshot.reference, {
                                  'editing': !snapshot['editing']
                                });
                              });
                              showInSnackBar("Entering Edit Mode ...", Colors.redAccent);
                            }
                          });
                        }


                    )
                  ],
                ),],),),
        ],
      );
  }

  Widget _buildTile(BuildContext context, DocumentSnapshot document, String fieldName, String label, GlobalKey mkey,
      TextEditingController controller, int idx){
    changed[idx] = true;
    return ListTile(
      title: Container(
        child: !document['editing']
            ? InputDecorator(
          key: mkey,
          child: Text(
            document[fieldName],
            style: TodoColors.textStyle3.apply(
                color: TodoColors.baseColors[_colorIndex]),
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TodoColors.textStyle2,
            border: CutCornersBorder(),
          ),
        ): PrimaryColorOverride(
          color: TodoColors.baseColors[_colorIndex],
          child: TextFormField(
            key: mkey,
            initialValue: document[fieldName],
            onSaved: (text) {
              controller.text = text;
            },
            onFieldSubmitted: (text) {
              controller.text = text;
            },
            decoration: InputDecoration(
              labelText: label,
              hintText: document[fieldName],
              border: CutCornersBorder(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = Padding(padding: _padding);

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('tables/users/${widget.currentUserId}').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
          {
            return new Center(
                child: new CircularProgressIndicator()
            );
          }else{
            final converter = _buildListItem(context, snapshot.data.documents.first);

            return Padding(
              padding:
              _padding,
              child:
              OrientationBuilder(
                builder: (BuildContext
                context, Orientation orientation) {
                  if (orientation == Orientation.portrait) {
                    return
                      converter;
                  } else {
                    return Center(
                      child: Container(
                        width: 450.0,
                        child: converter,
                      ),
                    );
                  }
                }
                ,
              ),

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

