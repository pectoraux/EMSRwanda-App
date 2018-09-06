import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'loading_screen.dart';
import 'my_devices_dialog.dart';
import 'device_rating_page.dart';
import 'update_device.dart';

class ViewUserDevicesPage extends StatefulWidget {
  final int colorIndex;
  final String documentID;
  final String folder;
  final List res;

  const ViewUserDevicesPage({
    @required this.colorIndex,
    this.documentID,
    this.folder,
    this.res,
  }) : assert(colorIndex != null);

  @override
  ViewUserDevicesPageState createState() => ViewUserDevicesPageState();
}

class ViewUserDevicesPageState extends State<ViewUserDevicesPage> {
  List project_devices = [], user_devices = [];
  String deviceDocumentID = '', name = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

    print('JJJJJJJJJJJJ => => => ${user_devices}');

    return Scaffold
      (
      key: _scaffoldKey,
      appBar: AppBar
        (
        leading: new BackButton(key: _bkey, color: Colors.black,),
        elevation: 2.0,
        backgroundColor: Colors.white,
        title: Text('User Devices', style: TodoColors.textStyle6),
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
                  onPressed: () async {
                    new Container(
                      width: 450.0,
                    );
                    List mres = await showDialog(context: context, child: new MyDevicesDialog(colorIndex: widget.colorIndex,));
//                    print("MRES ${mres.toString()}");
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ViewUserDevicesPage(colorIndex: widget.colorIndex, documentID: widget.documentID, res: mres,)));
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
              children: snapshot.data.documents.where((device){
                if(user_devices.isEmpty){
                  return false;
                }else if (!user_devices.contains(device.documentID)) {
//                      print(device.documentID + ': ' + device['deviceName']);
                  return false;
                }else if(widget.res != null) {
                  Map final_result = widget.res[0];
                  return (final_result['deviceName'] != null ? final_result['deviceName'].toString().toLowerCase().trim() == device['deviceName'].toString().toLowerCase().trim(): true) &&
                      (final_result['deviceType'] != null ? final_result['deviceType'] == device['deviceType']: true) &&
                      (final_result['deviceCondition'] != null ? final_result['deviceCondition'] == device['deviceCondition']: true) &&
                      (final_result['deviceStatus'] != null ? final_result['deviceStatus'] == device['deviceStatus']: true);
                }else {
//                  print("AMs HERE ${widget.res.toString()}");
                  return true;
                }
              }).map((device) {

                mTiles.add(StaggeredTile.extent(2, 110.0));

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
                                (deviceName.length < 15) ?
                                Expanded(child:Text(deviceName, style: TodoColors.textStyle6), flex:1):
                                Expanded(child:Text(deviceName.substring(0,15)+'...', style: TodoColors.textStyle6), flex:1),
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
                    device['deviceName'],
                    device.documentID
                );
              }).toList(),



              staggeredTiles: mTiles,
            );


          }),
    );
  }

  void onTap(String fullName, String userID) {
    new Container(
      width: 450.0,
    );

    setState(() {
      deviceDocumentID = userID;
      name = fullName;
    });

    _scaffoldKey.currentState
        .showBottomSheet<Null>((BuildContext context) {
      return new Container(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.work, color: TodoColors.baseColors[widget.colorIndex],),
                title: new Text("View ${name}'s Details"),
                onTap: gotoViewDevice,
              ),
              new ListTile(
                leading: new Icon(Icons.update, color: TodoColors.baseColors[widget.colorIndex],),
                title: new Text("Update ${name}'s Information"),
                onTap: updateDevice,
              ),
              new ListTile(
                  leading: new Icon(Icons.delete, color: Colors.red,),
                  title: new Text('Delete User ${name}'),
                  onTap: showDeleteDialog
              ),
            ],
          ));
    });
  }

  void updateDevice(){
    List<String> deviceTypes = ['Device Types'];
    Firestore.instance.collection('devices').getDocuments().asStream()
        .forEach((snap) {
      for (var device in snap.documents) {
        deviceTypes.add(device['deviceType']);
      }
    }).whenComplete(() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) =>
              UpdateDevicePage(deviceDocumentID: deviceDocumentID,
                  colorIndex: widget.colorIndex,
                  deviceTypes: deviceTypes),)
      );
    });
  }

  void gotoViewDevice(){

      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) =>
              DeviceRatingPage(colorIndex: widget.colorIndex,
                deviceRatingDocumentID: deviceDocumentID,)));
  }

  void showDeleteDialog(){
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('DELETE  DEVICE', style: TodoColors.textStyle3.apply(color: Colors.red),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('Are You Sure You Want To'),
                new Text('Delete Device ${name} ?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('CANCEL'),
              textColor: TodoColors.baseColors[widget.colorIndex],
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
              child: Text('YES'),
              textColor: Colors.red,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                deleteDevice();
                Navigator.of(context).pop();
              }
            ),

          ],
        );
      },
    );

  }

  void deleteDevice() async {
    DocumentReference devRef = Firestore.instance.document('devices/${deviceDocumentID}');
    await devRef.delete();
    Navigator.of(context).pop();
  }

  Widget _buildTile(Widget child, String dName, String dID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>
                    DeviceRatingPage(colorIndex: widget.colorIndex,
                      deviceRatingDocumentID: dID,))),
            child: child
        )
    );
  }
}