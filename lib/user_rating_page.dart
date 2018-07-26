import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'supplemental/cut_corners_border.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'loading_screen.dart';
import 'color_override.dart';
import 'my_rating_dialog.dart';

class UserRatingPage extends StatefulWidget {
  final int colorIndex;
  final String userDocumentID;
  final String projectDocumentID;

  const UserRatingPage({
    @required this.colorIndex,
    @required this.projectDocumentID,
    @required this.userDocumentID,
  }) : assert(colorIndex != null), assert(projectDocumentID != null), assert(userDocumentID != null);

  @override
  UserRatingPageState createState() => UserRatingPageState();
}

class UserRatingPageState extends State<UserRatingPage> {
  final _replyController = TextEditingController();
  final _reply = GlobalKey(debugLabel: 'Reply');
  String imageUrlStr = '', firstName = '', lastName = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefaults();
  }


  void setDefaults()async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    imageUrlStr = user.photoUrl;
//    print('MMMMMMMMMMM => => => $imageUrlStr');
  
    DocumentSnapshot doc = await Firestore.instance.document('users/${user.uid}').get();
    firstName = doc['firstName'];
    lastName = doc['lastName'];
  }
  List<Widget> _buildOverallRatings(int rating) {
    List ratingItems = <Widget>[];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        ratingItems.add(Icon(Icons.star, color: Colors.amber, size: 48.0));
      } else {
        ratingItems.add(Icon(Icons.star, color: Colors.black12, size: 48.0));
      }
    }
    return ratingItems;
  }
  List<Widget> _buildRatings(int rating) {
    List ratingItems = <Widget>[];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        ratingItems.add(Icon(Icons.star, color: Colors.black54, size: 16.0));
      } else if (rating < 0){
        ratingItems.add(Icon(Icons.star_border, color: Colors.black12, size: 16.0));
      } else {
        ratingItems.add(Icon(Icons.star, color: Colors.black12, size: 16.0));
      }
    }
    return ratingItems;
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    List overallRatingItems = <Widget>[], punctualityRatingItems = <Widget>[], initiativeTakingItems = <Widget>[], communicationItems = <Widget>[], reportingItems = <Widget>[];
    int numItemsPunctuality, numItemsReporting, numItemsCommunication, numItemsInitiativeTaking, numItemsOverallRating;
          numItemsReporting = (document['reportingRating']).toInt();
          reportingItems = _buildRatings(numItemsReporting);
          numItemsInitiativeTaking = (document['initiativeTakingRating']).toInt();
          initiativeTakingItems = _buildRatings(numItemsInitiativeTaking);
          numItemsPunctuality = (document['punctualityRating']).toInt();
          punctualityRatingItems = _buildRatings(numItemsPunctuality);
          numItemsCommunication = (document['communicationRating']).toInt();
          communicationItems = _buildRatings(numItemsCommunication);
          numItemsOverallRating = (document['overAllRating']).toInt();
          overallRatingItems = _buildRatings(numItemsOverallRating);

    List myColors = [Colors.black12, Colors.black12, Colors.red, Colors.orange, Colors.yellow, Colors.lightGreen, Colors.green];

    List reviewWidgets = <Widget>[];
    for (String cmt in document['comments']){
      String author = cmt.substring(0, cmt.lastIndexOf('★')+1);
      String comment = cmt.substring(cmt.lastIndexOf('★')+1);
        reviewWidgets.add(_buildReview(context, author, comment));
        reviewWidgets.add(Divider());
    }

    return Scaffold
      (
      body: CustomScrollView
        (
        slivers: <Widget>
        [
          SliverAppBar
            (
            expandedHeight: 170.0,
            backgroundColor: TodoColors.baseColors[widget.colorIndex],
            flexibleSpace: FlexibleSpaceBar
              (
              title: Row (

              children: <Widget>[
                Text('${firstName} ${lastName}'),
              ],
              ),
              background: SizedBox.expand
                (
                child: Stack
                  (
                  alignment: Alignment.center,
                  children: <Widget>
                  [
                    (imageUrlStr.isNotEmpty) ? Image.network(imageUrlStr) : Image.asset("assets/images/emma-watson.jpg"),
                    Container(color: Colors.black26)
                  ],
                ),
              ),
            ),
            elevation: 2.0,
            forceElevated: true,
            pinned: true,
          ),
          SliverList
            (
            delegate: SliverChildListDelegate
              (
                <Widget>
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
                          onTap: () {
                            new Container(
                              width: 450.0,
                            );
                            showDialog(context: context, child: new MyRatingDialog(colorIndex: widget.colorIndex,));
                          },
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
                                Text('RATE USER',
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                        ),
                      )
                  ),

                  /// Rating average
                  Center
                    (
                    child: Container
                      (
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text
                        ("${document['overAllRating']}",
                          style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 64.0)
                      ),
                    ),
                  ),

                  /// Rating stars
                  Padding
                    (
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row
                      (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildOverallRatings(numItemsOverallRating),
                    ),
                  ),

                  /// Rating chart lines
                  Padding
                    (
                    padding: EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: Column
                      (
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>
                      [
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Text('Reporting'),
                              Padding(padding: EdgeInsets.only(right: 43.0)),
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: reportingItems,
                              ),
                              Padding(padding: EdgeInsets.only(right: 17.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: myColors[numItemsReporting + 1]),
                                  child: LinearProgressIndicator
                                    (
                                    value: (numItemsReporting)/5.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Text('Punctuality'),
                              Padding(padding: EdgeInsets.only(right: 34.0)),
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: punctualityRatingItems,
                              ),
                              Padding(padding: EdgeInsets.only(right: 17.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: myColors[numItemsPunctuality + 1]),
                                  child: LinearProgressIndicator
                                    (
                                    value: (numItemsPunctuality)/5.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Text('Initiative Taking'),
                              Padding(padding: EdgeInsets.only(right: 5.0)),
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: initiativeTakingItems,
                              ),
                              Padding(padding: EdgeInsets.only(right: 17.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(
                                      accentColor: myColors[numItemsInitiativeTaking + 1]),
                                  child: LinearProgressIndicator
                                    (
                                    value: (numItemsInitiativeTaking)/5.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Text('Communication'),
                              Padding(padding: EdgeInsets.only(right: 5.0)),
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: communicationItems,
                              ),
                              Padding(padding: EdgeInsets.only(right: 16.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(
                                      accentColor: myColors[numItemsCommunication + 1]),
                                  child: (numItemsCommunication < 0) ? Container() : LinearProgressIndicator
                                    (
                                    value: (numItemsCommunication)/5.0,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  /// Review
//                  _buildReview(context, document),
                ]..addAll(reviewWidgets.getRange(0, reviewWidgets.length))
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview(BuildContext context, String author, String comment){

    return Padding
      (
      padding: EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 16.0),
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
          margin: EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 0.0),
          child: Container
            (
            child: ListTile
              (
              leading: CircleAvatar
                (
                backgroundColor: TodoColors.baseColors[widget.colorIndex],
                child: Text('AI'),
              ),
              title: Text(author, style: TextStyle()),
              subtitle: Text(comment,
                  style: TextStyle()),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('projects/${widget.projectDocumentID}/users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: new BarLoadingScreen(),
            );
          } else {
            DocumentSnapshot document = snapshot.data.documents.where((doc){
              return doc.documentID == widget.userDocumentID;}).first;


            final converter = _buildListItem(
                context, document);

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