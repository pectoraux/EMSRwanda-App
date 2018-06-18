import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'accept_request.dart';
import 'user_history_page.dart';
import 'supplemental/cut_corners_border.dart';

class ExploreUsersPage2 extends StatefulWidget {
  @override
  ExploreUsersPageState createState() => ExploreUsersPageState();
}

class ExploreUsersPageState extends State<ExploreUsersPage2> {
  int _colorIndex = 7;

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
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
    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Search Results', style: TodoColors.textStyle6),
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
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      new Container(
                        width: 450.0,
                      );

                      showDialog<Null>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text(
                              'Search  Users', style: TodoColors.textStyle6,),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  SizedBox(height: 12.0),
                                  TextField(
                                    key: _userName,
                                    controller: _userNameController,
                                    decoration: InputDecoration(
                                      labelText: 'User Name',
                                      labelStyle: TodoColors.textStyle2,
                                      border: CutCornersBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  TextField(
                                    key: _userRole,
                                    controller: _userRoleController,
                                    decoration: InputDecoration(
                                      labelText: 'User Role',
                                      labelStyle: TodoColors.textStyle2,
                                      border: CutCornersBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  TextField(
                                    key: _userStatus,
                                    controller: _userStatusController,
                                    decoration: InputDecoration(
                                      labelText: 'User Status',
                                      labelStyle: TodoColors.textStyle2,
                                      border: CutCornersBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  TextField(
                                    key: _userLocations,
                                    controller: _userLocationsController,
                                    decoration: InputDecoration(
                                      labelText: 'User Location',
                                      labelStyle: TodoColors.textStyle2,
                                      border: CutCornersBorder(),
                                    ),
                                  ),
                                  RaisedButton(
                                    child: Text('ADD LOCATION'),
                                    elevation: 8.0,
                                    shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
                                    ),
                                    onPressed: () {},
                                  ),
                                  SizedBox(height: 12.0),
                                  TextField(
                                    key: _tags,
                                    controller: _tagsController,
                                    decoration: InputDecoration(
                                      labelText: 'Project or User Related Tags',
                                      labelStyle: TodoColors.textStyle2,
                                      border: CutCornersBorder(),
                                    ),
                                  ),
                                  RaisedButton(
                                    child: Text('ADD TAG'),
                                    elevation: 8.0,
                                    shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0)),
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
                  ),
                ],
              ),
            )
          ],
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Kigali',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Erin Niamkey', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Remera',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Bernard Nshima', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Kacyiru',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Celine Dion', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Kiyovu',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Eric Niamkey', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Gaculiro',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Kossi Koffi', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Kimironko',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Anne Judith', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Kiyovu',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Mariam Adah', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Gisenyi',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Ali Jean', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Gaculiro',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Micheal Jackson', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),
            _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text('Remera',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Ninegan Tchakpa', style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.timeline, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
            ),


          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 110.0),
          ],
        )
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: () =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UserHistoryPage(colorIndex: _colorIndex))),
            child: child
        )
    );
  }
}