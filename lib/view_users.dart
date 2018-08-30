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
  final bool canRateUser;
  final bool canRecruit;
  final bool noButton;
  final List res;

  const ViewUsersPage({
    @required this.colorIndex,
    this.projectDocumentId,
    @required this.canRateUser,
    @required this.canRecruit,
    this.res,
    this.noButton,
  }) : assert(colorIndex != null),
  assert(canRateUser != null), assert(canRecruit != null);

  @override
  ViewUsersPageState createState() => ViewUsersPageState();
}

class ViewUsersPageState extends State<ViewUsersPage> {
  String userName = '', locations = '', userDocumentID = '';
  bool read = false;
  List project_users = [];
  List user_projects = [];

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
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

//    print('JJJJJJJJJJJJ => => => ${project_users}');

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Available Users', style: TodoColors.textStyle6),
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
                    onPressed: ()async {
                      new Container(
                        width: 450.0,
                      );
                      List mres = await showDialog(context: context, child: new MyUserDialog(colorIndex: widget.colorIndex,));
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ViewUsersPage(colorIndex: widget.colorIndex, res: mres,
                        canRateUser: true, canRecruit: widget.canRecruit, projectDocumentId: widget.projectDocumentId,)));
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
                  if(widget.res != null) {
                    Map final_result = widget.res[0];
                    return (final_result['firstName'] != null ? final_result['firstName'] == user['firstName']: true) &&
                        (final_result['lastName'] != null ? final_result['lastName'] == user['lastName']: true) &&
                        (final_result['userRole'] != null ? final_result['userRole'] == user['userRole']: true) &&
                        (final_result['userStatus'] != null ? final_result['userStatus'] == user['userStatus']: true);
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
                  userDocumentID = user.documentID;

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
            onTap: () {
              bool isStaff = false;

              Firestore.instance.collection('users/${userID}/projects').getDocuments().then((query) {
                  for (DocumentSnapshot doc in query.documents) {
                    if (doc.documentID == widget.projectDocumentId) {
                      isStaff = true;
//                      print('TTTVVVVVVVVV => => =>  ${widget.projectDocumentId} <= <= <= ${doc.documentID}');
                    }
                  }
              }).whenComplete(() {
//                print("FFFFFFFFF => => => ${isStaff} <= <= <= ${widget
//                    .projectDocumentId}");
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) =>
                        UserHistoryPage(colorIndex: widget.colorIndex,
                            userDocumentID: userID,
                            canRateUser: widget.canRateUser,
                            canRecruit: widget.canRecruit,
                            noButton: widget.noButton,
                            projectDocumentID: widget.projectDocumentId,
                            isStaff: isStaff)));
              });
              },
            child: child
        )
    );
  }
}



