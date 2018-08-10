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
import 'loading_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  bool canCreateRole = false, canCreateProject = false, canCreateTag = false, canCreateUser = false, canCreateDevice = false,  canGrantPermission = false;
  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;
  List<String> roles = [], devices = [], deviceTypes = [], tags = [];
  final FirebaseStorage storage = new FirebaseStorage(storageBucket: 'gs://emsrwanda-app.appspot.com');

  /// Indicating the current displayed page
  int _page = 0;


  Widget _buildPage(BuildContext context, DocumentSnapshot roleDocument, Profile profile) {

    var navigationItems;
    var items;

          canCreateRole = roleDocument['canCreateRole'] ? true : false;
          canCreateProject = roleDocument['canCreateProject'] ? true : false;
          canCreateTag = roleDocument['canCreateTag'] ? true : false;
          canCreateUser = roleDocument['canCreateUser'] ? true : false;
          canCreateDevice = roleDocument['canCreateDevice'] ? true : false;
          canGrantPermission = roleDocument['canGrantPermission'] ? true : false;



      if(canCreateRole || canCreateProject || canCreateTag || canCreateTag || canCreateUser || canCreateDevice){

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
              new MainMenu(currentUserId: currentUserId, storage: storage),
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
          items.add(EditProjectPage( roles: roles, tags: tags, devices: devices,));
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
        if (canCreateDevice) {
          navigationItems.add(
              BottomNavigationBarItem(
                  icon: new Icon(Icons.devices,
                    color: getColor(navigationItems.length),),
                  title: new Text("Devices",)
              )
          );
          items.add(EditDevicePage(deviceTypes: deviceTypes,));
        }
        if (canCreateUser) {
          navigationItems.add(
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.person,
                    color: getColor(navigationItems.length),),
                  title: new Text("Users",)
              ));
          items.add(EditUserPage(auth: widget.auth, currentUserPassword: currentUserPassword, roles: roles,));

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
              new MainMenu(currentUserId: currentUserId, ),
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
  Widget build(BuildContext context) {
    try {
      widget.auth.currentUser().then((userId) async {
        List<String> results =
        await Firestore.instance.document('users/${userId}').get().then((doc) {
          return [
            doc['userRole'],
            doc['userPassword'],
            doc['firstName'],
            doc['lastName'],
            doc['locations'].toString()
          ];
        });

        setState(() {
          currentUserRole = results[0];
          currentUserPassword = results[1];
          currentUserId = userId;
          firstName = results[2];
          lastName = results[3];
          location = results[4].substring(
              results[4].indexOf('[') + 1, results[4].indexOf(']'));
        });
      });

      widget.auth.currentUser().then((userId) async {
        List<String> mResults = ["Project Staffs Roles"];
        await Firestore.instance.collection('roles').getDocuments()
            .asStream()
            .forEach((snap) {
//        print('=< =< =< ${snap.documents.forEach((role){return role['roleName']})}');
          for (var role in snap.documents) {
//          print('Role: ${role['roleName']}');
            mResults.add(role['roleName']);
          }
        });
        setState(() {
          roles = mResults;
        });
      });

      widget.auth.currentUser().then((userId) async {
        List<String> mResults = ["Device Type"];
//      List<String> mResults2 = [];
        await Firestore.instance.collection('devices').getDocuments()
            .asStream()
            .forEach((snap) {
//        print('=< =< =< ${snap.documents.forEach((role){return role['roleName']})}');
          for (var device in snap.documents) {
//          print('Role: ${role['roleName']}');
            mResults.add(device['deviceType']);
//          mResults2.add(device['deviceName']);
          }
        });
        setState(() {
          mResults.add('Other');
          deviceTypes = mResults.toSet().toList();
          devices = mResults;
          devices.removeAt(0);
          devices.removeLast();
        });
      });

      widget.auth.currentUser().then((userId) async {
        List<String> mResults = ["Tags"];
        await Firestore.instance.collection('tags').getDocuments()
            .asStream()
            .forEach((snap) {
//        print('=< =< =< ${snap.documents.forEach((role){return role['roleName']})}');
          for (var tag in snap.documents) {
//          print('Role: ${role['roleName']}');
            mResults.add(tag['tagName']);
          }
        });
        setState(() {
          tags = mResults;
        });
      });

    } catch(_){
      return BarLoadingScreen();
    }

      return new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('roles').snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
//            print("Role Document => => => ${snapshot}");
              return new Center(
                child: new BarLoadingScreen(),
              );
            } else {
              try {
                DocumentSnapshot document = snapshot.data.documents.where((
                    doc) {
                  return doc['roleName'] == currentUserRole;
                }).first;
//              print("Role Document => => => ${document.data}");

                final profile = new Profile()
                  ..firstName = firstName
                  ..lastName = lastName
                  ..location = location
                  ..age = 35
                  ..rating = 4.6
                  ..numberProjects = 17;

                return _buildPage(context, document, profile);
              } catch (e) {
                return Center(
                  child: BarLoadingScreen(),
                );
              }
            }
          }
      );
  }

}

