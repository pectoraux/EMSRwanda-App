import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'employment_history_page.dart';
import 'my_project_dialog.dart';
import 'loading_screen.dart';

class PendingRequestsPage extends StatefulWidget {
  final int colorIndex;

  const PendingRequestsPage({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  PendingRequestsPageState createState() => PendingRequestsPageState();
}

class PendingRequestsPageState extends State<PendingRequestsPage> {

  bool _isMadeByYou;
  String userId;

  @override
  void initState() {
    _isMadeByYou = false;
    FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        userId = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    final _projectTitleController = TextEditingController();
    final _projectTitle = GlobalKey(debugLabel: 'Project Title');
    final _projectLocationsController = TextEditingController();
    final _projectTagsController = TextEditingController();
    final _projectLocations = GlobalKey(debugLabel: 'Project Locations');
    final _projectTags = GlobalKey(debugLabel: 'Project Tags');
    String project_description = "This project is hkkjdkja ljdslad ladjlja alsdjla aljdsla adljld";

    List<StaggeredTile> mTiles = [];
    ScrollController controller = new ScrollController();

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Pending Requests', style: TodoColors.textStyle6),
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
            stream: Firestore.instance.collection('users/${userId}/pending_requests').getDocuments().asStream(),
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
          children: snapshot.data.documents.map((requests) {
//                print(role.documentID + ': ' + role['roleName']);

    mTiles.add(StaggeredTile.extent(2, 110.0));


    return _buildTile(
              context,
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
                          Text(requests['type'],
                              style: (requests['type'] == 'Made By You') ?
                              TextStyle(color: Colors.blueAccent): TextStyle(color:Colors.redAccent)),
                          Text(requests['projectTitle'], style: TodoColors.textStyle6)
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
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
        requests['type'],
              requests['projectTitle'],
        (requests['type'] == 'Made By You') ? requests['to'] : requests['from']
    );
          }).toList(),

    staggeredTiles: mTiles,
    );
  }),
  );
}

  Widget _buildTile(BuildContext context, Widget child, String type, String title, String userDocumentId) {
    bool _madeByYou = (type=="Made By You") ? true : false;
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
            child: child,
          // Do onTap() if it isn't null, otherwise do print()
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
            new EmploymentHistoryPage(colorIndex: widget.colorIndex, isMadeByYou: _madeByYou, noButton: false, documentID: userDocumentId,),),),
        )
    );
  }


  void showTile(BuildContext context, String type, String title, String description){
    String Status;
    title = title.toUpperCase();
    setState(() {
      if(type == "Made By You") {
        _isMadeByYou = true;
        Status = "CANCELLED";
      }else if (type == "Made To You"){
        _isMadeByYou = false;
        Status = "REJECTED";
      }
    });

    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Card(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(title),
                        subtitle: Text(description),
                      ),
                      new ButtonTheme.bar( // make buttons use the appropriate styles for cards
                        child: new ButtonBar(
                          children: <Widget>[
                            BackButton(),
                            new FlatButton(
                              child: Text(
                                  _isMadeByYou ? "CANCEL" : "REJECT"
                              ),
                              textColor: TodoColors.baseColors[widget.colorIndex],
                              onPressed: () {
                                showInSnackBar("WORK REQUEST FOR PROJECT $title HAS BEEN $Status", TodoColors.baseColors[widget.colorIndex]);
                                 },
                            ),
                          ],
                        ),
                      ),

                      new FlatButton(
                        child: Text(
                          "EMPLOYMENT HISTORY",
                        ),
                        textColor: TodoColors.baseColors[widget.colorIndex],
                        onPressed:() {
            },
                            )
                    ],
                  ),
                )
          ],
            ),
          ),
        );
      },
    );
  }
  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
      action: new SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change!
          showInSnackBar2("Previous Action Successfully Undone", TodoColors.baseColors[widget.colorIndex]);
        },
      ),
      duration: kTabScrollDuration*100,
    ));
  }

  void showInSnackBar2(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}

