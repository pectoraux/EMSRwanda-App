import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'review_item.dart';
import 'bad_review_item.dart';
import 'new_review_item.dart';
import 'constants.dart';
import 'my_employment_dialog.dart';
import 'loading_screen.dart';

class SendWorkRequestPage extends StatefulWidget
{
  final int colorIndex;
  final String userDocumentID;
  final String projectDocumentID;

  const SendWorkRequestPage({
    @required this.colorIndex,
    @required this.userDocumentID,
    this.projectDocumentID,
  }) : assert(colorIndex != null), assert(projectDocumentID != null), assert(userDocumentID != null);


  @override
  _SendWorkRequestPageState createState() => _SendWorkRequestPageState();
}

class _SendWorkRequestPageState extends State<SendWorkRequestPage>
{
  bool isDisabled = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String authorId;

  @override
  void initState() {
    super.initState();
    setDefaults();
  }

  Future setDefaults()async {
    user = await _auth.currentUser();
    Firestore.instance.runTransaction((transaction) async {
      Firestore.instance.collection('users/${user.uid}/pending_requests')
          .getDocuments()
          .then((query) {
        query.documents.forEach((doc) {
            if (doc['projectId'] == widget.projectDocumentID &&
                doc['type'] == 'Made By You') {
              setState(() {
                isDisabled = true;
              });
              print('RRRRRRRRR => => => ${doc['projectId']} == ${widget
                  .projectDocumentID}');
            }
        });
      });
    });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    final _projectTitleController = TextEditingController();
    final _projectTitle = GlobalKey(debugLabel: 'Project Title');
    final _projectLocationsController = TextEditingController();
    final _projectTagsController = TextEditingController();
    final _projectLocations = GlobalKey(debugLabel: 'Project Locations');
    final _projectTags = GlobalKey(debugLabel: 'Project Tags');
    final _minRatingController = TextEditingController();
    final _minRating = GlobalKey(debugLabel: 'Minimum Rating');

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text('Projects ${document['firstName']}\nWorked On',
              style: TodoColors.textStyle.apply(color: TodoColors.baseColors[widget.colorIndex])),
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
                      showDialog(context: context, child: new MyEmploymentDialog(colorIndex: widget.colorIndex,));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: ListView
          (
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>
          [
            Container
              (
                margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 54.0),
                child: Material
                  (
                  elevation: 8.0,
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(32.0),
                  child:
                  InkWell
                    (
                    onTap: isDisabled ? (){} : (){_sendWorkRequest();} ,
                    child: Padding
                      (
                      padding: EdgeInsets.all(12.0),
                      child: Column
                        (
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>
                        [
                          Padding(padding: EdgeInsets.only(right: 16.0)),
                           isDisabled ? Text('Work Request Pending', style: TextStyle(color: Colors.redAccent)) :
                           Text('SEND WORK REQUEST', style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  )
                )
            ),
            ReviewItem(colorIndex: widget.colorIndex),
            BadReviewItem(colorIndex: widget.colorIndex),
            NewReviewItem(colorIndex: widget.colorIndex)
          ],
        )
    );
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
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
          'to': widget.userDocumentID,
          'type': 'Made By You',
          'page': 'project_details',
        };

        String myId;
        Firestore.instance.runTransaction((transaction) async {
          DocumentReference ref = Firestore.instance.collection(
              'users/${user.uid}/pending_requests').document();
          myId = ref.documentID;
          DocumentReference reference =
          Firestore.instance.document('users/${user.uid}/pending_requests/${myId}');
          await reference.setData(made_by_you_data);
        });
        Map<String, Object> made_to_data = <String, Object>{
          'projectTitle': doc['projectTitle'],
          'projectId': widget.projectDocumentID,
          'from': user.uid,
          'type': 'Made To You',
          'page': 'project_details',
        };
        Firestore.instance.runTransaction((transaction) async {

          DocumentReference reference =
          Firestore.instance.document(
              'users/${widget.userDocumentID}/pending_requests/${myId}');
          await reference.setData(made_to_data);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen()
            );
          } else {
            final converter = _buildListItem(
                context, snapshot.data.documents.where((user){
               return (user.documentID == widget.userDocumentID);
            }).first);

            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return converter;
                } else {
                  return Center(
                    child: Container(
                      width: 450.0,
                      child: converter,
                    ),
                  );
                }
              },
            );
          }
        });
  }
}