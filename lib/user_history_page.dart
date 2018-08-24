import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'employment_history_page.dart';
import 'user_rating_page.dart';
import 'loading_screen.dart';
import 'view_devices.dart';
import 'animated_weeks_page.dart';
import 'constants.dart';
import 'send_work_request_page.dart';
import 'view_user_primary.dart';

class UserHistoryPage extends StatefulWidget {
  final int colorIndex;
  final String userDocumentID;
  final bool canRateUser;
  final bool canRecruit;
  final String projectDocumentID;
  final bool noButton;
  final bool isStaff;

  const UserHistoryPage({
    @required this.colorIndex,
    @required this.userDocumentID,
    @required this.canRateUser,
    @required this.canRecruit,
    this.projectDocumentID,
    @required this.noButton,
    this.isStaff,
  }) : assert(colorIndex != null),
        assert(userDocumentID != null),
        assert(canRateUser != null),
  assert(canRecruit != null);

  @override
  _UserHistoryPageState createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {

  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;
  /// Indicating the current displayed page
  int _page = 0;

  Color getColor(int idx) {
    final iconColor = Color(0xEFCCCCCD);
    if (_page == idx) {
      return TodoColors.baseColors[0];
    } else {
      return iconColor;
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


  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    final navigationItems = <BottomNavigationBarItem>[];
    final items = <Widget>[];

    navigationItems.add(
      new BottomNavigationBarItem(
          icon: new Icon(Icons.details, color: getColor(0),),
          title: new Text("User\nDetails", textAlign: TextAlign.center,)
      ),
    );
    items.add(new ViewUserPrimaryPage(colorIndex: widget.colorIndex,
      currentUserId: widget.userDocumentID, projectDocumentId: widget.projectDocumentID, canCreateUser: widget.colorIndex == 0,),);

    navigationItems.add(
      new BottomNavigationBarItem(
          icon: new Icon(Icons.work, color: getColor(1),),
          title: new Text(
            "Project\nHistory", textAlign: TextAlign.center,)),
    );

    if(widget.canRecruit){
      items.add(new SendWorkRequestPage(colorIndex: widget.colorIndex,
        userDocumentID: document.documentID,
        projectDocumentID: widget.projectDocumentID,));

    }else {
      items.add(new EmploymentHistoryPage(colorIndex: widget.colorIndex,
        isMadeByYou: false,
        noButton: widget.noButton,
        documentID: document.documentID,
        canRecruit: widget.canRecruit,
        projectDocumentID: widget.projectDocumentID,));
    }
    if(widget.projectDocumentID != null && widget.isStaff){
      if(widget.canRateUser) {
        navigationItems.add(new BottomNavigationBarItem(
            icon: new Icon(Icons.stars, color: getColor(2)),
            title: new Text("Rate\nUser", textAlign: TextAlign.center,),),
        );
        items.add(new UserRatingPage(colorIndex: widget.colorIndex, userDocumentID: document.documentID, projectDocumentID: widget.projectDocumentID,));
      }}

    navigationItems.add(
      new BottomNavigationBarItem(
          icon: new Icon(Icons.calendar_view_day, color: getColor(widget.canRateUser?3:2),),
          title: new Text("User\nAvailability", textAlign: TextAlign.center,)
      ),
    );
    items.add(new AnimatedWeeksPage(colorIndex: widget.colorIndex, userDocumentId: widget.userDocumentID),);

    navigationItems.add(
      new BottomNavigationBarItem(
          icon: new Icon(Icons.devices, color: getColor(widget.canRateUser?4:3),),
          title: new Text("User\nDevices", textAlign: TextAlign.center,)
      ),
      );
      items.add(new ViewDevicesPage(colorIndex: widget.colorIndex, documentID: document.documentID, folder: 'userDevices',));



    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new PageView(
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
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void didUpdateWidget(UserHistoryPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _page = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new Center(
                child: new BarLoadingScreen(),
            );
          } else {

            DocumentSnapshot document = snapshot.data.documents.where((doc){

              return doc.documentID == widget.userDocumentID;}).first;


            final converter = _buildListItem(
                context, document);

            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return converter;
                } else {
                  return Center(
                    child: Container(
                      width: 450.0,
                      child: converter,
                    ),
                  );
                }
              },
            );
          }
        });
  }
}

