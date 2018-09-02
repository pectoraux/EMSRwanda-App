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

class SendWorkRequestPage extends StatefulWidget
{
  final int colorIndex;
  final String userDocumentID;
  final String projectDocumentID;

  const SendWorkRequestPage({
    @required this.colorIndex,
    @required this.userDocumentID,
    this.projectDocumentID,
  });


  @override
  _SendWorkRequestPageState createState() => _SendWorkRequestPageState();
}

class _SendWorkRequestPageState extends State<SendWorkRequestPage>
{
  bool isDisabled = true, isStaff = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  String authorId;
  String button_text = '';
  int userGroup;

  @override
  void initState() {
    super.initState();
    if(widget.projectDocumentID != null) {
      setDefaults();
    }//else{
//      if(button_text.isEmpty){
//        isDisabled = false;
//        button_text = 'SEND WORK REQUEST';
//      }
//    }
  }

  Future setDefaults()async {
    user = await _auth.currentUser();
    Firestore.instance.runTransaction((transaction) async {
      Firestore.instance.collection('users/${user.uid}/pending_requests')
          .getDocuments()
          .then((query) {
        query.documents.forEach((doc) {
          print("=> => => HERE ");
          if (doc['projectId'] == widget.projectDocumentID) {
            if (doc['type'] == 'Made By You' &&
                widget.userDocumentID == doc['to']) {
              setState(() {
                button_text = 'Work Request Pending';
              });
            } else if (doc['type'] == 'Made To You' &&
                widget.userDocumentID == doc['from']) {
              setState(() {
                button_text = 'User Awaits Your Response';
              });
            }
          }
        });
      }).whenComplete(() {
        print('=> => => button text = ${button_text.isEmpty} <= <= <=');
        Firestore.instance.collection(
            'projects/${widget.projectDocumentID}/users')
            .getDocuments()
            .then((query) {
          query.documents.forEach((doc) {
            if (doc.documentID == widget.userDocumentID) {
              setState(() {
                button_text = 'STAFF MEMBER';
                userGroup = doc['userGroup'];
              });
            }
          });
        }).whenComplete(() {
          print('=> => => button text = ${button_text.isEmpty} <= <= <=');
          if (button_text.isEmpty) {
            setState(() {
              isDisabled = false;
              button_text = 'SEND WORK REQUEST';
            });
          };
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
                    onTap: isDisabled ? (){print("DISABLED !!!");} : (){_sendWorkRequest();} ,
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
                           isDisabled ? Text(button_text, style: TextStyle(color: Colors.redAccent)) :
                           Text(button_text, style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  )
                )
            ),
            GoodReviewItem(colorIndex: widget.colorIndex, userDocumentId: widget.userDocumentID,),
            BadReviewItem(colorIndex: widget.colorIndex, userDocumentId: widget.userDocumentID,),
            NewReviewItem(colorIndex: widget.colorIndex, userDocumentId: widget.userDocumentID,),
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
        button_text = 'Work Request Pending';
      });

      Firestore.instance.document('projects/${widget.projectDocumentID}')
          .get()
          .then((doc) {
        Map<String, Object> request_data = <String, Object>{
          'projectId': widget.projectDocumentID,
          'projectTitle': doc['projectTitle'],
          'to': widget.userDocumentID,
          'page': 'project_history',
          'from': user.uid,};

        Firestore.instance.runTransaction((transaction) async {
          DocumentReference reference = Firestore.instance.collection('send-work-request').document();
          await transaction.set(reference, request_data);
        });
      });
      Navigator.of(context).pop();
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