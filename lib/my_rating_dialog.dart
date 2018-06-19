import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'star_rating.dart';

class MyRatingDialog extends StatefulWidget {
  final int colorIndex;

  const MyRatingDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyRatingDialogState();
}

class MyRatingDialogState extends State<MyRatingDialog> {
  final _userNameController = TextEditingController();
  final _userName = GlobalKey(debugLabel: 'User Name');
  final _userRoleController = TextEditingController();
  final _userRole = GlobalKey(debugLabel: 'User Role');
  final _userStatusController = TextEditingController();
  final _userStatus = GlobalKey(debugLabel: 'User Status');
  final _userLocationsController = TextEditingController();
  final _tagsController = TextEditingController();
  final _userLocations = GlobalKey(debugLabel: 'Users Locations');
  final _tags = GlobalKey(debugLabel: 'Project or User Related Tags');

  List<DropdownMenuItem> _ratingTypeMenuItems, _ratingMenuItems;
  List<String> ratingTypes = ["Rating Type", "Punctuality", "Initiative Taking", "Communication", "Reporting"];
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
      if(idx == 13) { //if location drop down
        _ratingTypeMenuItems = newItems;
      } else if (idx == 12){
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

  onChanged)

  {
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
                      items: (idx == 13) ? _ratingTypeMenuItems : _ratingMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),]
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


  Widget build(BuildContext context) {


    final _ratingCommentController = TextEditingController();
    final _ratingComment = GlobalKey(debugLabel: 'Rating Comment');

    return new AlertDialog(
      title: new Text('Rate User',
        style: TodoColors.textStyle.apply(
            color: TodoColors.baseColors[widget.colorIndex]),),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[

            const SizedBox(height: 12.0),
            _createDropdown(13, _ratingTypesValue, _updateRatingTypesValue),

            const SizedBox(height: 12.0),
            _createDropdown(12, _ratingsValue, _updateRatingsValue),

            SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: TodoColors.baseColors[widget.colorIndex],
              child: new StarRating(
                rating: rating,
                onRatingChanged: (rating) => setState(() => rating = rating),
              ),
            ),

            SizedBox(height: 12.0),
            PrimaryColorOverride(
              color: TodoColors.baseColors[widget.colorIndex],
              child: TextField(
                key: _ratingComment,
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
          onPressed: () {},
        ),

      ],
    );
  }
}