// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'category_route.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'shop_items_page.dart';
import 'api.dart';
import 'category.dart';
import 'unit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const _padding = EdgeInsets.all(5.0);

class _UnitConverterState extends State<UnitConverter> {
  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;
  final _inputKey = GlobalKey(debugLabel: 'inputText');
  bool _showErrorUI = false;
  final _firstName = GlobalKey(debugLabel: 'First Name');
  final _lastName = GlobalKey(debugLabel: 'Last Name');
  final _email1 = GlobalKey(debugLabel: 'Email1');
  final _email2 = GlobalKey(debugLabel: 'Email2');
  final _sex = GlobalKey(debugLabel: 'Sex');
  final _country = GlobalKey(debugLabel: 'Country');
  final _phone1 = GlobalKey(debugLabel: 'Phone1');
  final _phone2 = GlobalKey(debugLabel: 'Phone2');
  final _passportNo = GlobalKey(debugLabel: 'Passport No');
  final _bankAcctNo = GlobalKey(debugLabel: 'Banc Acct No');
  final _bankName = GlobalKey(debugLabel: 'Bank Name');
  final _insurance = GlobalKey(debugLabel: 'Insurance');
  final _insuranceNo = GlobalKey(debugLabel: 'Insurance No');
  final _insuranceCpy = GlobalKey(debugLabel: 'Insurance Copy');
  final _tin = GlobalKey(debugLabel: 'TIN');
  final _cvStatusElec = GlobalKey(debugLabel: 'CV Status Electronic');
  final _fab1 = GlobalKey(debugLabel: 'Add User');
  final _fab2 = GlobalKey(debugLabel: 'Add Role');
  final _fab3 = GlobalKey(debugLabel: 'Add Project');
  final _fab4 = GlobalKey(debugLabel: 'Add Tag');
  final _fab5 = GlobalKey(debugLabel: 'Add Device');


  bool isCheck = true;


  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }


  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
//  _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }


  Widget _createDropdown(String currentValue, ValueChanged<dynamic>

  onChanged) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        // This sets the color of the [DropdownButton] itself
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        // This sets the color of the [DropdownMenuItem]
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentValue,
              items: _unitMenuItems,
              onChanged: onChanged,
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = Padding(padding: _padding);
    final input = Padding(
      padding: _padding,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // This is the widget that accepts text input. In this case, it
          // accepts numbers and calls the onChanged property on update.
          // You can read more about it here: https://flutter.io/text-input
          ListTile(
            leading: const Icon(Icons.person),
            title: TextField(
              key: _firstName,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                contentPadding: const EdgeInsets.all(20.0),
                errorText: _showValidationError ? 'Invalid Name entered' : null,
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.text,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          ListTile(
            leading: const Icon(Icons.person),
            title: TextField(
              key: _lastName,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Last Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.text,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.email),
            title: TextField(
              key: _email1,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.emailAddress,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.email),
            title: TextField(
              key: _email2,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Other Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.emailAddress,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.phone),
            title: TextField(
              key: _phone1,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.phone,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.phone),
            title: TextField(
              key: _phone2,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Other Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.phone,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.perm_identity),
            title: TextField(
              key: _passportNo,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Passport No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.text,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.home),
            title: TextField(
              key: _bankName,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Bank Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.text,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.home),
            title: TextField(
              key: _bankAcctNo,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Bank Account Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.number,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.airline_seat_legroom_extra),
            title: TextField(
              key: _insurance,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Insurance',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.text,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.airline_seat_legroom_extra),
            title: TextField(
              key: _insuranceCpy,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Insurance Copy',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.text,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.airline_seat_legroom_extra),
            title: TextField(
              key: _insuranceNo,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'Insurance No',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.phone,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.perm_identity),
            title: TextField(
              key: _tin,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'TIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.number,
              onChanged: _updateInputValue,
            ),
          ),
          padding,
          new ListTile(
            leading: const Icon(Icons.perm_identity),
            title: TextField(
              key: _cvStatusElec,
              style: Theme
                  .of(context)
                  .textTheme
                  .button,
              decoration: InputDecoration(
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .button,
                errorText:
                _showValidationError ? 'Invalid number entered' : null,
                labelText: 'CV Status Electronic',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              // Since we only want numerical input, we use a number keyboard. There
              // are also other keyboards for dates, emails, phone numbers, etc.
              keyboardType: TextInputType.text,
              onChanged: _updateInputValue,
            ),
          ),
        ],
      ),
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final save = RaisedButton(
      onPressed: () {},
      child: new Text('Save'),
    );
    final changePasswd = RaisedButton(
      onPressed: () {
        new Container(
          width: 450.0,
        );
        showDialog(context: context, child:
        new AlertDialog(
          contentPadding: _padding,
          title: new Text("Change your Old Password",),
          content: new Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Old Password",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "New Password",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Confirm Password",
                    ),
                  ),
                ),
              ]),
        ),
        );
      },
      child: new Text('Change Password'),
    );

    final output = Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme
                  .of(context)
                  .textTheme
                  .display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
