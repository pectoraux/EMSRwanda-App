import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'my_qr_dialog.dart';

class QRCodeScanPage extends StatefulWidget {
  final int colorIndex;

  const QRCodeScanPage({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  QRCodeScanPageState createState() {
    return new QRCodeScanPageState();
  }
}

class QRCodeScanPageState extends State<QRCodeScanPage> {
  final String display_welcome = "Hey there !";
  final String display_permission_denied = "Camera permission was denied";
  final String display_unknown = "Unknown Error";
  final String display_no_scan = "You pressed the back button before scanning anything";
  String display_user_not_found = 'Cannot Find User In The Database.\nPlease Reset And Scan Another User';
  String result = "Hey there !", buffer = "";
  bool _scanIn;
  bool _scannedOut = false, _scannedIn = false;   // used to know when to dismiss the dialog box
  bool firstScan = true, deviceScan = false;
  bool tresult = false, deviceExists = false, userError;
  List<bool> mBoolResults = <bool>[], devicesStatus = <bool>[];
  String bottom_btn = "RESET SCANNER";
  String userdocId;

  @override
  void initState() {
    _scanIn = false;
  }

  bool checkUserCredentials(String mUser){
      Firestore.instance.collection('users').snapshots().firstWhere((query){
        var res = query.documents.where((doc){
          return doc['firstName'] == mUser;
        });
        setState(() {
//          print('SSSSSSSSS => => => ${res.toList()} <= <= <= ${mUser}');
          tresult = res.toList().isNotEmpty;
        });
        return tresult;
      });
      return tresult;
  }

  bool checkDeviceCredentials(String devName, bool fillStatus){
    Firestore.instance.collection('devices').snapshots().firstWhere((query){
      var res = query.documents.where((doc){
//        print('SSSSSSSSS => => => ${doc['deviceName'].toLowerCase()} <= <= <= ${devName}');
      if(doc['deviceName'].toLowerCase() == devName.toLowerCase() && fillStatus) {
        setState(() {
          print('SSSSSSSSSSSTTTTTTTTTAV => => => ${devicesStatus}');
          devicesStatus.add(doc['deviceStatus'] == 'In Use');
          print('SSSSSSSSSSSTTTTTTTTTAP => => => ${devicesStatus}');
        });
      }
        return doc['deviceName'].toLowerCase() == devName.toLowerCase();
      });
      setState(() {
//          print('SSSSSSSSS => => => ${res.toList()} <= <= <= ${devName}');
        deviceExists = res.toList().isNotEmpty;
      });
      return deviceExists;
    });
    return deviceExists;
  }

  Future<List<bool>> checkDeviceExits(List<String> devNames) async {
    mBoolResults = List<bool>.generate(devNames.length, (int index) => (false));
    for(int j = 0; j < devNames.length; j++) {
      String devName = devNames[j];
      Firestore.instance.collection('devices').snapshots().firstWhere((query) {
        var res = query.documents.where((doc) {
//    print('SSSSSSSSS => => => ${doc['deviceName'].toLowerCase()} <= <= <= ${devName}');
    print('${doc['deviceName'].toLowerCase() == devName.toLowerCase()}');
          return (doc['deviceName'].toLowerCase() == devName.toLowerCase());
        });
        setState(() {
          mBoolResults[j] = res.toList().isNotEmpty;
//          print('SSSSSSSSS => => => ${res.toList()} <= <= <= ${devName}');
        });
        return true;//mBoolResults[j];
      });
    }
    return mBoolResults;
  }

  Future scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        if(result == display_welcome || result == display_permission_denied ||
          result == display_no_scan || result.startsWith(display_unknown) || result.isEmpty){
          result = qrResult;
//          print('SSSSSSSSS => => =>  <= <= <= ${result.trim()}');
              firstScan = false;
              deviceScan = true;
            checkUserCredentials(result.trim());
        }else{
          result += "\n" + qrResult;
          int len = result.length;
          result = result.split('\n').toSet().join('\n');
            checkDeviceCredentials(qrResult, result.length == len);
        }

      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = display_permission_denied;
        });
      } else {
        setState(() {
          result = display_unknown + " $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = display_no_scan;
      });
    } catch (ex) {
      setState(() {
        result = display_unknown + " $ex";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('QR CODE SCAN', style: TodoColors.textStyle6,
          ),
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
            child: new Icon(Icons.save),
            backgroundColor: TodoColors.baseColors[widget.colorIndex],
            onPressed: () {
              if(result != "" && result != display_welcome && result != display_permission_denied &&
                  result != display_no_scan && !result.startsWith(display_unknown) && deviceExists) {
                setState(() {
                  result = result.split('\n').toSet().join('\n');
                });
                onSave(result);
                setState(() {
//                  result = "";
//                  _scannedIn = false;
//                  _scannedOut = false;
                });
              } else {
                setState(() {
//                print('SSSSSSSSSSSS => => => ${result} <= <= <= ${deviceScan} = = = ${deviceExists} + = + ${tresult}');
                  buffer = result;
                  bottom_btn = 'Go Back';
                  result = 'Could not find ${result.split('\n').removeLast()} in the database.\n Click The Back Button to go back';
                });
              }
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Center
                        (
                      child:
                         Text('SCAN CODE', style: TodoColors.textStyle6)
                      ),
                    ]
                ),
              ),
              onTap: (){
            if(firstScan){
             scanQR();
//             print('TRESULT => => => ${tresult} <= <= <= ');
            }else if(tresult){
              scanQR();
//              print('TRESULT => => => ${tresult} <= <= <= ');
              setState(() {
                tresult = false;
                userError = false;
              });
            }else if (deviceExists)
    {
      setState(() {
        deviceExists = false;
      });
      scanQR();
    }else if (userError == null){
              setState(() {
                result = display_user_not_found;
                firstScan = true;
//                deviceScan = false;
              });
            }else {
              setState(() {
//                print('SSSSSSSSSSSS => => => ${result} <= <= <= ${deviceScan} = = = ${deviceExists} + = + ${tresult}');
              buffer = result;
              bottom_btn = 'Go Back';
                result = 'Could not find ${result.split('\n').removeLast()} in the database.\n Click The Back Button to go back';
              });
            }
            },
            ),
            _buildTile2(
              Padding
                (
                padding: const EdgeInsets.all(8.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      Expanded( child:
                      Text(result, style: TodoColors.textStyle6, textAlign: TextAlign.center,), flex: 1,)
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Center
                        (
                          child:
                          Text(bottom_btn, style: TodoColors.textStyle6)
                      ),
                    ]
                ),
              ),
              onTap: onTap
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 110.0),
            StaggeredTile.extent(2, 310.0),
            StaggeredTile.extent(2, 110.0),
          ],
        )
    );
  }

  void onTap (){
    setState(() {
      if (bottom_btn != 'Go Back') {
        result = "";
        firstScan = true;
        deviceScan = false;
        deviceExists = false;
        tresult = false;
      }else{
        List tmp = buffer.split('\n');
        tmp.removeLast();
        result = tmp.join('\n');
        firstScan = false;
        deviceScan = true;
        deviceExists = true;
        tresult = false;
      }
      bottom_btn = 'RESET SCANNER';
    });
    showInSnackBar("Scanner has been reset", TodoColors.baseColors[widget.colorIndex]);
  }

  Future onSave (String toProcess) async {
    String status = "Available";
    List<String> mResults = result.split("\n").toList();
    String textInUse = "", textAvailable = "";

//    print('SSSSSSSSSSSTTTTTTTTT => => => ${devicesStatus}');

    for(int i = 0; i < devicesStatus.length; i++){
      if(devicesStatus[i]){
        textInUse += '${result.split('\n')[i+1]}\n';
      }else{
        textAvailable += '${result.split('\n')[i+1]}\n';
      }
    }
//      setState(() {
//        if(status != "Available") {  // if device is in use
//          _scanIn = true;
//        }
//      });

    showDialog(context: context, child: new MyQRDialog(colorIndex: widget.colorIndex, textAvailable: textAvailable,
    textInUse: textInUse, user: result.split('\n')[0],));
//      showDialog<Null>(
//        context: context,
//        barrierDismissible: false, // user must tap button!
//        builder: (BuildContext context) {
//          return new AlertDialog(
//            content: new SingleChildScrollView(
//              child: new ListBody(
//                children: <Widget>[
//                  new Card(
//                    child: new Column(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        ListTile(
//                          title: Text("Available Devices", style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]),),
//                          subtitle: Text(textAvailable,
//                            style: TodoColors.textStyle.apply(color: TodoColors.baseColors[widget.colorIndex]),),
//                        ),
//                        new ButtonTheme.bar( // make buttons use the appropriate styles for cards
//                          child: new ButtonBar(
//                            children: <Widget>[
//                              BackButton(),
//                              new RaisedButton(
//                                child: Text(
//                                    _scannedOut? "" : "SCAN OUT"
//                                ),
//                                textColor: TodoColors.baseColors[widget.colorIndex],
//                                onPressed: () {
//                                  scanOutDevices(result.split('\n')[0], textAvailable);
////                                  showInSnackBar("Scan Out Successful !!!", TodoColors.baseColors[widget.colorIndex]);
//                                  if(_scannedIn) {
//                                    Navigator.of(context).pop();
//                                  }else{
//                                    setState(() {
//                                      _scannedOut = true;
//                                    });
//                                  }
//                                },
//                              ),
//                            ],
//                          ),
//                        ),
//                        ListTile(
//                          title: Text("Devices In Use", style: TextStyle(color: Colors.redAccent),),
//                          subtitle: Text(textInUse,
//                            style: TodoColors.textStyle.apply(color: Colors.redAccent),),
//                        ),
//                        new ButtonTheme.bar( // make buttons use the appropriate styles for cards
//                          child: new ButtonBar(
//                            children: <Widget>[
//                              BackButton(),
//                              new RaisedButton(
//                                child: Text(
////                                    _scannedIn? "" : "SCAN IN"
//                                  "SCAN IN"
//                                ),
//                                textColor: TodoColors.baseColors[widget.colorIndex],
//                                onPressed: () {
////                                  showInSnackBar("Scan In Successful !!!", TodoColors.baseColors[widget.colorIndex]);
////                                  if(_scannedOut) {
////                                    Navigator.of(context).pop();
////                                  }else{
////                                    setState(() {
////                                      _scannedIn = true;
////                                    });
////                                  }
//                                },
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            ),
//          );
//        },
//      );


