import 'supplemental/cut_corners_border.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'star_rating.dart';

class DeviceRatingPage extends StatefulWidget {
  @override
  _DeviceRatingPageState createState() => _DeviceRatingPageState();
}

class _DeviceRatingPageState extends State<DeviceRatingPage> {
  int _colorIndex = 1;
//  final _ratingController = TextEditingController();
//  final _rating = GlobalKey(debugLabel: 'Rating');
//  final _ratingTypeController = TextEditingController();
//  final _ratingType = GlobalKey(debugLabel: 'Rating Type');
//  final _ratingCommentController = TextEditingController();
//  final _ratingComment = GlobalKey(debugLabel: 'Rating Comment');

  @override
  Widget build(BuildContext context) {
    double rating = 3.5;
    return Scaffold
      (
      body: CustomScrollView
        (
        slivers: <Widget>
        [
          SliverAppBar
            (
            expandedHeight: 170.0,
            backgroundColor: Colors.red,
            flexibleSpace: FlexibleSpaceBar
              (
              title: Row (

                children: <Widget>[
                  Text('Ipad'),
                ],
              ),
              background: SizedBox.expand
                (
                child: Stack
                  (
                  alignment: Alignment.center,
                  children: <Widget>
                  [
                    Image.asset("assets/images/ipad.jpg"),
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
                            showDialog<Null>(
                              context: context,
                              barrierDismissible: false, // user must tap button!
                              builder: (BuildContext context) {
                                return new AlertDialog(
                                  title: new Text(
                                    'Rate Ipad', style: TodoColors.textStyle.apply(color: TodoColors.baseColors[_colorIndex]),),
                                  content: new SingleChildScrollView(
                                    child: new ListBody(
                                      children: <Widget>[
                                        SizedBox(height: 12.0),
                                        PrimaryColorOverride(
                                          color: TodoColors.baseColors[_colorIndex],
                                          child: TextField(
//                                            key: _ratingType,
//                                            controller: _ratingTypeController,
                                            decoration: InputDecoration(
                                              labelText: 'Rating Type',
                                              labelStyle: TodoColors.textStyle2,
                                              border: CutCornersBorder(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.0),
                                        PrimaryColorOverride(
                                          color: TodoColors.baseColors[_colorIndex],
                                          child: TextField(
//                                            key: _rating,
//                                            controller: _ratingController,
                                            decoration: InputDecoration(
                                              labelText: 'Rating',
                                              labelStyle: TodoColors.textStyle2,
                                              border: CutCornersBorder(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.0),
                                        PrimaryColorOverride(
                                          color: TodoColors.baseColors[_colorIndex],
                                          child: new StarRating(
                                            rating: rating,
                                            onRatingChanged: (rating) => setState(() => rating = rating),
                                          ),
                                        ),
                                        SizedBox(height: 12.0),
                                        PrimaryColorOverride(
                                          color: TodoColors.baseColors[_colorIndex],
                                          child: TextField(
//                                            key: _ratingComment,
//                                            controller: _ratingCommentController,
                                            decoration: InputDecoration(
                                              labelText: 'Rating Comment',
                                              labelStyle: TodoColors.textStyle2,
                                              border: CutCornersBorder(),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12.0),
                                      ],
                                    ),

                                  ),

                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('CANCEL'),
                                      textColor: TodoColors.baseColors[_colorIndex],
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                    RaisedButton(
                                      child: Text('SEARCH'),
                                      textColor: TodoColors.baseColors[_colorIndex],
                                      elevation: 8.0,
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                      ),
                                      onPressed: () {},
                                    ),

                                  ],
                                );
                              },
                            );
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
                                Text('RATE DEVICE',
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
                        (
                          '4.6',
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
                      children: <Widget>
                      [
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.black12, size: 48.0),
                      ],
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

                        /// 5 stars and progress bar
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.green),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.9,
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
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(
                                      accentColor: Colors.lightGreen),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.7,
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
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.yellow),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.25,
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
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.orange),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.07,
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
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.red),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.12,
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
                  Padding
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
                              backgroundColor: Colors.purple,
                              child: Text('AI'),
                            ),
                            title: Text(
                                'Ivascu Adrian ★★★★★', style: TextStyle()),
                            subtitle: Text(
                                'This Ipad worked fine the entire duration of the project and never let me down :)',
                                style: TextStyle()),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Review reply
                  Padding
                    (
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    child: Row
                      (
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Material
                          (
                          elevation: 12.0,
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.only
                            (
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          child: Container
                            (
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text('Happy to hear that!', style: Theme
                                .of(context)
                                .textTheme
                                .subhead),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),

                  /// Review
                  Padding
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
                        child: Column
                          (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>
                          [
                            Container
                              (
                              child: ListTile
                                (
                                leading: CircleAvatar
                                  (
                                  backgroundColor: Colors.purple,
                                  child: Text('VA'),
                                ),
                                title: Text(
                                    'Viscivus Aloi ★★★★★', style: TextStyle()),
                                subtitle: Text(
                                    'This Ipad\'s screen is broken but it still worked great the entire duration of the project',
                                    style: TextStyle()),
                              ),
                            ),
                            Padding
                              (
                              padding: EdgeInsets.only(top: 4.0, right: 10.0),
                              child: FlatButton.icon
                                (
                                  onPressed: () {},
                                  icon: Icon(
                                      Icons.reply, color: Colors.blueAccent),
                                  label: Text('Reply', style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0))
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),

                  /// Review
                  Padding
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
                        child: Column
                          (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>
                          [
                            Container
                              (
                              child: ListTile
                                (
                                leading: CircleAvatar
                                  (
                                  backgroundColor: Colors.purple,
                                  child: Text('AD'),
                                ),
                                title: Text(
                                    'Alian Dimitri ★★★★★', style: TextStyle()),
                                subtitle: Text(
                                    'Awesome !!! Worked great for the whole month that I used it.',
                                    style: TextStyle()),
                              ),
                            ),
                            Padding
                              (
                              padding: EdgeInsets.only(top: 4.0, right: 10.0),
                              child: FlatButton.icon
                                (
                                  onPressed: () {},
                                  icon: Icon(
                                      Icons.reply, color: Colors.blueAccent),
                                  label: Text('Reply', style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0))
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}