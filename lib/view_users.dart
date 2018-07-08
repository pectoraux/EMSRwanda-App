import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'user_history_page.dart';
import 'loading_screen.dart';
import 'my_user_dialog.dart';

class ViewUsersPage extends StatefulWidget {
  final int colorIndex;
  final String projectDocumentId;

  const ViewUsersPage({
    @required this.colorIndex,
    this.projectDocumentId,
  }) : assert(colorIndex != null);

  @override
  ViewUsersPageState createState() => ViewUsersPageState();
}

class ViewUsersPageState extends State<ViewUsersPage> {
  String userName = '', locations = '';
  bool read = false;
  List project_users = [];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

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


    Firestore.instance.collection('projects/${widget.projectDocumentId}/users').getDocuments().then((query) {
      List results = [];
      setState(() {
        for (DocumentSnapshot doc in query.documents) {
            results.add(doc.documentID);
        }
        project_users = results;
      });
    });

    print('JJJJJJJJJJJJ => => => ${project_users}');

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text((widget.projectDocumentId != null) ? 'Project Staff' : 'Available Users',
               style: TodoColors.textStyle6),
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

                  if(widget.projectDocumentId != null ) {
                    if (!project_users.contains('${user.documentID}')) {
                      return false;
                    }
                  }
                  return true;
                }).map((user) {

//                  print(user.documentID + ': ' + user['userName']);

                  mTiles.add(StaggeredTile.extent(2, 110.0));
                  print('VVVVVVVVV => => =>  ${user.documentID}');

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
    user.documentID
    );
  }).toList(),



  staggeredTiles: mTiles,
  );


}),
);
}



  Widget _buildTile(Widget child, String userID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: () =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UserHistoryPage(colorIndex:widget.colorIndex, userDocumentID: userID,))),
            child: child
        )
    );
  }
}



