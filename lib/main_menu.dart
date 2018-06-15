import 'package:flutter/material.dart';
import 'view_insurance.dart';
import 'view_primary.dart';
import 'view_banking.dart';
import 'view_emergency.dart';
import 'view_projects.dart';

class MainMenu extends StatelessWidget {

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
          _buildListItem("Project Details", Icons.work, () {
            onTap(context, "Project Details");
          }),
          _buildListItem("Emergency Details", Icons.alarm, () {
            onTap(context, "Emergency Details");
          }),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    final textStyle = new TextStyle(
        color: Colors.black54, fontSize: 18.0, fontWeight: FontWeight.w600);

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
                color: Colors.purple,
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
          MaterialPageRoute(builder: (_) => ViewPrimaryPage()));
    } else if (command == "Banking Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewBankingPage()));
    } else if (command == "Insurance Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewInsurancePage()));
    } else if (command == "Project Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewProjectsPage()));
    } else if (command == "Emergency Details") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ViewEmergencyPage()));
    }
  }

}