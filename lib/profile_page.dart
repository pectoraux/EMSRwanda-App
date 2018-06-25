import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'models.dart';
import 'edit_tag.dart';
import 'edit_project.dart';
import 'profile_header.dart';
import 'quick_actions.dart';
import 'constants.dart';
import 'edit_device.dart';
import 'edit_role.dart';
import 'edit_user.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final BaseAuth auth;
  final int colorIndex;


  const ProfilePage({
    @required this.colorIndex,
    this.auth,
  }) : assert(colorIndex != null);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;

  /// Indicating the current displayed page
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final navigationItems = <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
          icon: new Icon(Icons.home, color: getColor(0)),
          title: new Text("Home\nPage",)),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.library_add, color: getColor(1),),
          title: new Text("Roles",)),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.work, color: getColor(2),),
          title: new Text("Projects",)
      ),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.title, color: getColor(3),),
          title: new Text("Tags",)
      ),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.devices, color: getColor(4),),
          title: new Text("Devices",)
      ),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.person, color: getColor(5),),
          title: new Text("Users",)
      ),
    ];
    String userEmail = 'enumerator@laterite.com';
    final profile = getProfile();
//    Firestore.instance.collection('users').snapshots().first. documents.where((doc){
//      return  == 'emma.watson';}).first;

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new PageView(
          children: [
            new ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                new ProfileHeader(profile),
                new QuickActions(),
                new MainMenu(),
              ],
            ),
            new EditRolesPage(),
            new EditProjectPage(),
            new EditTagPage(),
            new EditDevicePage(),
            new EditUserPage(auth: widget.auth,),
          ],
          controller: _pageController,
          onPageChanged: onPageChanged
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _page,
        items: navigationItems,
        onTap: navigationTapped,
        fixedColor: TodoColors.primaryLight,
        iconSize: 25.0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  /// Called when the user presses on of the
  /// [BottomNavigationBarItem] with corresponding
  /// page index
  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Color getColor(int idx) {
    final iconColor = Color(0xEFCCCCCD);
    if (_page == idx) {
      return TodoColors.baseColors[0];
    } else {
      return iconColor;
    }
  }
}

