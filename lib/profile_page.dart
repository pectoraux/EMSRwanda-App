import 'dart:async';
import 'progress_bar.dart';
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
  String currentUser = "";
  String userRole = "";
  bool canCreateRole, canCreateProject, canCreateTag, canCreateUser, canGrantPermission;
  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;

  /// Indicating the current displayed page
  int _page = 0;
  int _addPage = 0;
  @override
  Widget build(BuildContext context) {

    var state = FirebaseAuth.instance.onAuthStateChanged;
    var navigationItems0 = <BottomNavigationBarItem>[];
    var items = <Widget>[];

    state.listen((onData) {
      setState(() {
        currentUser = onData.uid;
      });
    });
//    print('From Firestore : ${currentUser}');

    if(currentUser.isNotEmpty) {
      var documentState = Firestore.instance.collection('users').document(
          currentUser).snapshots().listen((onUserData) {
        setState(() {
          userRole = onUserData['userRole'];
        });
      });
    if(userRole.isNotEmpty) {
//      print('From Firestore role: ${userRole}');
//      print('USER ROLE => => => ${userRole}' );
//      navigationItems0.clear();
      navigationItems0.add(
        BottomNavigationBarItem(
            icon: new Icon(Icons.home, color: getColor(navigationItems0.length)),
            title: new Text("Home\nPage",)),
      );
      final profile = getProfile();
      items.add(
        ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            new ProfileHeader(profile),
            new QuickActions(),
            new MainMenu(),
          ],
        ),
      );

      var docState = Firestore.instance.collection('roles')
          .document(userRole)
          .snapshots()
          .listen((onRoleData) {
        setState(() {
          canCreateRole = onRoleData['canCreateRole'] ? true : false;
          canCreateProject = onRoleData['canCreateProject'] ? true : false;
          canCreateTag = onRoleData['canCreateTag'] ? true : false;
          canCreateUser = onRoleData['canCreateUser'] ? true : false;
          canGrantPermission = onRoleData['canGrantPermission'] ? true : false;
        });
      });
      if(canCreateRole || canCreateProject || canCreateTag || canCreateTag || canCreateUser){

        if (canCreateRole) {
          navigationItems0.add(BottomNavigationBarItem(
              icon: new Icon(Icons.library_add,
                color: getColor(navigationItems0.length),),
              title: new Text("Roles",)));
          items.add(EditRolesPage());
        }
        if (canCreateProject) {
          navigationItems0.add(
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.work, color: getColor(navigationItems0.length),),
                  title: new Text("Projects",)
              ));
          items.add(EditProjectPage());
        }
        if (canCreateTag) {
          navigationItems0.add(
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.title, color: getColor(navigationItems0.length),),
                  title: new Text("Tags",)
              ));
          items.add(EditTagPage());
        }
        if (canCreateUser) {
          navigationItems0.add(
              BottomNavigationBarItem(
                  icon: new Icon(Icons.devices,
                    color: getColor(navigationItems0.length),),
                  title: new Text("Devices",)
              )
          );
          items.add(EditDevicePage());
          navigationItems0.add(
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.person,
                    color: getColor(navigationItems0.length),),
                  title: new Text("Users",)
              ));
          items.add(EditUserPage(auth: widget.auth,));
        };

//    Firestore.instance.collection('users').snapshots().first. documents.where((doc){
//      return  == 'emma.watson';}).first;

        return new Scaffold(
          resizeToAvoidBottomPadding: false,
          body: new PageView(
              children: items,
              controller: _pageController,
              onPageChanged: onPageChanged
          ),
          bottomNavigationBar: new BottomNavigationBar(
            currentIndex: _page,
            items: navigationItems0,
            onTap: navigationTapped,
            fixedColor: TodoColors.primaryLight,
            iconSize: 25.0,
            type: BottomNavigationBarType.fixed,
          ),
        );
      } else{
        return  Scaffold(
          body:
          ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              new ProfileHeader(profile),
              new QuickActions(),
              new MainMenu(),
            ],
          ),
        );
      }
    }
      return Center(
        child: CircularProgressIndicator(),
      );
    }
      return Center(
       child: CircularProgressIndicator(),
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

