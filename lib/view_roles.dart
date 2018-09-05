import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'update_role.dart';
import 'constants.dart';
import 'supplemental/cut_corners_border.dart';
import 'color_override.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loading_screen.dart';

class ViewRolesPage extends StatefulWidget {
  final int colorIndex;
  final List res;

  const ViewRolesPage({
    @required this.colorIndex,
    this.res,
  }) : assert(colorIndex != null);

  @override
  ViewRolesPageState createState() => ViewRolesPageState();
}

class ViewRolesPageState extends State<ViewRolesPage> {
  static const _padding = EdgeInsets.all(5.0);
  List<String> roles;
  Map<String, Object> search_data = <String, Object>{};

  @override
  Widget build(BuildContext context) {
    final _roleNameController = TextEditingController();
    final _roleName = GlobalKey(debugLabel: 'Project Title');
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    List<StaggeredTile> mTiles = [];
    ScrollController controller = new ScrollController();

    return Scaffold
      (

        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          title: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 14.0,),
              new Text('Available Roles', style: TodoColors.textStyle6),
            ],
          ),
          elevation: 2.0,
          backgroundColor: Colors.white,
          actions: <Widget>
          [
            Container
              (
              margin: EdgeInsets.only(right: 8.0),
              child: Row
                (
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>
                [
                  new FloatingActionButton(
                    elevation: 200.0,
                    child: new Icon(Icons.search),
                    backgroundColor: TodoColors.baseColors[widget.colorIndex],
                    onPressed: () {
                      new Container(
                        width: 450.0,
                      );

                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text(
                              'Search Roles to Update', style: TodoColors.textStyle.apply(color: TodoColors.baseColors[widget.colorIndex]),),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  SizedBox(height: 12.0),
                              PrimaryColorOverride(
                                color: TodoColors.baseColors[widget.colorIndex],
                                child: TextField(
                                    key: _roleName,
                                    controller: _roleNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Role Name',
                                      labelStyle: TodoColors.textStyle2,
                                      border: CutCornersBorder(),
                                    ),
                                  ),
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
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(7.0)),
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
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(7.0)),
                                ),
                                onPressed: () {
                                  search_data['roleName'] = _roleNameController.value.text;
                                  _roleNameController.clear();
                                  Navigator.of(context).pop();
                                },
                              ),

                            ],
                          );
                        },
                      );
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ViewRolesPage(colorIndex: 0, res: [search_data],)));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body:  StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('roles').getDocuments().asStream(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
//                print("SNAPSHOTn => => => ${snapshot.data.documents}");
                return new Center
                  (
                    child: new BarLoadingScreen(),
                );
              }
//              print("SNAPSHOT => => => ${snapshot.data.documents}");
        return StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          controller: controller,
          children: snapshot.data.documents.where((role){
            if(widget.res != null) {
              Map final_result = widget.res[0];
              return (final_result['roleName'] != "" ? final_result['roleName'] == role['roleName']: true);
            }
            return true;
          }).map((role) {

                print(role.documentID + ': ' + role['roleName']);

                mTiles.add(StaggeredTile.extent(2, 110.0));

                return  _buildTile(
                  Padding
                    (
                    padding: const EdgeInsets.all(24.0),
                    child: Row
                      (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>
                        [
                          Column
                            (
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>
                            [
                              Text(role['roleName'], style: TodoColors.textStyle6)
                            ],
                          ),
                          Material
                            (
                              color: TodoColors.baseColors[widget.colorIndex],
                              borderRadius: BorderRadius.circular(24.0),
                              child: Center
                                (
                                  child: Padding
                                    (
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.library_add, color: Colors.white,
                                        size: 30.0),
                                  )
                              )
                          )
                        ]
                    ),
                  ),
                    role.documentID
                );
              }).toList(),



          staggeredTiles: mTiles,
        );


            }),
    );
  }

  Widget _buildTile(Widget child, String roleID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: () =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UpdateRolePage(colorIndex:widget.colorIndex, roleDocumentID: roleID,))),
            child: child
        )
    );
  }
}