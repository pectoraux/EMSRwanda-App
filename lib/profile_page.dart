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
    @required this.auth,
  }) : assert(colorIndex != null),
        assert(auth != null);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentUserRole, currentUserPassword, currentUserId, firstName, lastName, location;
  bool canCreateRole = false, canCreateProject = false, canCreateTag = false, canCreateUser = false, canGrantPermission = false;
  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;


  /// Indicating the current displayed page
  int _page = 0;

  Widget _buildPage(BuildContext context, DocumentSnapshot roleDocument, Profile profile) {

    var navigationItems;
    var items;

          canCreateRole = roleDocument['canCreateRole'] ? true : false;
          canCreateProject = roleDocument['canCreateProject'] ? true : false;
          canCreateTag = roleDocument['canCreateTag'] ? true : false;
          canCreateUser = roleDocument['canCreateUser'] ? true : false;
          canGrantPermission = roleDocument['canGrantPermission'] ? true : false;



      if(canCreateRole || canCreateProject || canCreateTag || canCreateTag || canCreateUser){

        navigationItems = <BottomNavigationBarItem>[];
        items = <Widget>[];

        navigationItems.add(
          BottomNavigationBarItem(
              icon: new Icon(Icons.home, color: getColor(navigationItems.length)),
              title: new Text("Home\nPage",)),
        );
        items.add(
          ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              new ProfileHeader(profile),
              new QuickActions(currentUserId: currentUserId,),
              new MainMenu(currentUserId: currentUserId,),
            ],
          ),
        );

        if (canCreateRole) {
          navigationItems.add(BottomNavigationBarItem(
              icon: new Icon(Icons.library_add,
                color: getColor(navigationItems.length),),
              title: new Text("Roles",)));
          items.add(EditRolesPage());
        }
        if (canCreateProject) {
          navigationItems.add(
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.work, color: getColor(navigationItems.length),),
                  title: new Text("Projects",)
              ));
          items.add(EditProjectPage());
        }
        if (canCreateTag) {
          navigationItems.add(
              BottomNavigationBarItem(
                  icon: new Icon(
                    Icons.title, color: getColor(navigationItems.length),),
                  title: new Text("Tags",)
              ));
          items.add(EditTagPage());
        }
        if (canCreateUser) {
          navigationItems.add(
              BottomNavigationBarItem(
                  icon: new Icon(Icons.devices,
                    color: getColor(navigationItems.length),),
                  title: new Text("Devices",)
              )
          );
          items.add(EditDevicePage());
          navigationItems.add(
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.person,
                    color: getColor(navigationItems.length),),
                  title: new Text("Users",)
              ));
          items.add(EditUserPage(auth: widget.auth, currentUserPassword: currentUserPassword,));

        };


        return new Scaffold(
          resizeToAvoidBottomPadding: false,
          body:
          new PageView(
              children: items,
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
      } else{
        return  Scaffold(
          body:
          ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              new ProfileHeader(profile),
              new QuickActions(),
              new MainMenu(currentUserId: currentUserId,),
            ],
          ),
        );
      }
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

  @override
  Widget build(BuildContext context){

    widget.auth.currentUser().then((userId) async {
      List<String> results = await Firestore.instance.collection('tables/users/$userId').getDocuments().then((doc){
        return [doc.documents[0]['userRole'], doc.documents[0]['userPassword'], doc.documents[0]['firstName'],
        doc.documents[0]['lastName'], doc.documents[0]['locations'][0]];
      });

        setState(() {
          currentUserRole = results[0];
          currentUserPassword = results[1];
          currentUserId = userId;
          firstName = results[2];
          lastName = results[3];
          location = results[4];
        });

    });

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('tables/roles/$currentUserRole').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new CircularProgressIndicator()
            );
          } else{
            try {
//              print("Role Document => => => ${snapshot.data.documents[0].data}");
              final profile = new Profile()
                ..firstName = firstName
                ..lastName = lastName
                ..location = location
                ..age = 35
                ..rating = 4.6
                ..numberProjects = 17;

              return _buildPage(context, snapshot.data.documents[0], profile);
            }catch(e){
              return Center(
                child:CircularProgressIndicator(),
              );
            }

          }
        }
    );
  }
}

