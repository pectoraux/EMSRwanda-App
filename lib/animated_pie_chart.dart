import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';


final List<List<CircularStackEntry>> _quarterlyProfitPieData = [
  <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(1000.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(500.0, Colors.green[200], rankKey: 'Q2'),
      ],
      rankKey: 'Spots Filled:\t500\nSpots Left:\t1000',
    ),
  ],
];
final List<List<CircularStackEntry>> _quarterlyProfitPieData2 = [
  <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(1500.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
      ],
      rankKey: 'Male Staff:\t1500\nFemale Staff:\t1000',
    ),
  ],
];

class AnimatedPieChartPage extends StatefulWidget {
  final int colorIndex;

  const AnimatedPieChartPage({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  AnimatedPieChartPageState createState() => new AnimatedPieChartPageState();
}

class AnimatedPieChartPageState extends State<AnimatedPieChartPage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  final GlobalKey<AnimatedCircularChartState> _chartKey2 =
  new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(300.0, 300.0);
  int sampleIndex = 0;

  void _cycleSamples() {
    setState(() {
      sampleIndex;
      List<CircularStackEntry> data = _quarterlyProfitPieData[sampleIndex % 3];
      _chartKey.currentState.updateData(data);
      List<CircularStackEntry> data2 = _quarterlyProfitPieData2[sampleIndex % 3];
      _chartKey2.currentState.updateData(data2);
    });
  }

  @override
  Widget build(BuildContext context) {

    final _bkey = GlobalKey(debugLabel: 'Back Key');
    return Scaffold
    (
        appBar: AppBar
    (
    leading: new BackButton(key: _bkey, color: Colors.black,),
    elevation: 2.0,
    backgroundColor: Colors.white,
    title: Text('Project Stats', style: TodoColors.textStyle6,
    ),
    actions: <Widget>
    [
    Container
    (
    margin: EdgeInsets.only(right: 8.0),
    child: Row
    (
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>
    [
    new FloatingActionButton(
    child: new Icon(Icons.refresh,),
      backgroundColor: TodoColors.baseColors[widget.colorIndex],
      onPressed: _cycleSamples,
    ),
    ],
    ),
    )
    ],
    ),
    body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    children: <Widget>[
     _buildTile(
        Scaffold(
      appBar: new AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child:Text("Spots\nFilled", style: TextStyle(color: Colors.green[200]),), flex: 1,),
            Expanded(child:Text("Spots\nLeft", style: TextStyle(color: Colors.red[200]),),flex: 1,),
          ],
        ),
        backgroundColor: TodoColors.baseColors[widget.colorIndex],
      ),
      body: new Center(
        child: new AnimatedCircularChart(
          key: _chartKey,
          size: _chartSize,
          initialChartData: _quarterlyProfitPieData[0],
          chartType: CircularChartType.Pie,
        ),
      ),

    ),
        onTap: onTap1,
    ),
     _buildTile(
       Scaffold(
         appBar: new AppBar(
           title: Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Expanded(child:Text("Female\nStaff", style: TextStyle(color: Colors.green[200]),), flex: 1,),
               Expanded(child:Text("Male\nStaff", style: TextStyle(color: Colors.red[200]),),flex: 1,),
             ],
           ),
           backgroundColor: TodoColors.baseColors[widget.colorIndex],
         ),
         body: new Center(
           child: new AnimatedCircularChart(
             key: _chartKey2,
             size: _chartSize,
             initialChartData: _quarterlyProfitPieData2[0],
             chartType: CircularChartType.Pie,
           ),
         ),

       ),
       onTap: onTap2
     ),
    ],
    staggeredTiles: [
    StaggeredTile.extent(2, 310.0),
    StaggeredTile.extent(2, 310.0),
    ],
    )
    );
  }

  void onTap1(){
    showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text(
          'Spots Filled vs Spots Left', style: TextStyle(color: TodoColors.baseColors[1]),
        ),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(_quarterlyProfitPieData[0][sampleIndex].rankKey),
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            child: Text('CLOSE'),
            elevation: 8.0,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
    );
  }
  void onTap2 (){

    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            'Female Staff vs Male Staff', style: TextStyle(color: TodoColors.baseColors[1]),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(_quarterlyProfitPieData2[0][sampleIndex].rankKey),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('CLOSE'),
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        color: Colors.white,
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {
              print('Not set yet');
            },
            child: child
        )
    );
  }
}
