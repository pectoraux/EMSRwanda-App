import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'color_override.dart';
import 'my_project_dialog.dart';

class ViewProjectsPage extends StatefulWidget {
  final int colorIndex;

  const ViewProjectsPage({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  ViewProjectsPageState createState() => ViewProjectsPageState();
}

class ViewProjectsPageState extends State<ViewProjectsPage> {

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    final _projectTitleController = TextEditingController();
    final _projectTitle = GlobalKey(debugLabel: 'Project Title');
    final _projectLocationsController = TextEditingController();
    final _projectTagsController = TextEditingController();
    final _projectLocations = GlobalKey(debugLabel: 'Project Locations');
    final _projectTags = GlobalKey(debugLabel: 'Project Tags');

    List<StaggeredTile> mTiles = [];
    ScrollController controller = new ScrollController();

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Available Projects', style: TodoColors.textStyle6),
          actions: <Widget>
          [
            Container
              (
              margin: EdgeInsets.only(right: 8.0),
              child: Row
                (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      showDialog(context: context, child: new MyProjectDialog(colorIndex: widget.colorIndex,));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('tables/projects/myProjects').getDocuments().asStream(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                print("SNAPSHOT => => => ${snapshot.data.documents}");
                return new Center
                  (
                    child: new CircularProgressIndicator()
                );
              }
        return StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          controller: controller,
          children: snapshot.data.documents.map((project) {

//                print(role.documentID + ': ' + role['roleName']);

                 mTiles.add(StaggeredTile.extent(2, 110.0));

            return _buildTile(
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                        SizedBox(width: 180.0,
                            child:Text(project['locations'].toString().substring(1,project['locations'].toString().length-1),
                             style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]), softWrap: true, overflow: TextOverflow.fade,) ),
                        Expanded(child:Text(project['projectTitle'], style: TodoColors.textStyle6,),flex: 1,)
                        ],
                      ),
                      Material
                        (
                          color: TodoColors.baseColors[widget.colorIndex],
                          borderRadius: BorderRadius.circular(24.0),
                            child:  Center
                            (
                              child:Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.work, color: Colors.white,
                                    size: 30.0),
                              )
                              ),
                      )
                    ]
                ),
              ),
              project.documentID
              );
          }).toList(),

          staggeredTiles: mTiles,
        );


            }),
    );
  }

  void onTap() {
    new Container(
      width: 450.0,
    );

    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('DELETE  PROJECT', style: TodoColors.textStyle3.apply(color: TodoColors.baseColors[widget.colorIndex]),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Are You Sure You Want To'),
                new Text('Delete Project FSI ?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('CANCEL'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('YES'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {},
            ),

          ],
        );
      },
    );
  }


  Widget _buildTile2(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {
              print('Not set yet');
            },
            child: child
        )
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
            onTap: onTap != null ? () => onTap() : () {
              print('Not set yet');
            },
            child: child
        )
    );
  }
}

