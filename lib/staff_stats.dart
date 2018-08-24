import 'package:flutter/material.dart';
import 'pending_requests.dart';
import 'constants.dart';
import 'animated_pie_chart.dart';
import 'view_users.dart';
import 'qrcode_scanner.dart';
import 'project_staff.dart';

class StaffNStatsPage extends StatefulWidget {
  final int colorIndex;
  final String projectDocumentId;
  final canRecruit;

  const StaffNStatsPage({
    @required this.colorIndex,
    this.projectDocumentId,
    @required this.canRecruit,
  }) : assert(colorIndex != null), assert(canRecruit != null);

  @override
  StaffNStatsPageState createState() => StaffNStatsPageState();
}

class StaffNStatsPageState extends State<StaffNStatsPage> {

  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;

  /// Indicating the current displayed page
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final navigationItems = <BottomNavigationBarItem>[];
    List items = <Widget>[];
    navigationItems.add(
      new BottomNavigationBarItem(
          icon: new Icon(Icons.assessment, color: getColor(0)),
          title: new Text("Project\nStats", textAlign: TextAlign.center)));
    items.add(
        new AnimatedPieChartPage(colorIndex: widget.colorIndex,)
    );
    navigationItems.add(
      new BottomNavigationBarItem(
          icon: new Icon(Icons.people, color: getColor(1),),
          title: new Text("Staff", textAlign: TextAlign.center)));
    items.add(
        new ProjectStaffPage(colorIndex: widget.colorIndex, projectDocumentId: widget.projectDocumentId,)
    );

    if(widget.canRecruit) {
      navigationItems.add(
        new BottomNavigationBarItem(
            icon: new Icon(Icons.access_alarms, color: getColor(2),),
            title: new Text("Pending\nRequests", textAlign: TextAlign.center))
      );
      items.add(
        PendingRequestsPage(colorIndex: widget.colorIndex, canRecruit: true, projectDocumentID: widget.projectDocumentId),
      );
      navigationItems.add(
          new BottomNavigationBarItem(
              icon: new Icon(Icons.people_outline, color: getColor(3),),
              title: new Text("Find\nUsers", textAlign: TextAlign.center))
      );
      items.add(
        new ViewUsersPage(colorIndex: widget.colorIndex, canRateUser: true,
          canRecruit: widget.canRecruit, projectDocumentId: widget.projectDocumentId,),
      );
      navigationItems.add(
          new BottomNavigationBarItem(
              icon: new Icon(Icons.border_outer, color: getColor(4),),
              title: new Text("Scan\nQR Code", textAlign: TextAlign.center,)));
      items.add(
          new QRCodeScanPage(colorIndex: widget.colorIndex, projectDocumentId: widget.projectDocumentId,)
      );
    }



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
      return TodoColors.baseColors[widget.colorIndex];
    } else {
      return iconColor;
    }
  }
}

