import 'project_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'loading_screen.dart';

class NewReviewItem extends StatefulWidget
{
  final int colorIndex;
  final String userDocumentId;

  const NewReviewItem({
    @required this.colorIndex,
    @required this.userDocumentId,
  }) : assert(colorIndex != null),  assert(userDocumentId != null);

  @override
  NewReviewItemState createState() => NewReviewItemState();
}
class NewReviewItemState extends State<NewReviewItem> {
  List user_projects = [], project_titles = [], project_descriptions = [];
  Map<String, bool> comments = Map();

  @override
  Widget build(BuildContext context)
  {

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
          comments[project] = (doc['comments'].length > 0);
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

              return user_projects.contains(project.documentID) && comments[project.documentID];
            }).map((project)
            {
              return _buildReviewElt(context, project.documentID, project['projectTitle'], project['projectDescription']);
            }).toList(),
          );
        });


  }

  Widget _buildReviewElt(BuildContext context, String project_id, String project_title, String project_description) {
    return Padding
      (
      padding: EdgeInsets.only(bottom: 16.0),
      child: Align
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
                  onTap: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ProjectDetailsPage(colorIndex: widget.colorIndex,
                                projectDocumentID: project_id,
                                canRecruit: false,))),
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
                      color: Colors.white,
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
                                Text('[New] ${project_title}',
                                    style: TextStyle(color: Colors.blueAccent)),
                                Row
                                  (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>
                                  [
                                    Text('No reviews', style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 34.0)),
                                  ],
                                ),

                                /// Infos
                                Row
                                  (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>
                                  [
                                    Expanded(child: Text(project_description,),
                                        flex: 1),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
