import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'project_details.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'loading_screen.dart';
import 'my_project_dialog.dart';

class SearchProjectsPage extends StatefulWidget {
  final int colorIndex;
  final bool canRecruit;
  final bool sendWorkRequest;

  const SearchProjectsPage({
    @required this.colorIndex,
    @required this.canRecruit,
    this.sendWorkRequest,
  }) : assert(colorIndex != null), assert(canRecruit != null);

  @override
  SearchProjectsPageState createState() => SearchProjectsPageState();
}

class SearchProjectsPageState extends State<SearchProjectsPage> {

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
          stream: Firestore.instance.collection('projects').getDocuments().asStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Center
                (
                child: new BarLoadingScreen(),
              );
            }
            try {
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
                                      child: Text(project['locations']
                                          .toString()
                                          .substring(1, project['locations']
                                          .toString()
                                          .length - 1),
                                        style: TextStyle(
                                            color: TodoColors.baseColors[widget
                                                .colorIndex]),
                                        softWrap: true,
                                        overflow: TextOverflow.fade,)),
                                  Expanded(child: Text(project['projectTitle'],
                                    style: TodoColors.textStyle6,), flex: 1,)
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
                                      child: Icon(
                                          Icons.search, color: Colors.white,
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
            } catch(e){
              return BarLoadingScreen();
            }

          }),
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


  Widget _buildTile(Widget child, String projectID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: widget.sendWorkRequest != null? (){
              showInSnackBar("Your Work Request For This Project Is Being Created, Reload This Page To See It !!!", Colors.red);
        } :() =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) =>
                        ProjectDetailsPage(colorIndex:widget.colorIndex, projectDocumentID: projectID, canRecruit: widget.canRecruit,))),
            child: child
        )
    );
  }
  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