//  _createDropdown(_toValue.name, _updateToConversion),
        ],
      ),
    );

    final fab1 = new FloatingActionButton(
      key: _fab1,
      elevation: 20.0,
      child: new Icon(Icons.person_add, color: Colors.black54),
      tooltip: "Add User",
      backgroundColor: Colors.blue,
      onPressed: () {
        new Container(
          width: 450.0,
        );
        showDialog(context: context, child:
        new AlertDialog(
          contentPadding: _padding,
          title: new Text("Create A New User",),
          content: new Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "User Email",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.person),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "User Role",
                    ),
                  ),
                ),
              ]),
        ),
        );
      },
    );

    final fab2 = new FloatingActionButton(
        key: _fab2,
        tooltip: "Add Role",
        elevation: 20.0,
        child: new Icon(Icons.library_add, color: Colors.black54),
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(context: context, child:
          new AlertDialog(
            title: new Text("Create A New Role"),
            content: new Column(
                children: <Widget>[
                  new ListTile(
                    leading: const Icon(Icons.library_add),
                    title: new TextField(
                      decoration: new InputDecoration(
                        hintText: "Role Name",
                      ),
                    ),
                  ),
                  ListTile(
                      onTap: null,
                      title: new Row(
                        children: <Widget>[
                          new Expanded(child: new Text("Can Create User")),
                          new Checkbox(value: isCheck, onChanged: (bool value) {
                            setState(() {
                              isCheck = value;
                            });
                          })
                        ],
                      )
                  ),
                  ListTile(
                      onTap: null,
                      title: new Row(
                        children: <Widget>[
                          new Expanded(child: new Text("Can Delete User")),
                          new Checkbox(value: isCheck, onChanged: (bool value) {
                            setState(() {
                              isCheck = value;
                            });
                          })
                        ],
                      )
                  ),
                  ListTile(
                      onTap: null,
                      title: new Row(
                        children: <Widget>[
                          new Expanded(child: new Text("Can Create Project")),
                          new Checkbox(value: isCheck, onChanged: (bool value) {
                            setState(() {
                              isCheck = value;
                            });
                          })
                        ],
                      )
                  ),
                  ListTile(
                      onTap: null,
                      title: new Row(
                        children: <Widget>[
                          new Expanded(child: new Text("Can Delete Project")),
                          new Checkbox(value: isCheck, onChanged: (bool value) {
                            setState(() {
                              isCheck = value;
                            });
                          })
                        ],
                      )
                  ),
                  ListTile(
                      onTap: null,
                      title: new Row(
                        children: <Widget>[
                          new Expanded(child: new Text("Can Create Role")),
                          new Checkbox(value: isCheck, onChanged: (bool value) {
                            setState(() {
                              isCheck = value;
                            });
                          })
                        ],
                      )
                  ),
                  ListTile(
                      onTap: null,
                      title: new Row(
                        children: <Widget>[
                          new Expanded(child: new Text("Can Delete Role")),
                          new Checkbox(value: isCheck, onChanged: (bool value) {
                            setState(() {
                              isCheck = value;
                            });
                          })
                        ],
                      )
                  ),

                ]),));
        });

    final fab3 = new FloatingActionButton(
      key: _fab3,
      tooltip: "Add Project",
      elevation: 20.0,
      child: new Icon(Icons.add_box, color: Colors.black54),
      backgroundColor: Colors.blue,
      onPressed: () {
        new Container(
          width: 450.0,
        );
        showDialog(context: context, child:
        new AlertDialog(
          contentPadding: _padding,
          title: new Text("Create A New Project",),
          content: new Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.add_box),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Project Name",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.add_box),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Locations",
                    ),
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.add_box),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Descriptions",
                    ),
                  ),
                ),

                new ListTile(
                  leading: const Icon(Icons.add_box),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Tags",
                    ),
                  ),
                ),

              ]),
        ),
        );
      },
    );

    final fab4 = new FloatingActionButton(
      key: _fab4,
      tooltip: "Add Tag",
      elevation: 20.0,
      child: new Icon(Icons.title, color: Colors.black54),
      backgroundColor: Colors.blue,
      onPressed: () {
        new Container(
          width: 450.0,
        );
        showDialog(context: context, child:
        new AlertDialog(
          contentPadding: _padding,
          title: new Text("Create A New Tag",),
          content: new Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.title),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Tag Name",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.title),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Description",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.title),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Type",
                    ),
                  ),
                ),
              ]),
        ),
        );
      },
    );
    final fab5 = new FloatingActionButton(
      key: _fab5,
      tooltip: "Add Device",
      elevation: 20.0,
      child: new Icon(Icons.devices, color: Colors.black54),
      backgroundColor: Colors.blue,
      onPressed: () {
        new Container(
          width: 450.0,
        );
        showDialog(context: context, child:
        new AlertDialog(
          contentPadding: _padding,
          title: new Text("Add A New Device",),
          content: new Column(
              children: <Widget>[
                new ListTile(
                  leading: const Icon(Icons.devices),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Device Type",
                    ),
                  ),
                ),
                new ListTile(
                  leading: const Icon(Icons.devices),
                  title: new TextField(
                    decoration: new InputDecoration(
                      hintText: "Device Description",
                    ),
                  ),
                ),
              ]),
        ),
        );
      },
    );


    final converter = ListView(
      children: [
        new Row(
          textDirection: TextDirection.rtl,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            fab1,
            padding,
            fab2,
            padding,
            fab3,
            padding,
            fab4,
            padding,
            fab5
          ],
        ),
        input,
        padding,
        save,
        padding,
        changePasswd,
      ],
    );

    // Based on the orientation of the parent widget, figure out how to best
    // lay out our converter.
    return Padding(
      padding: _padding,
      child: OrientationBuilder(
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
      ),
    );
  }


}

/// [UnitConverter] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
class UnitConverter extends StatefulWidget {

  @override
  _UnitConverterState createState() => _UnitConverterState();
}
