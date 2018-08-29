import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'star_rating.dart';
import 'loading_screen.dart';
import 'dart:math';

class MyRatingDialog extends StatefulWidget {
  final int colorIndex;
  final String projectDocumentID;
  final String userDocumentID;
  final String firstName, lastName;

  const MyRatingDialog({
    @required this.colorIndex,
    @required this.projectDocumentID,
    @required this.userDocumentID,
    @required this.firstName,
    @required this.lastName,
  }) : assert(colorIndex != null), assert(projectDocumentID != null), assert(userDocumentID != null),
  assert(firstName != null), assert(lastName != null);

  @override
  State createState() => new MyRatingDialogState();
}

class MyRatingDialogState extends State<MyRatingDialog> {

  List<DropdownMenuItem> _ratingTypeMenuItems, _ratingMenuItems;
  List<String> ratingTypes = [
    "Rating Type",
    "Punctuality",
    "Initiative Taking",
    "Communication",
    "Reporting"
  ];
  List<String> ratings = ["Ratings", "1", "2", "3", "4", "5"];
  String _ratingTypesValue, _ratingsValue;
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(13, ratingTypes);
    _createDropdownMenuItems(12, ratings);
    _setDefaults();
  }

  /// Creates fresh list of [DropdownMenuItem] widgets, given a list of [Unit]s.
  void _createDropdownMenuItems(int idx, List<String> list) {
    var newItems = <DropdownMenuItem>[];
    for (var unit in list) {
      newItems.add(DropdownMenuItem(
        value: unit,
        child: Container(
          child: Text(
            unit,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      if (idx == 13) { //if location drop down
        _ratingTypeMenuItems = newItems;
      } else if (idx == 12) {
        _ratingMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _ratingTypesValue = ratingTypes[0];
      _ratingsValue = ratings[0];
    });
  }

  Widget _createDropdown(int idx, String currentValue, ValueChanged<dynamic>

  onChanged) {
    return Container(
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: TodoColors.baseColors[widget.colorIndex],
        border: Border.all(
          color: TodoColors.baseColors[widget.colorIndex],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: new SingleChildScrollView(
          child: new ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 8.0,
            ),
            child: DropdownButtonHideUnderline(
              child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DropdownButton(
                      value: currentValue,
                      items: (idx == 13)
                          ? _ratingTypeMenuItems
                          : _ratingMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),
                  ]
              ),),
          ),
        ),
      ),);
  }

  void _updateRatingTypesValue(dynamic name) {
    setState(() {
      _ratingTypesValue = name;
    });
  }

  void _updateRatingsValue(dynamic name) {
    setState(() {
      _ratingsValue = name;
      rating = double.parse(name);
    });
  }

  double computeMean(List lst){
    double result = 0.0;
    for(int k = 0; k < lst.length; k++){
      result += lst[k];
    }
    return result/lst.length;
  }

  Widget build(BuildContext context) {
    final _ratingCommentController = TextEditingController();
    final _ratingComment = GlobalKey(debugLabel: 'Rating Comment');

    return new StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.document(
            'projects/${widget.projectDocumentID}/users/${widget.userDocumentID}').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
              child: new BarLoadingScreen(),
            );
          } else if (snapshot.data != null) {
            DocumentSnapshot document = snapshot.data;
            return new AlertDialog(
              title: new Text('Rate User',
                style: TodoColors.textStyle.apply(
                    color: TodoColors.baseColors[widget.colorIndex]),),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[

                    const SizedBox(height: 12.0),
                    _createDropdown(
                        13, _ratingTypesValue, _updateRatingTypesValue),

                    const SizedBox(height: 12.0),
                    _createDropdown(12, _ratingsValue, _updateRatingsValue),

                    SizedBox(height: 12.0),
                    PrimaryColorOverride(
                      color: TodoColors.baseColors[widget.colorIndex],
                      child: new StarRating(
                        rating: rating,
                        onRatingChanged: (rating) =>
                            setState(() => rating = rating),
                      ),
                    ),

                    SizedBox(height: 12.0),
                    PrimaryColorOverride(
                      color: TodoColors.baseColors[widget.colorIndex],
                      child: TextField(
                        key: _ratingComment,
                        maxLines: null,
                        controller: _ratingCommentController,
                        decoration: InputDecoration(
                          labelText: 'Rating Comment',
                          labelStyle: TodoColors.textStyle2,
                          border: CutCornersBorder(),
                        ),
                      ),
                    ),


                  ],
                ),

              ),

              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  textColor: TodoColors.baseColors[widget.colorIndex],
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                RaisedButton(
                  child: Text('RATE'),
                  textColor: TodoColors.baseColors[widget.colorIndex],
                  elevation: 8.0,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  ),
                  onPressed: () {
                    List<double> ratings = [];
//                    for (int i = 0; i < 4; i++) {
//                      if (_ratingTypesValue == ratingTypes[i + 1]) {
//                        ratings[i] = double.parse(_ratingsValue);
//                      } else {
//                        ratings[i] = -1.0;
//                      }
                      String stars = '';
                      for(int j = 0; j < int.parse(_ratingsValue); j++){
                        stars += '★';
                      }
                      List cmts = document['comments'];
                      List mComments = [];
                      mComments.addAll(cmts);
                      String cmt = '${_ratingTypesValue} ${_ratingsValue} ★ ${widget.firstName} ${widget.lastName} $stars ${_ratingCommentController.text}';
                      mComments.add(cmt);
                      double punct = document['punctualityRating'] < 0 ? 0.0 : document['punctualityRating']*1.0;
                      double report = document['reportingRating'] < 0 ? 0.0 : document['reportingRating']*1.0;
                      double initiative = document['initiativeTakingRating'] < 0 ? 0.0 : document['initiativeTakingRating']*1.0;
                      double communicate = document['communicationRating'] < 0 ? 0.0 : document['communicationRating']*1.0;
    Map<String, Object> ratings_data = <String, Object>{};
                      if(_ratingTypesValue == "Reporting") {
                        ratings_data = <String, Object>{
                          'comments': mComments,
                          'reportingRating': report == 0.0 ? double.parse(_ratingsValue) : (report + double.parse(_ratingsValue))/2.0,
                          'overAllRating':(punct + initiative + communicate + report)/4.0
                        };
                      }else if(_ratingTypesValue == "Communication") {
                        ratings_data = <String, Object>{
                          'comments': mComments,
                          'communicationRating': communicate == 0.0 ? double.parse(_ratingsValue) : (communicate + double.parse(_ratingsValue))/2.0,
                          'overAllRating':(punct + initiative + communicate + report)/4.0
                        };
                      }else if(_ratingTypesValue == "Initiative Taking") {
                        ratings_data = <String, Object>{
                          'comments': mComments,
                          'initiativeTakingRating': initiative == 0.0 ? double.parse(_ratingsValue) : (initiative + double.parse(_ratingsValue))/2.0,
                          'overAllRating':(punct + initiative + communicate + report)/4.0
                        };
                      }else if(_ratingTypesValue == "Punctuality") {
                        ratings_data = <String, Object>{
                          'comments': mComments,
                          'punctualityRating': punct == 0 ? double.parse(_ratingsValue) : (punct + double.parse(_ratingsValue))/2.0,
                          'overAllRating':(punct + initiative + communicate + report)/4.0
                        };
                      }

                      Firestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot snapshot = await transaction.get(
                            document.reference);
                        await transaction.update(snapshot.reference, ratings_data);
                      });
//                    print('OUTPUT => => => ${mComments}');
                  Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        });
  }
}