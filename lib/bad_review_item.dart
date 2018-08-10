import 'package:cloud_firestore/cloud_firestore.dart';

import 'project_details.dart';
import 'loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadReviewItem extends StatefulWidget
{
  final int colorIndex;
  final String userDocumentId;

  const BadReviewItem({
    @required this.colorIndex,
    @required this.userDocumentId,
  }) : assert(colorIndex != null), assert(userDocumentId != null);

  @override
  BadReviewItemState createState() => BadReviewItemState();
}
class BadReviewItemState extends State<BadReviewItem> {
  List user_projects = [], project_titles = [], project_descriptions = [];
  Map<String, double> overAllRatings = Map();
  double badRatingThreshold = 3.0;
  Map<String, String> userComments = Map();

  @override
  Widget build(BuildContext context) {
    Firestore.instance.collection('users/${widget.userDocumentId}/projects')
        .getDocuments()
        .then((query) {
      List results = [];
      setState(() {
        for (DocumentSnapshot doc in query.documents) {
          results.add(doc.documentID);
        }
        user_projects = results;
      });
    }).whenComplete(() {
      for (String project in user_projects) {
        Firestore.instance.document(
            'projects/${project}/users/${widget.userDocumentId}').get().then((
            doc) {
          overAllRatings[project] = (doc['overAllRating']).toDouble();
          userComments[project] = doc['comments'][doc['comments'].length - 1];
        });
      }
    });

    return StreamBuilder<QuerySnapshot>(
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
          return Column(
            children: snapshot.data.documents.where((project){
      try {
        if (user_projects.contains(project.documentID)) {
          return overAllRatings[project.documentID] <= badRatingThreshold;
        }
        return false;
      }catch(_){
        return false;
      }
            }).map((project)
            {
              try{
              return _buildReviewElt(context, project.documentID, project['projectTitle'], project['projectDescription'],
                  '${overAllRatings[project.documentID]}', userComments[project.documentID]);
              }catch(_){
                return BarLoadingScreen();
              }
              }).toList(),
          );
        });
  }

  String _getInitials(String name){
    String result = '';
    List chuncks = name.trim().split('★').join(' ').trim().split(' ');
    for(String part in chuncks){
      if(part.trim().length != 0) {
        result += part.trim()[0].toUpperCase();
      }
    }
    if(result.length <= 2) {
      return result;
    } else {
      return result.substring(0, 2);
    }
  }
  
  Widget _buildReviewElt(BuildContext context, String project_id, String project_title, String project_description, String overAllRating, String comment) {
    return Column(
      children: <Widget>[
        Padding
          (
          padding: EdgeInsets.only(bottom: 16.0),
          child: Stack
            (
            children: <Widget>
            [
              /// Item card
              Align
                (
                alignment: Alignment.topCenter,
                child: SizedBox.fromSize
                  (
                    size: Size.fromHeight(172.0),
                    child: Stack
                      (
                      fit: StackFit.expand,
                      children: <Widget>
                      [
                        InkWell
                          (
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                              ProjectDetailsPage(colorIndex: widget.colorIndex, projectDocumentID: project_id, canRecruit: false,))),
                          child:
                          /// Item description inside a material
                          Container
                            (
                            margin: EdgeInsets.only(top: 24.0),
                            child: Material
                              (
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(12.0),
                              shadowColor: Color(0x802196F3),
                              color: Colors.transparent,
                              child: Container
                                (
                                decoration: BoxDecoration
                                  (
                                    gradient: LinearGradient
                                      (
                                        colors: [ Color(0xFFDA4453), Color(0xFF89216B) ]
                                    )
                                ),
                                child: Padding
                                  (
                                  padding: EdgeInsets.all(24.0),
                                  child: Column
                                    (
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>
                                    [
                                      /// Title and rating
                                      Column
                                        (
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>
                                        [
                                          Text(project_title, style: TextStyle(color: Colors.white)),
                                          Row
                                            (
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>
                                            [
                                              Text(overAllRating, style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700, fontSize: 34.0)),
                                              Icon(Icons.star, color: Colors.amber, size: 24.0),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row
                                        (
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>
                                        [
                                          Expanded(child:Text(project_description,), flex: 1),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
              /// Review
              Padding
                (
                padding: EdgeInsets.only(top: 160.0, right: 32.0,),
                child: Material
                  (
                  elevation: 12.0,
                  color: Colors.white,
                  borderRadius: BorderRadius.only
                    (
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  child: Container
                    (
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile
                      (
                      leading: CircleAvatar
                        (
                        backgroundColor: Colors.purple,
                        child: Text('${_getInitials(comment.substring(comment.indexOf('★')+1, comment.lastIndexOf('★')+1))}'),
                      ),
                      title: Text(
                          comment.substring(comment.indexOf('★')+1, comment.lastIndexOf('★')+1), style: TextStyle()),
                      subtitle: Text(
                          comment.substring(comment.lastIndexOf('★')+1),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}