//    showInSnackBar("Scanner has been reset", TodoColors.baseColors[widget.colorIndex]);
  }

  void scanOutDevices(String user, String mdevices)  {

    Firestore.instance.runTransaction((transaction) async {
      String mId;
      Firestore.instance.collection('users').getDocuments().then((d) {
        setState(() {
          userdocId = d.documents.firstWhere((doc){
            return doc['firstName'] == user;
          }).documentID;
        });
      }).whenComplete(() async {
        for(String s in mdevices.split('\n')){
        Firestore.instance.collection('devices').getDocuments().then((dd) async {
          String currentDeviceId =  dd.documents.firstWhere((mdoc) {
             return mdoc['deviceName'].toLowerCase() == s.toLowerCase();
              }).documentID;
              DocumentReference reference = Firestore.instance.document(
                  'users/${userdocId}/devices/$currentDeviceId');
//              await reference.setData({});
          Firestore.instance.runTransaction((transaction) async {
            DocumentReference reference = Firestore.instance.document('devices/$currentDeviceId');
//            await transaction.update(reference, {'deviceStatus': 'In Use'});
          });
            });
      }});
    });
  }

  void scanInDevices(String user, String mdevices){

  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
      action: new SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change!
          showInSnackBar2("Previous Action Successfully Undone", TodoColors.baseColors[widget.colorIndex]);
        },
      ),
      duration: kTabScrollDuration*10,
    ));
  }

  void showInSnackBar2(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
      duration: kTabScrollDuration,
    ));
  }




  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        color: TodoColors.baseColors[widget.colorIndex],
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {
              print('Not set yet');
            },
            child: child
        )
    );
  }

  Widget _buildTile2(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        color: Colors.white,
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {
              print('Not set yet');
            },
            child: child
        )
    );
  }
}
