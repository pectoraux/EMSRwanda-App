import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'user_history_page.dart';
import 'loading_screen.dart';
import 'my_user_dialog.dart';
import 'update_user.dart';

class ViewUsersAdminPage extends StatefulWidget {
  final int colorIndex;
  final List res;

  const ViewUsersAdminPage({
    @required this.colorIndex,
    this.res,
  }) : assert(colorIndex != null);

  @override
  ViewUsersAdminPageState createState() => ViewUsersAdminPageState();
}

class ViewUsersAdminPageState extends State<ViewUsersAdminPage> {
  String userName = '', locations = '', userDocumentID = '', name = '';
  bool read = false;
  List project_users = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
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
        title: Text('Available Users',
            style: TodoColors.textStyle6),
        actions: <Widget>
        [
          Container(
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
                  onPressed: ()  async {
                    new Container(
                      width: 450.0,
                    );

                    List mres = await showDialog(context: context, child: new MyUserDialog(colorIndex: widget.colorIndex,));
 Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ViewUsersAdminPage(colorIndex: widget.colorIndex, res: mres,)));
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
              }).take(10).map((user) {
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
                                userName.length < 15 ?
                                Text(userName, style: TodoColors.textStyle6) : Text(userName.substring(0, 15)+'...', style: TodoColors.textStyle6),
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

  void updateUser(){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => UpdateUserPage(userDocumentID: userDocumentID, colorIndex: widget.colorIndex,),)
    );
  }

  void gotoUserHistory(){

    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) =>
            UserHistoryPage(colorIndex: widget.colorIndex,
              userDocumentID: userDocumentID,
              canRateUser: false,
              canRecruit: false,
              noButton: true, isStaff: false,)));
  }

  void showDeleteDialog(){
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('DELETE  USER', style: TodoColors.textStyle3.apply(color: Colors.red),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Are You Sure You Want To'),
                new Text('Delete User ${name} ?'),
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
              onPressed: deleteUser,
            ),

          ],
        );
      },
    );

  }

  void onTap(String fullName, String userID) {
    new Container(
      width: 450.0,
    );

    setState(() {
      userDocumentID = userID;
      name = fullName;
    });

    _scaffoldKey.currentState
        .showBottomSheet<Null>((BuildContext context) {
      return new Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.work, color: TodoColors.baseColors[widget.colorIndex],),
                title: new Text("View ${name}'s History"),
                onTap: gotoUserHistory,
              ),
              new ListTile(
                leading: new Icon(Icons.update, color: TodoColors.baseColors[widget.colorIndex],),
                title: new Text("Update ${name}'s Information"),
                onTap: updateUser,
              ),
              new ListTile(
                  leading: new Icon(Icons.delete, color: Colors.red,),
                  title: new Text('Delete User ${name}'),
                  onTap: showDeleteDialog
              ),
            ],
          ));
    });
  }

  Widget _buildTile(Widget child, String mName, String userID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap(mName, userID) : () {
              print('Not set yet');
            },
            child: child
        )
    );
  }

  void deleteUser() async {
    DocumentReference userRef = Firestore.instance.document('users/${userDocumentID}');
//    await userRef.delete();

    Navigator.of(context).pop();
  }

}