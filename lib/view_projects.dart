import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'project_details.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'loading_screen.dart';
import 'my_project_dialog.dart';
import 'update_project.dart';

class ViewProjectsPage extends StatefulWidget {
  final int colorIndex;
  final List<String> roles;
  final List<String> tags;
  final List<String> devices;
  final List res;

  const ViewProjectsPage({
    @required this.colorIndex,
  @required this.roles,
  @required this.tags,
  @required this.devices,
    this.res,
  }) ;//: assert(colorIndex != null), assert(roles != null), assert(tags != null), assert(devices != null);

  @override
  ViewProjectsPageState createState() => ViewProjectsPageState();
}

class ViewProjectsPageState extends State<ViewProjectsPage> {
  String projectDocumentID, title;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
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
                    onPressed: () async {
                      new Container(
                        width: 450.0,
                      );
                      List mres = await showDialog(context: context, child: new MyProjectDialog(colorIndex: widget.colorIndex,));
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ViewProjectsPage(colorIndex: widget.colorIndex, roles: widget.roles, tags: widget.tags,
                            devices: widget.devices, res: mres,),));
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
        return StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          controller: controller,
          children: snapshot.data.documents.where((project){
            if(widget.res != null) {
              Map final_result = widget.res[0];
              return (final_result['projectTitle'] != null ? final_result['projectTitle'].toString().toLowerCase().trim() == project['projectTitle'].toString().toLowerCase().trim(): true) &&
                  (final_result['locations'] != null ? hasElement(final_result['locations'], project['locations']): true) &&
                  (final_result['tags'] != null ? hasElement(final_result['tags'], project['tags']): true);
            }
            return true;
          }).map((project) {

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
              project['projectTitle'],
              project.documentID
              );
          }).toList(),

          staggeredTiles: mTiles,
        );


            }),
    );
  }

  bool hasElement(List fromQuery, List fromDb){
      for(String fromq in fromQuery){
        if(fromDb.contains(fromq)){
          return true;
        }
      }
      return false;
  }


  void onTap(String projectTitle, String projectID) {
    new Container(
      width: 450.0,
    );
    setState(() {
      projectDocumentID = projectID;
      title = projectTitle;
    });

    _scaffoldKey.currentState
        .showBottomSheet<Null>((BuildContext context) {
      return new Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.work, color: TodoColors.baseColors[widget.colorIndex],),
                title: new Text('View ${projectTitle} Project Details'),
                onTap: gotoProjectDetails,
              ),
              new ListTile(
                leading: new Icon(Icons.update, color: TodoColors.baseColors[widget.colorIndex],),
                title: new Text('Update ${projectTitle} Project Information'),
                onTap: updateProject,
              ),
              new ListTile(
                  leading: new Icon(Icons.delete, color: Colors.red,),
                  title: new Text('Delete ${projectTitle} Project'),
                  onTap: showDeleteDialog
              ),
            ],
          ));
    });
  }

  void updateProject(){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => UpdateProjectPage(projectDocumentID: projectDocumentID,
          tags: widget.tags, devices: widget.devices, roles: widget.roles,),)
    );
  }

  void gotoProjectDetails(){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProjectDetailsPage(colorIndex: widget.colorIndex,
          projectDocumentID: projectDocumentID, canRecruit: true,),)
    );
  }

void showDeleteDialog(){


  showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('DELETE  PROJECT', style: TodoColors.textStyle3.apply(color: Colors.red),
        ),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text('Are You Sure You Want To'),
              new Text('Delete ${title} Project ?'),
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
            textColor: Colors.red,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: (){
              deleteProject();
              Navigator.of(context).pop();
            }
          ),

        ],
      );
    },
  );
}

void deleteUser(String user) async {
  DocumentReference userRef = Firestore.instance.document('projects/${projectDocumentID}/users/${user}');
  await userRef.delete();
}

  void deleteDevice(String device) async {
    DocumentReference deviceRef = Firestore.instance.document('projects/${projectDocumentID}/devices/${device}');
    await deviceRef.delete();
  }

void deleteProject()  {
  Firestore.instance.runTransaction((transaction) async {
    Firestore.instance.collection('projects/${projectDocumentID}/users').getDocuments().then((query){
      for (DocumentSnapshot doc in query.documents) {
        deleteUser(doc.documentID);
      }
    });
    Firestore.instance.collection('projects/${projectDocumentID}/devices').getDocuments().then((query){
      for (DocumentSnapshot doc in query.documents) {
        deleteDevice(doc.documentID);
      }
    });
    DocumentReference projRef = Firestore.instance.document('projects/${projectDocumentID}');
    await projRef.delete();
  });
  Navigator.of(context).pop();
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


  Widget _buildTile(Widget child, String projectTitle, String projectID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap(projectTitle, projectID) : () {
              print('Not set yet');
            },
            child: child
        )
    );
  }
}

