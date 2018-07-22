// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'projects_page.dart';
import 'view_users.dart';
import 'view_devices.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'backdrop.dart';
import 'category.dart';
import 'category_tile.dart';
import 'unit.dart';
import 'pending_requests.dart';
import 'animated_weeks_page.dart';
import 'dashboard.dart';
import 'constants.dart';
import 'auth.dart';

//import 'package:url_launcher/url_launcher.dart';

/// Loads in unit conversion data, and displays the data.
///
/// This is the main screen for our app. It retrieves conversion data from a
/// JSON asset and from an API. It displays the [Categories] in the back panel
/// of a [Backdrop] widget and shows the [UnitConverter] in the front panel.
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatefulWidget {
  CategoryRoute({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;


  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  Category _defaultCategory;
  Category _currentCategory;
String _currentCategoryName;
  int _colorIndex = 0;
  // Widgets are supposed to be deeply immutable objects. We can update and edit
  // _categories as we build our app, and when we pass it into a widget's
  // `children` property, we call .toList() on it.
  // For more details, see https://github.com/dart-lang/sdk/issues/27755
  final _categories = <Category>[];
  static const _baseColors = TodoColors.baseColors;

  static const _icons = TodoColors.icons;


  @override
  Future<void> didChangeDependencies() async {
  super.didChangeDependencies();
  // We have static unit conversions located in our
  // assets/data/regular_units.json
  // and we want to also obtain up-to-date Currency conversions from the web
  // We only want to load our data in once
  if (_categories.isEmpty) {
  await _retrieveLocalCategories();
  }
  }

  /// Retrieves a list of [Categories] and their [Unit]s
  Future<void> _retrieveLocalCategories() async {
  // Consider omitting the types for local variables. For more details on Effective
  // Dart Usage, see https://www.dartlang.org/guides/language/effective-dart/usage
  final json = DefaultAssetBundle
      .of(context)
      .loadString('assets/data/regular_units.json');
  final data = JsonDecoder().convert(await json);
  if (data is! Map) {
  throw ('Data retrieved from API is not a Map');
  }
  var categoryIndex = 0;
  data.keys.forEach((key) {
  final List<Unit> units =
  data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

  var category = Category(
  name: key,
  units: units,
  color: TodoColors.baseColors[categoryIndex],
  iconLocation: _icons[categoryIndex],
  );
  setState(() {
  if (categoryIndex == 0) {
  _defaultCategory = category;
  }
  _categories.add(category);
  });
  categoryIndex += 1;
  });
  }

  /// Function to call when a [Category] is tapped.
  void _onCategoryTap(Category category) {
  setState(() {
  _currentCategory = category;
  _currentCategoryName = category.name.toString();
  });
  }

  /// Makes the correct number of rows for the list view, based on whether the
  /// device is portrait or landscape.
  ///
  /// For portrait, we use a [ListView]. For landscape, we use a [GridView].
  Widget _buildCategoryWidgets(Orientation deviceOrientation) {


  if (deviceOrientation == Orientation.portrait) {
  return ListView.builder(
  itemBuilder: (BuildContext context, int index) {
  var _category = _categories[index];
  return CategoryTile(
  category: _category,
  onTap:
  _category.name == apiCategory['name'] && _category.units.isEmpty
  ? null
      : _onCategoryTap,
  );
  },
  itemCount: _categories.length,
  );
  } else {
  return GridView.count(
  crossAxisCount: 2,
  childAspectRatio: 3.0,
  children: _categories.map((Category c) {
  return CategoryTile(
  category: c,
  onTap: _onCategoryTap,
  );
  }).toList(),
  );
  }
  }



  Widget condition(Category c)

  {



  if(c.name == "Dashboard"){
  return MaterialApp
  (
  title: 'Profile Page',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primarySwatch: Colors.blue),
  home: ProfilePage(colorIndex: 0, auth: widget.auth,),
  );

  }else
  if(c.name == "Projects"){
  return MaterialApp
  (
  title: 'Projects',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primarySwatch: Colors.blue),
  home: ProjectsPage(colorIndex: 1, canRecruit: false,),
  );
  }else
  if (c.name == "Pending Requests"){
  return MaterialApp
  (
  title: 'Pending Requests',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primarySwatch: Colors.blue),
  home: PendingRequestsPage(colorIndex: 2, canRecruit: false,),
  );
  }else
  if (c.name == "Explore Users"){
  return MaterialApp
  (
  title: 'Explore Users',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primarySwatch: Colors.blue),
  home: ViewUsersPage(colorIndex: 3, canRateUser: false, canRecruit: false,),
  );
  }else
  if (c.name == "Explore Devices"){
  return MaterialApp
  (
  title: 'Explore Devices',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primarySwatch: Colors.blue),
  home: ViewDevicesPage(colorIndex: 4,),
  );
  }else {
  return MaterialApp
  (
  title: 'Weeks Availability',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primarySwatch: Colors.blue),
  home: AnimatedWeeksPage(colorIndex: 5,),
  );
  }
  }


  Category getCat(Category c)

  {
  if (c == null) {
  return _defaultCategory;
  }
  return c;
  }

  @override
  Widget build(BuildContext context)

  {


  void _signOut() async {
  try {

  await widget.auth.signOut();
  widget.onSignOut();

  } catch (e) {
  print(e);
  }

  }

  if (_categories.isEmpty) {
  return Center(
  child: Container(
  height: 180.0,
  width: 180.0,
  child: CircularProgressIndicator(
    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
  ),
  );
  }

  // Based on the device size, figure out how to best lay out the list
  // You can also use MediaQuery.of(context).size to calculate the orientation
  assert(debugCheckHasMediaQuery(context));
  final listView = Padding(
  padding: EdgeInsets.only(
  left: 8.0,
  right: 8.0,
  bottom: 48.0,
  ),
  child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
  );
  return Backdrop(
  currentCategory:
  _currentCategory = getCat(_currentCategory),
  frontPanel: condition(_currentCategory),
  backPanel: listView,
  frontTitle: Text(""),
  backTitle: Row
  (
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
  textDirection: TextDirection.ltr,
  children: <Widget>
  [
//  Text("Welcome To Laterite", style: TodoColors.textStyle5,),
  Expanded(child:FlatButton(
  onPressed: () {
//  launch('https://www.laterite.com');
  },
  child: Text("Welcome To Laterite", style: TodoColors.textStyle5, textDirection:  TextDirection.rtl, textAlign: TextAlign.justify,),
  ), flex: 2, ),
  Expanded(child:FlatButton(
  onPressed: () {

  _signOut();
  },
  child: new Text('Log Out', style: TodoColors.textStyle3, textDirection:  TextDirection.rtl, textAlign: TextAlign.end,) ,
  ), flex: 2, ),
  ],
  ),

  );
  }
  void showInSnackBar(String value, Color c) {
  Scaffold.of(context).showSnackBar(new SnackBar(
  content: new Text(value),
  backgroundColor: c,
  ));
  }
}
