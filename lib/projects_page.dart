import 'package:flutter/material.dart';
import 'main_menu.dart';
import 'models.dart';
import 'edit_tag.dart';
import 'edit_project.dart';
import 'search_projects.dart';
import 'ongoing_projects.dart';
import 'upcoming_projects.dart';
import 'constants.dart';
import 'edit_device.dart';
import 'edit_role.dart';
import 'closed_projects.dart';

class ProjectsPage extends StatefulWidget {
  final int colorIndex;

  const ProjectsPage({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  ProjectsPageState createState() => ProjectsPageState();
}

class ProjectsPageState extends State<ProjectsPage> {

  /// This controller can be used to programmatically
  /// set the current displayed page
  PageController _pageController;

  /// Indicating the current displayed page
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final navigationItems = <BottomNavigationBarItem>[
      new BottomNavigationBarItem(
          icon: new Icon(Icons.search, color: getColor(0)),
          title: new Text("Search\nProjects",)),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.work, color: getColor(1),),
          title: new Text("Ongoing\nProjects",)),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.group_work, color: getColor(2),),
          title: new Text("Upcoming\nProjects",)
      ),
      new BottomNavigationBarItem(
          icon: new Icon(Icons.clear, color: getColor(3),),
          title: new Text("Closed\nProjects",)
      ),
    ];

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new PageView(
          children: [
            new SearchProjectsPage(colorIndex: widget.colorIndex),
            new OngoingProjectsPage(colorIndex: widget.colorIndex),
            new UpcomingProjectsPage(colorIndex: widget.colorIndex),
            new ClosedProjectsPage(colorIndex: widget.colorIndex),
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

