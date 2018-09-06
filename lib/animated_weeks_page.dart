import 'dart:async';
import 'loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';

class AnimatedWeeksPage extends StatefulWidget {
  final int colorIndex;
  final String userDocumentId;

  AnimatedWeeksPage({
    @required this.colorIndex,
    this.userDocumentId,
  }) : assert(colorIndex != null);

  @override
  _AnimatedWeeksPageState createState() => new _AnimatedWeeksPageState();
}

class _AnimatedWeeksPageState extends State<AnimatedWeeksPage> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<
      AnimatedListState>();
  final GlobalKey<AnimatedListState> _listKey2 = new GlobalKey<
      AnimatedListState>();
  ListModel<int> _list, _list2;
  int _selectedItem;
  int _nextItem, last,
      first; // The next item inserted when the user presses the '+' button.
  int curr;
  DateTime _fromDate = new DateTime.now();
  String userId = '';
  var items = <int>[];
  var items2 = <int>[];
//  var _userName,_userStatus,_firstName,_lastName,_email1,_email2,_sex,_country,_mainPhone,_phone1,_phone2,_passportNo,_tin,_cvStatusElec,_nationalID,_role,_dob,
//  _bankAcctNo, _bankName,_editing, _emergencyContactname, _emergencyContactPhone, _insurance, _insuranceNo, _insuranceCpy, _locations, _userPassword;
bool loaded = false;

  @override
  void initState() {
    super.initState();
    setDefaults();
  }

  Future setDefaults() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user =  await _auth.currentUser();

    setState(() {
      if(widget.userDocumentId == null) {
        userId = user.uid;
      }else{
        userId = widget.userDocumentId;
      }
    });

    _list = new ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[],
      userId: userId,
      removedItemBuilder: _buildRemovedItem,
    );
    _list2 = new ListModel<int>(
      listKey: _listKey2,
      initialItems:<int>[],
      userId: userId,
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 0;
  }


  String getNextWeek(int i) {
    List<String> months = <String>[
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "June",
      "July",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    DateTime targetDay = new DateTime.now().add(new Duration(days: i * 7));
    DateTime firstDayOfCurrentWeek = Utils.firstDayOfWeek(targetDay);
    DateTime monday = firstDayOfCurrentWeek.add(new Duration(days: 1));
    DateTime lastDayOfCurrentWeek = Utils.lastDayOfWeek(firstDayOfCurrentWeek);
    DateTime friday = lastDayOfCurrentWeek.subtract(new Duration(days: 2));
    List<DateTime> selectedWeeksDays = Utils
        .daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
        .toList().sublist(0, 7);
    String result;
    if (i == 0) {
      result = "Current week";
    } else if (i == 1) {
      result = i.toString() + " week from now";
    } else {
      result = i.toString() + " weeks from now";
    }
    result +=
        "\n " + months[monday.month] + " " + monday.day.toString() + " To " +
            months[friday.month] + " " + friday.day.toString();
    print(result);
    return result;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index,
      Animation<double> animation) {
    curr = index;
    return new CardItem(
      animation: animation,
      item: _list[index],
      wk: getNextWeek(_list[index]),
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  // Used to build an item after it has been removed from the list. This method is
  // needed because a removed item remains visible until its animation has
  // completed (even though it's gone as far this ListModel is concerned).
  // The widget will be used by the [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(int item, BuildContext context,
      Animation<double> animation) {
    curr = _list.indexOf(item);
    return new CardItem(
      animation: animation,
      item: item,
      wk: getNextWeek(item),
      selected: false,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    int index;
    if (_list.length == 0) {
      last = 0;
      first = 0;
    } else {
      last = _list[_list.length - 1] + 1;
      first = _list[0] + 1;
    }
    if (_selectedItem == null) {
      index = 0; //_list.length;
      _list.insert(index, first);
      _list2.insert(index, first);
    } else {
      index = _list2.indexOf(_selectedItem);
      if (_list.indexOf(_list2[index - 1]) == -1) {
        _list.insert(_list.indexOf(_selectedItem), _list2[index - 1]);
      }
    }
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: <Widget>[
          new Scaffold(
            appBar: new AppBar(
              title: new Container(
                  child: Row
                    (
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>
                    [
                      (widget.userDocumentId == null)?
                      Icon(Icons.face, color: Colors.white):
                      new BackButton(key: GlobalKey(debugLabel: 'Back Key'), color: Colors.black,),
                      SizedBox(width: 10.0),
                      Text((widget.userDocumentId == null)?
                      "Which weeks are \nyou available ?" : "${document['firstName']}'s\nWeeks Availability",
                        style: TodoColors.textStyle7,),

                    ],
                  )
              ),
              backgroundColor: TodoColors.baseColors[widget.colorIndex],

              actions: <Widget>[
                new IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    mselectDate(context);
                  },
                  tooltip: 'Calendar',
                ),
                (widget.userDocumentId == null)?
                new IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: (){
                    _insert();
                  },
                  tooltip: 'insert a new item',
                ):Container(),

                (widget.userDocumentId == null)?
                new IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: ()
                  {
                    _remove();
                  },
                  tooltip: 'remove the selected item',
                ):Container(),

              ],
            ),
            body: Stack(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new AnimatedList(
                    key: _listKey,
                    initialItemCount: _list.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundRadius = MediaQuery.of(context).size.width;

try {
  return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return new Center(
              child: new BarLoadingScreen()
          );
        } else {
          DocumentSnapshot mdocument = snapshot.data.documents.where((user) {
            return user.documentID == userId;
          }).first;
          if (!loaded) {
            items = _toIntArr(mdocument['_list']);
            items2 = _toIntArr(mdocument['_list2']);
            _list.setItems(items);
            _list2.setItems(items2);
            loaded = true;
          }
          final converter = _buildListItem(context, mdocument);

          return converter;
        }
      });
} catch(_){
  return new BarLoadingScreen();
}
  }

  List<int> _toIntArr(List mlist){
    var result = <int>[];
    for(var s in mlist){
      result.add(s);
    }
    return result;
  }

  List<String> _toStringArr(List mlist){
    var result = <String>[];
    for(var s in mlist){
      result.add(s.toString());
    }
    return result;
  }


  Future<Null> mselectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _fromDate,
        firstDate: new DateTime(1960, 1),
        lastDate: new DateTime(2101)
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    Map<String, Object> data = <String, Object>{
      '_list': _list.getItems(),
      '_list2': _list2.getItems(),
    };
    Firestore.instance.runTransaction((transaction) async {
      DocumentReference reference =
      Firestore.instance.document('users/${userId}');
      await transaction.update(reference, data);
    });
  }


  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }


}

