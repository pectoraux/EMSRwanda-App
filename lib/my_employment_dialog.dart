import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'color_override.dart';
import 'star_rating.dart';

class MyEmploymentDialog extends StatefulWidget {
  final int colorIndex;

  const MyEmploymentDialog({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  State createState() => new MyEmploymentDialogState();
}

class MyEmploymentDialogState extends State<MyEmploymentDialog> {
  final _projectTitleController = TextEditingController();
  final _projectTitle = GlobalKey(debugLabel: 'Project Title');

  List<DropdownMenuItem> _locationMenuItems, _tagMenuItems, _ratingMenuItems;
  List<String> locations = [" Locations", " Gasabo", " Remera", " Kisimenti", " Gaculiro", " Kacyiru"];
  List<String> tags = ["Tags", "Over18", "Male", "Female", "Education", "Sensitive"];
  List<String> ratings = ["Minimum Rating", "1", "2", "3", "4", "5"];
  String _tagValue, _locationValue, _minRatingValue;
  double rating;


  @override
  void initState() {
    super.initState();
    _createDropdownMenuItems(0, locations);
    _createDropdownMenuItems(1, tags);
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
      if(idx == 0) { //if location drop down
        _locationMenuItems = newItems;
      } else if (idx == 1){
        _tagMenuItems = newItems;
      } else if (idx == 12) {
        _ratingMenuItems = newItems;
      }
    });
  }

  /// Sets the default values for the 'from' and 'to' [Dropdown]s, and the
  /// updated output value if a user had previously entered an input.
  void _setDefaults() {
    setState(() {
      _locationValue = locations[0];
      _tagValue = tags[0];
      _minRatingValue = ratings[0];
      rating = 0.0;
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
                      items: (idx == 0) ? _locationMenuItems : (idx == 1) ? _tagMenuItems : _ratingMenuItems,
                      onChanged: onChanged,
                      style: TodoColors.textStyle2,
                    ),]
              ),),
          ),
        ),
      ),);
  }

  void _updateLocationValue(dynamic name) {
    setState(() {
      _locationValue = name;
    });
  }

  void _updateTagValue(dynamic name) {
    setState(() {
      _tagValue = name;
    });
  }

  void _updateRatingValue(dynamic name) {
    setState(() {
      _minRatingValue = name;
      rating = double.parse(name);
    });
  }


  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text('Search Projects',
        style: TodoColors.textStyle.apply(
            color: TodoColors.baseColors[widget.colorIndex]),),
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[

            const SizedBox(height: 12.0),
            _createDropdown(12, _minRatingValue, _updateRatingValue),

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
                key: _projectTitle,
                controller: _projectTitleController,
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  labelStyle: TodoColors.textStyle2,
                  border: CutCornersBorder(),
                ),
              ),
            ),

            const SizedBox(height: 12.0),
            _createDropdown(0, _locationValue, _updateLocationValue),

            RaisedButton(
              child: Text('ADD LOCATION'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 12.0),
            _createDropdown(1, _tagValue, _updateTagValue),

            RaisedButton(
              child: Text('ADD TAG'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {},
            ),
            SizedBox(height: 12.0,),
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
          child: Text('SEARCH'),
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