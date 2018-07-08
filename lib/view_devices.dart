import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'loading_screen.dart';
import 'my_devices_dialog.dart';
import 'device_rating_page.dart';

class ViewDevicesPage extends StatefulWidget {
  final int colorIndex;
  final String documentID;
  final String folder;

  const ViewDevicesPage({
    @required this.colorIndex,
    this.documentID,
    this.folder,
  }) : assert(colorIndex != null);

  @override
  ViewDevicesPageState createState() => ViewDevicesPageState();
}

class ViewDevicesPageState extends State<ViewDevicesPage> {
  List project_devices = [], user_devices = [];

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    final _deviceNameController = TextEditingController();
    final _deviceName = GlobalKey(debugLabel: 'Device Name');
    final _deviceTypeController = TextEditingController();
    final _deviceType = GlobalKey(debugLabel: 'Device Type');
    final _deviceConditionController = TextEditingController();
    final _deviceCondition = GlobalKey(debugLabel: 'Device Condition');
    List<StaggeredTile> mTiles = [];
    ScrollController controller = new ScrollController();

    if(widget.documentID != null ) {

      if(widget.folder == 'projectDevices') {
        Firestore.instance.collection(
            'projects/${widget.documentID}/devices')
            .getDocuments()
            .then((query) {
          List results = [];
          setState(() {
            for (DocumentSnapshot doc in query.documents) {
              results.add(doc.documentID);
            }
            project_devices = results;
          });
        });
      } else if(widget.folder == 'userDevices') {
        Firestore.instance.collection(
            'users/${widget.documentID}/devices')
            .getDocuments()
            .then((query) {
          List results = [];
          setState(() {
            for (DocumentSnapshot doc in query.documents) {
              results.add(doc.documentID);
            }
            user_devices = results;
          });
        });
      }
    }

    print('JJJJJJJJJJJJ => => => ${project_devices}');

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Devices', style: TodoColors.textStyle6),
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
                      showDialog(context: context, child: new MyDevicesDialog(colorIndex: widget.colorIndex,));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('devices').getDocuments().asStream(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return new Center
                  (
                    child: new BarLoadingScreen(),
                );
              }



              return StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
                controller: controller,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                children: snapshot.data.documents.map((device) {



                  mTiles.add(StaggeredTile.extent(2, 110.0));

                  if(widget.documentID != null && (widget.folder == 'projectDevices')) {
                    if (!project_devices.contains('${device.documentID}')) {
//                      print(device.documentID + ': ' + device['deviceName']);
                      return Container();
                    }
                  }
                  if(widget.documentID != null  && (widget.folder == 'userDevices')) {
                    if (!user_devices.contains('${device.documentID}')) {
                      return Container();
                    }
                  }

                  String deviceName = "${device['deviceName']}";
                  String deviceStatus = device['deviceStatus'];

                  if(deviceName.trim().isEmpty)
                    deviceName = 'Missing Device Name';
                  if(deviceStatus.trim().isEmpty)
                    deviceStatus = 'Missing Device Status';

                  return _buildTile(
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
              Text(deviceStatus,
              style: TextStyle(color: (deviceStatus == 'Available')?
              TodoColors.baseColors[widget.colorIndex] : Colors.redAccent)),
              Text(deviceName, style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: TodoColors.baseColors[widget.colorIndex],
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.devices, color: Colors.white,
                                    size: 30.0),
                              )
                          )
                      )
                    ]
                ),
              ),
    device.documentID
    );
  }).toList(),



  staggeredTiles: mTiles,
  );


}),
);
}

            Widget _buildTile(Widget child, String deviceID) {
    return Material(
    elevation: 14.0,
    borderRadius: BorderRadius.circular(12.0),
    shadowColor: Color(0x802196F3),
    child: InkWell
    (
    // Do onTap() if it isn't null, otherwise do print()
    onTap: () =>
    Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => DeviceRatingPage(colorIndex:widget.colorIndex, deviceRatingDocumentID: deviceID,))),
    child: child
    )
    );
    }
  }