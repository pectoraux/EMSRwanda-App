import 'package:flutter/material.dart';
import 'profile_colors.dart';
import 'profile_fonts.dart';
import 'profile_icons.dart';
import 'models.dart';
import 'notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ProfileHeader extends StatefulWidget {

  final Profile profile;

  ProfileHeader(this.profile);

  @override
  ProfileHeaderState createState() => ProfileHeaderState();
}

class ProfileHeaderState extends State<ProfileHeader> {
  int _colorIndex = 0;
  String imageUrlStr = '';
  String defaultUrl = 'https://firebasestorage.googleapis.com/v0/b/emsrwanda-app.appspot.com/o/users_photos%2Flaterite.PNG?alt=media&token=c48a857c-4979-4d8b-9cc3-27676dd54295';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDefaults();
  }

  @override
  Widget build(BuildContext context) {

    final topPadding = MediaQuery
        .of(context)
        .padding
        .top;

    final headerGradient = new RadialGradient(
      center: Alignment.topLeft,
      radius: 0.4,
      colors: <Color>[
        const Color(0xFF0ABC9B),
        const Color(0xFF6AB7A8),
      ],
      stops: <double>[
        0.4, 1.0,
      ],
      tileMode: TileMode.repeated,
    );

    const headerHeight = 290.0;

    return new Container(
      height: headerHeight,
      decoration: new BoxDecoration(
        color: ProfileColors.primaryColor,
        boxShadow: <BoxShadow>[
          new BoxShadow(spreadRadius: 2.0,
              blurRadius: 4.0,
              offset: new Offset(0.0, 1.0),
              color: Colors.black38),
        ],
      ),
      child: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // linear gradient
          new Container(
            height: headerHeight,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: <Color>[ //7928D1
                    const Color(0xFF0ABC9B), const Color(0xFF6AB7A8)],
                  stops: <double>[0.3, 0.5],
                  begin: Alignment.topRight, end: Alignment.bottomLeft
              ),
            ),
          ),
          // radial gradient
          new CustomPaint(
            painter: new HeaderGradientPainter(),
          ),
          new Padding(
            padding: new EdgeInsets.only(
                top: topPadding, left: 15.0, right: 15.0, bottom: 20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildBellIcon(context),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _buildTitle(),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildAvatar(),
                ),
                _buildFollowerStats()
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build the bell icon at the top right corner of the header
  Widget _buildBellIcon(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        new IconButton(
//            icon: new Icon(
//              LineAwesomeIcons.bell, color: Colors.white, size: 30.0,),
//            onPressed: () {},
//              Navigator.of(context).push(
//                  MaterialPageRoute(builder: (_) => NotificationsPage(colorIndex: _colorIndex,)));
//            }),
      ],
    );
  }


  void setDefaults()async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();

    imageUrlStr = (user.photoUrl != null)? user.photoUrl : defaultUrl;
//    print('MMMMMMMMMMM => => => $imageUrlStr');
  }



  Widget _buildTitle() {
    return new Text("Profile",
        style: new TextStyle(
            fontFamily: ProfileFontNames.TimeBurner,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 40.0,
            letterSpacing: 1.0));
  }

  /// The avatar consists of the profile image, the users name and location
  Widget _buildAvatar() {
    final mainTextStyle = new TextStyle(fontFamily: ProfileFontNames.TimeBurner,
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 20.0);
    final subTextStyle = new TextStyle(
        fontFamily: ProfileFontNames.TimeBurner,
        fontSize: 16.0,
        color: Colors.white70,
        fontWeight: FontWeight.w700);

    return new Row(
      children: <Widget>[
        new Container(
          width: 70.0, height: 60.0,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: Image.network((imageUrlStr == null) ? defaultUrl : imageUrlStr ).image,
                fit: BoxFit.cover),
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                  color: Colors.black26, blurRadius: 5.0, spreadRadius: 1.0),
            ],
          ),
        ),
        new Padding(padding: const EdgeInsets.only(right: 20.0)),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(widget.profile.fullName, style: mainTextStyle),
            new Text(widget.profile.location, style: subTextStyle),
          ],
        ),
      ],
    );
  }

  Widget _buildFollowerStats() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildUserStat("Age", widget.profile.age.toString()),
        _buildVerticalDivider(),
        _buildUserStat("Rating", widget.profile.rating.toString()),
        _buildVerticalDivider(),
        _buildUserStat("Number of Projects", widget.profile.numberProjects.toString()),
      ],
    );
  }

  Widget _buildUserStat(String title, String value) {
    final titleStyle = new TextStyle(
        fontSize: 16.0,
        fontFamily: ProfileFontNames.TimeBurner,
        color: Colors.white);
    final valueStyle = new TextStyle(
        fontFamily: ProfileFontNames.TimeBurner,
        fontSize: 18.0,
        fontWeight: FontWeight.w700,
        color: Colors.white);
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(title, style: titleStyle),
        new Text(value, style: valueStyle),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return new Container(
      height: 30.0,
      width: 1.0,
      color: Colors.white30,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}

class HeaderGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: paint background radial gradient
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}