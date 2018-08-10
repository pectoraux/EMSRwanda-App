import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'view_insurance.dart';
import 'view_primary.dart';
import 'view_banking.dart';
import 'view_emergency.dart';
import 'view_projects.dart';
import 'constants.dart';

class MainMenu extends StatelessWidget {
final String currentUserId;
final FirebaseStorage storage;

MainMenu({Key key, this.currentUserId, this.storage}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: const BoxConstraints(maxHeight: 240.0),
      child: new ListView(
        padding: const EdgeInsets.only(left: 5.0),
        children: <Widget>[
          _buildListItem("Primary Details", Icons.camera, () {
            onTap(context, "Primary Details");
          }),
          _buildListItem("Banking Details", Icons.account_balance, () {
            onTap(context, "Banking Details");
          }),
          _buildListItem("Insurance Details", Icons.local_hospital, () {
            onTap(context, "Insurance Details");
          }),
          _buildListItem("Emergency Details", Icons.alarm, () {
            onTap(context, "Emergency Details");
          }),
//          _buildListItem("Projects Details", Icons.work, () {
//            onTap(context, "Project Details");
//          }),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    final textStyle = TodoColors.textStyle7;

    return new InkWell(
      onTap: action,
      child: new Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              width: 35.0,
              height: 35.0,
              margin: const EdgeInsets.only(right: 10.0),
              decoration: new BoxDecoration(
                color: TodoColors.baseColors[0],
                borderRadius: new BorderRadius.circular(5.0),
              ),
              alignment: Alignment.center,
              child: new Icon(iconData, color: Colors.white, size: 24.0),
            ),
            new Text(title, style: textStyle),
            new Expanded(child: new Container()),
            new IconButton(
                icon: new Icon(Icons.chevron_right, color: Colors.black26),
                onPressed: action)
          ],
        ),
      ),
    );
  }

  void onTap(BuildContext context, String command) {
    if (command == "Primary Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewPrimaryPage(currentUserId: currentUserId, storage: storage,)));
    } else if (command == "Banking Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewBankingPage(currentUserId: currentUserId,)));
    } else if (command == "Insurance Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewInsurancePage(currentUserId: currentUserId,)));
    }  else if (command == "Emergency Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewEmergencyPage(currentUserId: currentUserId,)));
    }
  }

}