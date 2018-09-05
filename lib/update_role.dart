import 'profile_icons.dart';
import 'package:flutter/material.dart';
import 'color_override.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'animated_logo.dart';
import 'loading_screen.dart';

class UpdateRolePage extends StatefulWidget {
  final int colorIndex;
  final String roleDocumentID;

  const UpdateRolePage({
    @required this.colorIndex,
    @required this.roleDocumentID
  }) : assert(colorIndex != null),
       assert(roleDocumentID != null);


  @override
  UpdateRolePageState createState() => UpdateRolePageState();
}

class UpdateRolePageState extends State<UpdateRolePage>  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  final _roleNameController = TextEditingController();
  final _roleName = GlobalKey(debugLabel: 'Role Name');
  bool _createUserPermission = false, userPermission = false;
  bool _createProjectPermission = false, projectPermission = false;
  bool _createRolePermission = false, rolePermission = false;
  bool _createTagPermission = false, tagPermission = false;
  bool _grantUserPermission = false, grantPermission = false;
  bool _createDevicePermission = false, devicePermission = false;

  List<bool> changed = [false];
  String roleNameStr;
  List<bool> hasChanged = [false, false, false, false, false, false, false];
  DocumentReference document;

  initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = new Tween(begin: 0.0, end: 300.0).animate(controller);
    controller.forward();
  }

  bool allFalse(List<bool> lst){
    for(bool l in lst){
      if (l == true) return false;
    }
    return true;

  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {


    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      children: <Widget>[
        SizedBox(height: 20.0),
        Column(
          children: <Widget>[
            AnimatedLogo(animation: animation, message: 'Update ${document['roleName']} Role', factor: 1.0, colorIndex: widget.colorIndex,),
          ],
        ),

        SizedBox(height: 12.0),
        PrimaryColorOverride(
          color: TodoColors.baseColors[widget.colorIndex],
          child: TextFormField(
            key: _roleName,
            initialValue: document['roleName'],
            onSaved: (text) {
              _roleNameController.text = text;
              hasChanged[0] = true;
            },
            onFieldSubmitted: (text) {
              _roleNameController.text = text;
              hasChanged[0] = true;
            },
            decoration: InputDecoration(
              labelText: 'Role Name',
              hintText: document['roleName'],
              border: CutCornersBorder(),
            ),
          ),
        ),


        new CheckboxListTile(
          title: Text('Can Create User', style: TodoColors.textStyle2,),
          value: hasChanged[1] ? _createUserPermission : document['canCreateUser'],
          activeColor: TodoColors.baseColors[widget.colorIndex],
          onChanged: (bool permission) {
            setState(() {
              _createUserPermission = permission;
              userPermission = permission;
              hasChanged[1] = true;
            });
          },
          secondary: new Icon(
            LineAwesomeIcons.user, color: TodoColors.baseColors[widget.colorIndex],
            size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Create Project', style: TodoColors.textStyle2,),
          value: hasChanged[2] ? projectPermission : document['canCreateProject'],
          activeColor: TodoColors.baseColors[widget.colorIndex],
          onChanged: (bool permission) {
            setState(() {
              _createProjectPermission = permission;
              projectPermission = permission;
              hasChanged[2] = true;
            });
          },
          secondary: new Icon(
            Icons.work, color: TodoColors.baseColors[widget.colorIndex],
            size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Create Role', style: TodoColors.textStyle2,),
          value: hasChanged[3] ? rolePermission : document['canCreateRole'],
          activeColor: TodoColors.baseColors[widget.colorIndex],
          onChanged: (bool permission) {
            setState(() {
              _createRolePermission = permission;
              rolePermission = permission;
              hasChanged[3] = true;
            });
          },
          secondary: new Icon(
            Icons.library_add, color: TodoColors.baseColors[widget.colorIndex],
            size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Create Tag', style: TodoColors.textStyle2,),
          value: hasChanged[4] ? tagPermission : document['canCreateTag'],
          activeColor: TodoColors.baseColors[widget.colorIndex],
          onChanged: (bool permission) {
            setState(() {
              _createTagPermission = permission;
              tagPermission = permission;
              hasChanged[4] = true;
            });
          },
          secondary: new Icon(
            Icons.title, color: TodoColors.baseColors[widget.colorIndex],
            size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Create Device', style: TodoColors.textStyle2,),
          value: hasChanged[5] ? devicePermission : document['canCreateDevice'],
          activeColor: TodoColors.baseColors[widget.colorIndex],
          onChanged: (bool permission) {
            setState(() {
              _createDevicePermission = permission;
              devicePermission = permission;
              hasChanged[5] = true;
            });
          },
          secondary: new Icon(
            Icons.devices, color: TodoColors.baseColors[widget.colorIndex],
            size: 30.0,),
        ),
        new CheckboxListTile(
          title: Text('Can Grant Permission', style: TodoColors.textStyle2,),
          value: hasChanged[6] ? grantPermission : document['canGrantPermission'],
          activeColor: TodoColors.baseColors[widget.colorIndex],
          onChanged: (bool permission) {
            setState(() {
              _grantUserPermission = permission;
              grantPermission = permission;
              hasChanged[6] = true;
            });
          },
          secondary: new Icon(
            LineAwesomeIcons.thumbsUp,
            color: TodoColors.baseColors[widget.colorIndex], size: 30.0,),
        ),


        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                _roleNameController.clear();
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
                roleNameStr = hasChanged[0] ? _roleNameController.text : document['roleName'];
                userPermission = hasChanged[1] ? _createUserPermission: document['canCreateUser'];
                projectPermission = hasChanged[2] ? _createProjectPermission: document['canCreateProject'];
                rolePermission = hasChanged[3] ? _createRolePermission: document['canCreateTag'];
                tagPermission = hasChanged[4] ? _createTagPermission: document['canCreateTag'];
                grantPermission = hasChanged[5] ? _grantUserPermission: document['canGrantPermission'];
                devicePermission = hasChanged[6] ? _createDevicePermission: document['canCreateDevice'];

                if (_roleNameController.value.text.trim() != "" || (!hasChanged[0])) {

                    Firestore.instance.runTransaction((transaction) async {
                      DocumentSnapshot freshSnap =
                      await transaction.get(document.reference);
                      await transaction.update(freshSnap.reference, ({
                        'roleName': roleNameStr,
                        'canCreateUser': userPermission,
                        'canCreateProject': projectPermission,
                        'canCreateTag':tagPermission,
                        'canCreateRole':rolePermission,
                        'canCreateDevice': devicePermission,
                        'canGrantPermission':grantPermission}));
                    });

                    Navigator.of(context).pop();

                  showInSnackBar(
                      "Role Updated Successfully", TodoColors.baseColors[widget.colorIndex]);

                } else {
                  showInSnackBar(
                      "Please Specify A Value For Role Name",
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
        stream: Firestore.instance.collection('roles').limit(100).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen(),
            );
          } else {
            DocumentSnapshot document = snapshot.data.documents.where((doc){
              return doc.documentID == widget.roleDocumentID;}).first;


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

