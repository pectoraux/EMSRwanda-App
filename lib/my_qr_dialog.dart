import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import 'color_override.dart';
import 'star_rating.dart';

class MyQRDialog extends StatefulWidget {
  final int colorIndex;
  final String textAvailable;
  final String textInUse;
  final String user;
  final String projectDocumentId;

  const MyQRDialog({
    @required this.colorIndex,
    @required this.textAvailable,
    @required this.textInUse,
    @required this.user,
    @required this.projectDocumentId,
  }) : assert(colorIndex != null), assert(textInUse != null), assert(textAvailable != null), assert(user != null), assert(projectDocumentId != null);

  @override
  State createState() => new MyQRDialogState();
}

class MyQRDialogState extends State<MyQRDialog> {
  bool _scannedOut = false, _scannedIn = false;
  String userdocId;

  @override
  void initState() {
    super.initState();
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
              await reference.setData({});
            Firestore.instance.runTransaction((transaction) async {
              DocumentReference reference = Firestore.instance.document('devices/$currentDeviceId');
            await transaction.update(reference, {'deviceStatus': 'In Use'});

              DocumentReference projRef = Firestore.instance.document(
                  'projects/${widget.projectDocumentId}/devices/$currentDeviceId');
              await projRef.setData({});
            });
          });
        }});
    });
  }

  void scanInDevices(String user, String mdevices){
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
              await reference.delete();
            Firestore.instance.runTransaction((transaction) async {
              DocumentReference reference = Firestore.instance.document('devices/$currentDeviceId');
            await transaction.update(reference, {'deviceStatus': 'Available'});
            });

            DocumentReference projRef = Firestore.instance.document(
                'projects/${widget.projectDocumentId}/devices/$currentDeviceId');
            await projRef.delete();
          });
        }});
    });

  }

  Widget build(BuildContext context) {

    return new AlertDialog(
      content: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Card(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget.textAvailable.isNotEmpty ?
                  ListTile(
                    title: Text("Available Devices", style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]),),
                    subtitle: Text(widget.textAvailable,
                      style: TodoColors.textStyle.apply(color: TodoColors.baseColors[widget.colorIndex]),),
                  ):Container(),
                  widget.textAvailable.isNotEmpty ?
                  new ButtonTheme.bar( // make buttons use the appropriate styles for cards
                    child: new ButtonBar(
                      children: <Widget>[
                        BackButton(),
                        !_scannedOut? new RaisedButton(
                          child: Text("SCAN OUT"),
                          textColor: TodoColors.baseColors[widget.colorIndex],
                          onPressed: () {
                            scanOutDevices(widget.user, widget.textAvailable);
//                                  showInSnackBar("Scan Out Successful !!!", TodoColors.baseColors[widget.colorIndex]);
                            if(_scannedIn) {
                              setState(() {
                                _scannedOut = true;
                              });
                              Navigator.of(context).pop();
                            }else{
                              setState(() {
                                _scannedOut = true;
                              });
                            }
                          },
                        ):Container(),
                      ],
                    ),
                  ):Container(),
                  widget.textInUse.isNotEmpty ?
                  ListTile(
                    title: Text("Devices In Use", style: TextStyle(color: Colors.redAccent),),
                    subtitle: Text(widget.textInUse,
                      style: TodoColors.textStyle.apply(color: Colors.redAccent),),
                  ):Container(),
                  widget.textInUse.isNotEmpty ?
                  new ButtonTheme.bar( // make buttons use the appropriate styles for cards
                    child: new ButtonBar(
                      children: <Widget>[
                        BackButton(),
                        !_scannedIn? new RaisedButton(
                          child: Text("SCAN IN"),
                          textColor: TodoColors.baseColors[widget.colorIndex],
                          onPressed: () {
                            scanInDevices(widget.user, widget.textInUse);
//                                  showInSnackBar("Scan In Successful !!!", TodoColors.baseColors[widget.colorIndex]);
                                  if(_scannedOut) {
                                    setState(() {
                                      _scannedIn = true;
                                    });
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }else{
                                    setState(() {
                                      _scannedIn = true;
                                    });
                                  }
                          },
                        ):Container(),
                      ],
                    ),
                  ):Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}