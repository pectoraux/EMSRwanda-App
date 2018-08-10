import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'user_history_page.dart';
import 'loading_screen.dart';
import 'my_user_dialog.dart';

class ProjectStaffPage extends StatefulWidget {
  final int colorIndex;
  final String projectDocumentId;
//  final bool canRateUser;
//  final bool canRecruit;

  const ProjectStaffPage({
    @required this.colorIndex,
    this.projectDocumentId,
//    @required this.canRateUser,
//    @required this.canRecruit,
  }) : assert(colorIndex != null);
//        assert(canRateUser != null), assert(canRecruit != null);

  @override
  ProjectStaffPageState createState() => ProjectStaffPageState();
}

class ProjectStaffPageState extends State<ProjectStaffPage> {
  String userName = '', locations = '';
  bool read = false;
  List project_users = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  int userGroup;
  String userDocumentID, name;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefaults();
  }

  void setDefaults() async {
    user = await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    final _userNameController = TextEditingController();
    final _userName = GlobalKey(debugLabel: 'User Name');
    final _userRoleController = TextEditingController();
    final _userRole = GlobalKey(debugLabel: 'User Role');
    final _userStatusController = TextEditingController();
    final _userStatus = GlobalKey(debugLabel: 'User Status');
    final _userLocationsController = TextEditingController();
    final _tagsController = TextEditingController();
    final _userLocations = GlobalKey(debugLabel: 'Users Locations');
    final _tags = GlobalKey(debugLabel: 'Project or User Related Tags');
    List<StaggeredTile> mTiles = [];
    ScrollController controller = new ScrollController();

    Firestore.instance.collection('projects/${widget.projectDocumentId}/users').getDocuments().then((query){
       for (DocumentSnapshot doc in query.documents) {
          if(doc.documentID == user.uid) {
            setState(() {
              userGroup = doc['userGroup'];
            });
          }
        }
    }).whenComplete(() {
      Firestore.instance.collection(
          'projects/${widget.projectDocumentId}/users').getDocuments().then((
          query) {
        List results = [];
        setState(() {
          for (DocumentSnapshot doc in query.documents) {
            if(doc['userGroup'] == userGroup || userGroup == -1) {
              results.add(doc.documentID);
            }
          }
          project_users = results;
        });
      });
    });

    return Scaffold
      (
      appBar: AppBar
        (
        key: _scaffoldKey,
        leading: new BackButton(key: _bkey, color: Colors.black,),
        elevation: 2.0,
        backgroundColor: Colors.white,
        title: Text('Project Staff', style: TodoColors.textStyle6),
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
                    showDialog(context: context, child: new MyUserDialog(colorIndex: widget.colorIndex,));
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('users').getDocuments().asStream(),
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
              children: snapshot.data.documents.where((user){
                  if (!project_users.contains('${user.documentID}')) {
                    return false;
                }
                return true;
              }).map((user) {

                mTiles.add(StaggeredTile.extent(2, 110.0));

                userName = "${user['firstName']} ${user['lastName']}";
                locations = user['locations']
                    .toString()
                    .substring(1, user['locations']
                    .toString()
                    .length - 1);

                if(userName.trim().isEmpty)
                  userName = 'Missing User Name';
                if(locations.trim().isEmpty)
                  locations = 'Missing Locations';

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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>
                              [
                                SizedBox(width: 180.0,
                                    child:Text(locations,
                                      style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]),) ),

                                Expanded(child:Text(userName, style: TodoColors.textStyle6), flex: 1,),
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
                                      child: Icon(LineAwesomeIcons.user, color: Colors.white,
                                          size: 30.0),
                                    )
                                )
                            )
                          ]
                      ),
                    ),
                    userName,
                    user.documentID
                );
              }).toList(),
              staggeredTiles: mTiles,
            );
          }),
    );
  }


  void _bottomDialog(String fullName, String muserID) {
    new Container(
      width: 450.0,
    );
    setState(() {
      userDocumentID = muserID;
      name = fullName;
    });

    showModalBottomSheet(
        context: context,
        builder: (builder){
      return new Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.work, color: TodoColors.baseColors[widget.colorIndex],),
                title: new Text('View ${name} Project Details'),
                onTap: gotoUserHistory,
              ),
              new ListTile(
                  leading: new Icon(Icons.delete, color: Colors.red,),
                  title: new Text('Delete ${name} Project'),
                  onTap: showDeleteDialog
              ),
            ],
          )
      );
    });
  }

  void gotoUserHistory(){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>
            UserHistoryPage(colorIndex: widget.colorIndex,
                userDocumentID: userDocumentID,
                canRateUser: true,
                canRecruit: true,
                noButton: false,
                projectDocumentID: widget.projectDocumentId)));
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
                new Text('Delete Project ?'),
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
              onPressed: dropUserFromProject,
            ),

          ],
        );
      },
    );

  }

  void dropUserFromProject(){

  }

  Widget _buildTile(Widget child, String uName, String userID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: (){ _bottomDialog(uName, userID);},
            child: child
        )
    );
  }
}



