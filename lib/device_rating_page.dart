import 'package:cloud_firestore/cloud_firestore.dart';

import 'supplemental/cut_corners_border.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'loading_screen.dart';
import 'color_override.dart';
import 'my_rating_dialog.dart';

class DeviceRatingPage extends StatefulWidget {
  final int colorIndex;
  final String deviceRatingDocumentID;
  const DeviceRatingPage({
    @required this.colorIndex,
    @required this.deviceRatingDocumentID,
  }) : assert(colorIndex != null),
  assert(deviceRatingDocumentID != null);

  @override
  DeviceRatingPageState createState() => DeviceRatingPageState();
}

class DeviceRatingPageState extends State<DeviceRatingPage> {
  final _replyController = TextEditingController();
  final _reply = GlobalKey(debugLabel: 'Reply');
  final _deviceName = GlobalKey(debugLabel: 'Device Name');
  final _deviceStatus = GlobalKey(debugLabel: 'Device Status');
  final _deviceType = GlobalKey(debugLabel: 'Device Type');
  final _deviceCondition = GlobalKey(debugLabel: 'Device Condition');
  final _deviceNameController = TextEditingController();
  final _deviceStatusController = TextEditingController();
  final _deviceTypeController = TextEditingController();
  final _deviceConditionController = TextEditingController();

    Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
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
            backgroundColor: TodoColors.baseColors[widget.colorIndex],
            flexibleSpace: FlexibleSpaceBar
              (
              title: Row (
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(document['deviceName']),
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
                  SizedBox(height: 20.0),
                    Center(
                      child: new Container(
                        width: 70.0, height: 60.0,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                              image: Image.asset('assets/icons/launcher.png').image,
                              fit: BoxFit.cover),
                          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                                color: Colors.black26, blurRadius: 5.0, spreadRadius: 1.0),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 12.0),
                    ListTile(
                      title: Container(
                        child: InputDecorator(
                          key: _deviceName,
                          child: Text(
                            document['deviceName'],
                            style: TodoColors.textStyle3.apply(
                                color: TodoColors.baseColors[widget.colorIndex]),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Device Name',
                            labelStyle: TodoColors.textStyle2,
                            border: CutCornersBorder(),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(
                      child: InputDecorator(
                        key: _deviceStatus,
                        child: Text(
                          document['deviceStatus'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Device Status',
                          labelStyle: TodoColors.textStyle2,
                          border: CutCornersBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(
                      child: InputDecorator(
                        key: _deviceType,
                        child: Text(
                          document['deviceType'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Device Type',
                          labelStyle: TodoColors.textStyle2,
                          border: CutCornersBorder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  ListTile(
                    title: Container(
                      child: InputDecorator(
                        key: _deviceCondition,
                        child: Text(
                          document['deviceCondition'],
                          style: TodoColors.textStyle3.apply(
                              color: TodoColors.baseColors[widget.colorIndex]),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Device Condition',
                          labelStyle: TodoColors.textStyle2,
                          border: CutCornersBorder(),
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

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('devices').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen()
            );
          } else {
            DocumentSnapshot document = snapshot.data.documents.where((doc){
              return doc.documentID == widget.deviceRatingDocumentID;}).first;


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