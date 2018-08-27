import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'staff_stats.dart';
import 'view_devices.dart';
import 'notifications.dart';
import 'supplemental/cut_corners_border.dart';
import 'color_override.dart';
import 'my_project_details_dialog.dart';
import 'loading_screen.dart';

class ProjectDetailsPage extends StatefulWidget {
  final int colorIndex;
  final String projectDocumentID;
  final bool canRecruit;

  const ProjectDetailsPage({
    @required this.colorIndex,
    @required this.projectDocumentID,
    @required this.canRecruit,
  }) : assert(colorIndex != null), assert(projectDocumentID != null), assert(canRecruit != null);

  @override
  ProjectDetailsPageState createState() => ProjectDetailsPageState();
}

class ProjectDetailsPageState extends State<ProjectDetailsPage> {

  String locations;
  String title = '';
  int people_surveyed = 100;
  final _projectDescriptionController = TextEditingController();
  final _projectDescription = GlobalKey(debugLabel: 'Project Description');
  String author = '';//'Anirudh\nRajashekar';
  String authorId = '';
  bool isDisabled = false, isStaff = false;
  List user_projects = [];

  final List<List<double>> charts =
  [
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
    ],
    [
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4,
      0.0,
      0.3,
      0.7,
      0.6,
      0.55,
      0.8,
      1.2,
      1.3,
      1.35,
      0.9,
      1.5,
      1.7,
      1.8,
      1.7,
      1.2,
      0.8,
      1.9,
      2.0,
      2.2,
      1.9,
      2.2,
      2.1,
      2.0,
      2.3,
      2.4,
      2.45,
      2.6,
      3.6,
      2.6,
      2.7,
      2.9,
      2.8,
      3.4
    ]
  ];

  static final List<String> chartDropdownItems = [
    'Last 7 days', 'Last month', 'Last year'];
  String actualDropdown = chartDropdownItems[0];
  int actualChart = 0;
  String button_message = '';
  bool isUpcoming, isOngoing = true;
  final _raisedButton = GlobalKey(debugLabel: 'Raised Button');
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    setDefaults();
  } //  int last_index = actualChart;

  Future setDefaults()async {
    user = await _auth.currentUser();
    Firestore.instance.runTransaction((transaction) async {
      Firestore.instance.collection('users/${user.uid}/pending_requests')
          .getDocuments()
          .then((query) {
        query.documents.forEach((doc) {
          if (doc['projectId'] == widget.projectDocumentID) {
            isDisabled = true;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');

          return Scaffold
            (
              appBar: AppBar
                (
                leading: new BackButton(key: _bkey, color: Colors.black,),
                elevation: 2.0,
                backgroundColor: Colors.white,
                title: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.person, color: Colors.black54, size: 20.0,),
                    SizedBox(width: 2.0,),
                    new Expanded(child:
                    new Text('${author}', style: TodoColors.textStyle4),
                        flex: 1,
                      )
                  ],
                ),
                actions: <Widget>
                [
                  Container
                    (
                    child: Row
                      (
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: <Widget>
                      [
                        !isOngoing ?
                  !isDisabled ?
                        RaisedButton(
                          key: _raisedButton,
                          padding: EdgeInsets.all(18.0),
                          onPressed: isDisabled ? () => showInSnackBar('You Already Sent A Work Request', Colors.redAccent) : (){_sendWorkRequest();},
                          child:   Text(button_message, style: TodoColors.textStyle4,),
                        )
    : Center(child:Text(button_message, style: TodoColors.textStyle4, textDirection: TextDirection.ltr,) )
        : Container()
                      ],
                    ),
                  )
                ],
              ),
              body: StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('projects')
        .getDocuments()
        .asStream(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {

    return new Center
    (
    child: new BarLoadingScreen(),
    );
    }
//    snapshot.data.documents['author'];
    DocumentSnapshot project = snapshot.data.documents.where((doc){
      return doc.documentID == widget.projectDocumentID;
    }).first;


      isUpcoming = !(project['startDate'].isBefore(DateTime.now()) || project['endDate'].isBefore(DateTime.now()));
      isOngoing = !(project['startDate'].isAfter(DateTime.now()) || project['endDate'].isBefore(DateTime.now()));

      Firestore.instance.collection('users/${user.uid}/projects').getDocuments().then((query) {
        List results = [];
        setState(() {
          for (DocumentSnapshot doc in query.documents) {
            results.add(doc.documentID);
          }
          user_projects = results;
          setState(() {
            isStaff = user_projects.contains(widget.projectDocumentID);
            if(isStaff){
              isDisabled = true;
            }
          });
        });
      }).whenComplete((){

      Firestore.instance.document('users/${project['author']}'). get().then((doc){
      setState(() {
      author = '${doc['firstName']}\n${doc['lastName']}';
      button_message = isStaff ? 'STAFF MEMBER' : isUpcoming ? 'Send   Work   Request' : isOngoing ? '': 'Send   Payment   Request';
      });
      });
      });

      title = project['projectTitle'];
      authorId = project['author'];
    return StaggeredGridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                children: <Widget>[
                  _buildTile2(
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
                                  Text(project['locations']
                                      .toString()
                                      .substring(1, project['locations']
                                      .toString()
                                      .length - 1),
                                      style: TextStyle(
                                          color: TodoColors.baseColors[widget
                                              .colorIndex])),
                                  Text(project['projectTitle'], style: TodoColors.textStyle6),
                                ],
                              ),
                              Material
                                (
                                  color: TodoColors.baseColors[widget
                                      .colorIndex],
                                  borderRadius: BorderRadius.circular(24.0),

                                  child: Center
                                    (
                                      child: Padding
                                        (
                                        padding: const EdgeInsets.all(16.0),
                                        child: Icon(isUpcoming ? Icons.group_work
                                        :isOngoing ? Icons.work:
                                            Icons.close, color: Colors.white,
                                            size: 30.0),
                                      )
                                  )
                              )
                            ]
                        ),
                      ),
                      project['locations']
                          .toString()
                          .substring(1, project['locations']
                          .toString()
                          .length - 1),
                      project['projectTitle'],
                      project['projectDescription'],
                    project['startDate'],
                    project['endDate']
                  ),
                  _buildTile(
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column
                        (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>
                          [
                            Material
                              (
                                color: Colors.teal,
                                shape: CircleBorder(),
                                child: Padding
                                  (
                                  padding: const EdgeInsets.all(16.0),
                                  child: Icon(Icons.settings_applications,
                                      color: Colors.white, size: 30.0),
                                )
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text('General', style: TodoColors.textStyle6),
                            Expanded(child: Text('Staff & Stats\nScan QR Code',
                                style: TextStyle(color: Colors.black45)),
                              flex: 1,),
                          ]
                      ),
                    ),
                    onTap: () {

                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) =>
                              StaffNStatsPage(
                                colorIndex: widget.colorIndex,
                                projectDocumentId: widget.projectDocumentID,
                                canRecruit: widget.canRecruit,)));
                    }
                  ),
                  _buildTile(
                    Padding
                      (
                      padding: const EdgeInsets.all(24.0),
                      child: Column
                        (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>
                          [
                            Material
                              (
                                color: TodoColors.baseColors[widget.colorIndex],
                                shape: CircleBorder(),
                                child: Padding
                                  (
                                  padding: EdgeInsets.all(16.0),
                                  child: Icon(
                                      Icons.notifications, color: Colors.white,
                                      size: 30.0),
                                )
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text('Alerts', style: TodoColors.textStyle6),
                            Text('All ',
                                style: TextStyle(color: Colors.black45)),
                          ]
                      ),
                    ),
//                    onTap: () =>
//                        Navigator.of(context).push(
//                            MaterialPageRoute(builder: (_) => NotificationsPage(
//                              colorIndex: widget.colorIndex,))),
                  ),
                  _buildTile(
                    Padding
                      (
                        padding: const EdgeInsets.all(24.0),
                        child: Column
                          (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>
                          [
                            Row
                              (
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>
                              [
                                Column
                                  (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>
                                  [
                                    Text('People Surveyed',
                                        style: TextStyle(
                                            color: TodoColors.baseColors[widget
                                                .colorIndex])),
                                    Text('${people_surveyed}',
                                        style: TodoColors.textStyle6),
                                  ],
                                ),
                                DropdownButton
                                  (
                                    isDense: true,
                                    value: actualDropdown,
                                    onChanged: (String value) =>
                                        setState(() {
                                          actualDropdown = value;
                                          int last_index = actualChart;
                                          actualChart =
                                              chartDropdownItems.indexOf(
                                                  value); // Refresh the chart
                                          if (actualChart > last_index) {
                                            people_surveyed =
                                                people_surveyed + 100;
                                          } else {
                                            people_surveyed =
                                                people_surveyed - 100;
                                          }
                                        }),
                                    items: chartDropdownItems.map((
                                        String title) {
                                      return DropdownMenuItem
                                        (
                                        value: title,
                                        child: Text(title,
                                            style: TodoColors.textStyle6),
                                      );
                                    }).toList()
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 4.0)),
                            Sparkline
                              (
                              data: charts[actualChart],
                              lineWidth: 5.0,
                              lineColor: TodoColors.baseColors[widget
                                  .colorIndex],
                            )
                          ],
                        )
                    ),
                  ),
                  _buildTile(
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
                                Text('Devices',
                                    style: TextStyle(
                                        color: TodoColors.baseColors[widget
                                            .colorIndex])),
                                Text('173', style: TodoColors.textStyle6)
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
                                      padding: EdgeInsets.all(16.0),
                                      child: Icon(
                                          Icons.devices, color: Colors.white,
                                          size: 30.0),
                                    )
                                )
                            )
                          ]
                      ),
                    ),
                    onTap: () =>
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ViewDevicesPage(
                              colorIndex: widget.colorIndex, documentID: project.documentID, folder: 'projectDevices',))),
                  )
                ],
                staggeredTiles: [
                  StaggeredTile.extent(2, 110.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(1, 180.0),
                  StaggeredTile.extent(2, 220.0),
                  StaggeredTile.extent(2, 110.0),
                ],
              );
          })
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
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

  void _sendWorkRequest() async {
    if(!isDisabled) {

      setState(() {
        isDisabled = true;
      });

      Firestore.instance.document('projects/${widget.projectDocumentID}')
          .get()
          .then((doc) {
        Map<String, Object> made_by_you_data = <String, Object>{
          'projectTitle': doc['projectTitle'],
          'projectId': widget.projectDocumentID,
          'to': authorId,
          'page': 'project_details',
          'type': 'Made By You',
        };

        String myId;
        Firestore.instance.runTransaction((transaction) async {
          DocumentReference ref = Firestore.instance.collection(
              'users/${user.uid}/pending_requests').document();
          myId = ref.documentID;
          DocumentReference reference =
          Firestore.instance.document('users/${user.uid}/pending_requests/${myId}');
          await reference.setData(made_by_you_data);
        }).whenComplete(() {
          Map<String, Object> made_to_data = <String, Object>{
            'projectTitle': doc['projectTitle'],
            'projectId': widget.projectDocumentID,
            'from': user.uid,
            'page': 'project_details',
            'type': 'Made To You',
          };
          Firestore.instance.runTransaction((transaction) async {
            DocumentReference reference =
            Firestore.instance.document(
                'users/${authorId}/pending_requests/${myId}');
            await reference.setData(made_to_data);
          });
        });
      });
    }
  }

  Widget _buildTile2(Widget child, String locations, String title, String description, DateTime startDate, DateTime endDate) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: () {
              showDialog(context: context, child: new MyProjectDetailsDialog(colorIndex: widget.colorIndex, title: title,
              project_description: description, locations: locations, startDate: startDate, endDate: endDate,));
            },
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