import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'color_override.dart';
import 'my_devices_dialog.dart';
import 'device_rating_page.dart';

class ViewDevicesPage extends StatefulWidget {
  final int colorIndex;
  final DocumentSnapshot document;

  const ViewDevicesPage({
    @required this.colorIndex,
    this.document,
  }) : assert(colorIndex != null);

  @override
  ViewDevicesPageState createState() => ViewDevicesPageState();
}

class ViewDevicesPageState extends State<ViewDevicesPage> {

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

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Available Devices', style: TodoColors.textStyle6),
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
            stream:  (widget.document != null) ?
            Firestore.instance.collection('users/${widget.document.documentID}/userDevices').getDocuments().asStream()
            :Firestore.instance.collection('devices').getDocuments().asStream(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                print("SNAPSHOTn => => => ${snapshot.data.documents}");
                return new Center
                  (
                    child: new CircularProgressIndicator()
                );
              }

              return StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
                controller: controller,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                children: snapshot.data.documents.map((device) {

                  print(device.documentID + ': ' + device['deviceName']);

                  mTiles.add(StaggeredTile.extent(2, 110.0));

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
              Text(device['deviceStatus'],
              style: TextStyle(color: (device['deviceStatus'] == 'Available')?
              TodoColors.baseColors[widget.colorIndex] : Colors.redAccent)),
              Text(device['deviceName'], style: TodoColors.textStyle6)
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