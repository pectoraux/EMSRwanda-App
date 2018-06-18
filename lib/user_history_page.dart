import 'package:flutter/material.dart';
import 'employment_history_page.dart';
import 'user_rating_page.dart';
import 'models.dart';
import 'view_devices.dart';
import 'profile_header.dart';
import 'quick_actions.dart';
import 'constants.dart';
import 'edit_device.dart';
import 'edit_role.dart';
import 'edit_user.dart';

class UserHistoryPage extends StatefulWidget {
  final int colorIndex;

  const UserHistoryPage({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  _UserHistoryPageState createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {

  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;

  /// Indicating the current displayed page
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final navigationItems = <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
          icon: new Icon(Icons.work, color: getColor(0),),
          title: new Text("Employment\nHistory",)),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.stars, color: getColor(1)),
          title: new Text("Rate\nUser",)),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.devices, color: getColor(2),),
          title: new Text("User\nDevices",)
      ),
    ];

    final profile = getProfile();

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new PageView(
          children: [
            new EmploymentHistoryPage(colorIndex: widget.colorIndex, isMadeByYou: false, noButton: true),
            new UserRatingPage(),
            new ViewDevicesPage(colorIndex: widget.colorIndex),
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