/// Keeps a Dart List in sync with an AnimatedList.
///
/// The [insert] and [removeAt] methods apply to both the internal list and the
/// animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that mutate the
/// list must make the same changes to the animated list in terms of
/// [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    @required this.userId,
    Iterable<E> initialItems,
  })
      : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = new List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  List<E> _items;
  String userId;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  void setItems(List<E> mItems){
    _items = mItems;
  }

  List<E> getItems(){
    return _items;
  }

  E removeAt(int index) {
    if (_items[index] != 0) {
      final E removedItem = _items.removeAt(index);
      if (removedItem != null) {
        _animatedList.removeItem(
            index, (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        });
      }
      return removedItem;
    }
    return null;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value. The text is displayed in bright green if selected is true.
/// This widget's height is based on the animation parameter, it varies
/// from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
    @required this.animation,
    this.onTap,
    @required this.item,
    @required this.wk,
    this.selected: false
  })
      : assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback onTap;
  final int item;
  final bool selected;
  final String wk;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TodoColors.textStyle6;

    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return new Padding(
      padding: const EdgeInsets.all(2.0),
      child: new SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: new SizedBox(
            height: 128.0,
            child: new Card(
              color: Colors.primaries[item % Colors.primaries.length],
              child: new Center(
                child: new Text('$wk', style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
