import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'good_review_item.dart';
import 'bad_review_item.dart';
import 'new_review_item.dart';
import 'constants.dart';
import 'my_employment_dialog.dart';
import 'loading_screen.dart';
import 'pending_requests.dart';
import 'category_route.dart';

class EmploymentHistoryPage extends StatefulWidget
{
  final int colorIndex;
  final bool isMadeByYou;
  final bool noButton;
  final String documentID;
  final bool canRecruit;
  final String projectDocumentID;
  final String requestId;

  const EmploymentHistoryPage({
    @required this.colorIndex,
    @required this.isMadeByYou,
    @required this.noButton,
    @required this.documentID,
    @required this.canRecruit,
    this.requestId,
    this.projectDocumentID,
  }) : assert(colorIndex != null),
        assert(isMadeByYou != null),
       assert(noButton != null), assert(canRecruit != null);


  @override
  _EmploymentHistoryPageState createState() => _EmploymentHistoryPageState();
}

class _EmploymentHistoryPageState extends State<EmploymentHistoryPage>
{
  bool isDisabled = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String authorId;
  String currentGroup, teamCount, staffCount, currentGroupCount, gender;

  @override
  void initState() {
    super.initState();
    try {
      if (widget.projectDocumentID != null) {
        print("=> => => projectId: ${widget.projectDocumentID}");
        setDefaults();
      }
//      print("=> => => No projectId: ${widget.projectDocumentID}");
    } catch(_){

    }
  }

  Future setDefaults()async {
    user = await _auth.currentUser();
    Firestore.instance.runTransaction((transaction) async {
      Firestore.instance.collection('users/${user.uid}/pending_requests')
          .getDocuments()
          .then((query) {
        query.documents.forEach((doc) {
            if (doc['projectId'] == widget.projectDocumentID) {
              setState(() {
                isDisabled = true;
              });
//              print('RRRRRRRRR => => => ${doc['projectId']} == ${widget
//                  .projectDocumentID}');
            }
        });
      });
    });

    Firestore.instance.runTransaction((transaction) async {
      Firestore.instance.document('projects/${widget.projectDocumentID}')
          .get()
          .then((doc) {
            setState(() {
              currentGroup = doc['currentGroup'].toString();
              teamCount = doc['teamCount'].toString();
              staffCount = doc['staffCount'].toString();
              currentGroupCount = doc['currentGroupCount'].toString();
            });
      });
    });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');

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
                  child: widget.noButton ? new Container() :
                  InkWell
                    (
                    onTap: widget.isMadeByYou ? (){_cancelRequest();} : (){_acceptRequest(document['sex']);} ,
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
                          Text(widget.isMadeByYou ? 'CANCEL REQUEST' : 'ACCEPT REQUEST',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                )
            ),

            Container
              (
                margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 54.0),
                child: Material
                  (
                  elevation: 8.0,
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(32.0),
                  child: (widget.isMadeByYou || widget.noButton) ? new Container() :
                  InkWell
                    (
                    onTap: () {_rejectRequest();},
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
                          Text('REJECT REQUEST',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                )
            ),
            GoodReviewItem(colorIndex: widget.colorIndex, userDocumentId: widget.documentID,),
            BadReviewItem(colorIndex: widget.colorIndex, userDocumentId: widget.documentID,),
            NewReviewItem(colorIndex: widget.colorIndex, userDocumentId: widget.documentID,),
          ],
        )
    );
  }



  void _cancelRequest(){
    Firestore.instance.runTransaction((transaction) async {
      String mId;
      Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').get().then((d){
        mId =  d['to'];
      }).whenComplete((){
        Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').delete();
        Firestore.instance.document('users/${mId}/pending_requests/${widget.requestId}').delete();
      });
    });

      showInSnackBar('Work Request Successfully Cancelled', Colors.redAccent);
      Navigator.of(context).pop();
  }
  void _acceptRequest2(String gender){
    Map<String, Object> data = <String, Object>{
      'sex': gender,
      'userId': user.uid,
      'teamCount': int.parse(teamCount),
      'currentGroup': int.parse(currentGroup),
      'requestId': widget.requestId,
      'projectId': widget.projectDocumentID,
      'currentGroupCount': int.parse(currentGroupCount),
    };
    Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').get().then((d) {
      data['from'] = d['from'];
    }).whenComplete((){
      Firestore.instance.runTransaction((transaction) async {
        DocumentReference reference = Firestore.instance.collection('accept-work-request').document();
        await transaction.set(reference, data);
      });
    });
    Navigator.of(context).pop();
  }

  void _acceptRequest(String gender){

    Firestore.instance.runTransaction((transaction) async {
      String mId;
      Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').get().then((d){
        if(d['page'] == 'project_details'){
          mId = d['from'];
        }else {
          mId = user.uid;
        }
      }).whenComplete(() async {
        //write projectId in user's projects
        DocumentReference reference1 =
        Firestore.instance.document('users/${mId}/projects/${widget.projectDocumentID}');
        await reference1.setData({});

        // Inserting User's records in project
        DocumentReference reference2 =
        Firestore.instance.document('projects/${widget.projectDocumentID}/users/${mId}');
        await reference2.setData({
          'comments': [],
          'userGroup': (currentGroupCount == teamCount) ? int.parse(currentGroup)+1 : int.parse(currentGroup),
          'communicationRating': -1.0,
          'initiativeTakingRating': -1.0,
          'overAllRating': -1.0,
          'punctualityRating': -1.0,
          'reportingRating': -1.0,
          'sex': gender,
        });
      }).whenComplete(() async { // Update currentGroupCount and currentGroup in projects
        DocumentReference reference =
        Firestore.instance.document('projects/${widget.projectDocumentID}');
        await reference.updateData({
          'currentGroupCount': (currentGroupCount == teamCount) ? 0 : int.parse(currentGroupCount)+1,
          'currentGroup': (currentGroupCount == teamCount) ? int.parse(currentGroup)+1 : int.parse(currentGroup),
           });
      });
    });
// Delete Pending Requests
    Firestore.instance.runTransaction((transaction) async {
      String mId;
      Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').get().then((d){
        mId =  d['from'];
      }).whenComplete((){
        Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').delete();
        Firestore.instance.document('users/${mId}/pending_requests/${widget.requestId}').delete();
      });
    });

  showInSnackBar('Work Request Successfully Accepted', TodoColors.baseColors[widget.colorIndex]);
  Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PendingRequestsPage(colorIndex: 2, canRecruit: false, acceptRequest: true,),
            ));
  }

  @override
  void didChangeDependencies()  {
    super.didChangeDependencies();
    if (widget.projectDocumentID != null) {
      print("=> => => projectId: ${widget.projectDocumentID}");
      setDefaults();
    }
  }

  void _rejectRequest(){
    Firestore.instance.runTransaction((transaction) async {
    String mId;
     Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').get().then((d){
          mId =  d['from'];
      }).whenComplete((){
       Firestore.instance.document('users/${user.uid}/pending_requests/${widget.requestId}').delete();
       Firestore.instance.document('users/${mId}/pending_requests/${widget.requestId}').delete();
     });
    });

    showInSnackBar('Work Request Successfully Rejected', Colors.redAccent);
    Navigator.of(context).pop();

  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
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
            DocumentSnapshot docu = snapshot.data.documents.where((user){
              print('MMMMMMMMM => => => ${widget.documentID}');
              return (user.documentID == widget.documentID);
            }).first;

            final converter = _buildListItem(context, docu);

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

