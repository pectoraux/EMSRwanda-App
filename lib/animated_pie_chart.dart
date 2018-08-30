import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'constants.dart';
import 'loading_screen.dart';

class AnimatedPieChartPage extends StatefulWidget {
  final int colorIndex;
  final String projectDocumentId;

  const AnimatedPieChartPage({
    @required this.colorIndex,
    @required this.projectDocumentId,
  }) : assert(colorIndex != null);

  @override
  AnimatedPieChartPageState createState() => new AnimatedPieChartPageState();
}

class AnimatedPieChartPageState extends State<AnimatedPieChartPage> {
  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();
  final GlobalKey<AnimatedCircularChartState> _chartKey2 = new GlobalKey<AnimatedCircularChartState>();
  final _chartSize = const Size(300.0, 300.0);
  int sampleIndex = 0;
  int spotsFilled, spotsLeft, total, totalFemale, totalMale;
  List<List<CircularStackEntry>> _quarterlyProfitPieData, _quarterlyProfitPieData2;


  @override
  void initState() {
    super.initState();
    setDefaults();
  }

  void setDefaults() {

    Firestore.instance.collection('projects/${widget.projectDocumentId}/users').getDocuments().then((query){
      setState(() {
        spotsFilled = query.documents.length;
        totalFemale = query.documents.where((d){
          return d['sex'] == 'Female';
        }).length;
        totalMale = query.documents.where((d){
          return d['sex'] == 'Male';
        }).length;
      });
    }).whenComplete(() {
      Firestore.instance.document('projects/${widget.projectDocumentId}')
          .get()
          .then((doc) {
        setState(() {
          total = doc['staffCount'];
          spotsLeft = total - spotsFilled;
        });
      }).whenComplete(() {
        _quarterlyProfitPieData = [
          <CircularStackEntry>[
            new CircularStackEntry(
              <CircularSegmentEntry>[
                new CircularSegmentEntry(
                    spotsLeft*1.0, Colors.red[200], rankKey: 'Q1'),
                new CircularSegmentEntry(
                    spotsFilled*1.0, Colors.green[200], rankKey: 'Q2'),
              ],
              rankKey: "Spots Filled:\t${spotsFilled}\nSpots Left:\t${spotsLeft}",
            ),
          ],
        ];
        _quarterlyProfitPieData2 = [
          <CircularStackEntry>[
            new CircularStackEntry(
              <CircularSegmentEntry>[
                new CircularSegmentEntry(
                    totalFemale*1.0, Colors.red[200], rankKey: 'Q1'),
                new CircularSegmentEntry(
                    totalMale*1.0, Colors.green[200], rankKey: 'Q2'),
              ],
              rankKey: 'Male Staff:\t${totalMale}\nFemale Staff:\t${totalFemale}',
            ),
          ],
        ];
      });
    });
  }

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
    try {
      return Scaffold(
          appBar: AppBar(
            leading: new BackButton(key: _bkey, color: Colors.black,),
            elevation: 2.0,
            backgroundColor: Colors.white,
            title: Text('Project Stats', style: TodoColors.textStyle6,
            ),
            actions: <Widget>
            [
              Container(
                margin: EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>
                  [
                    new FloatingActionButton(
                      child: new Icon(Icons.refresh,),
                      backgroundColor: TodoColors.baseColors[widget.colorIndex],
                      onPressed: setDefaults,
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
                        Expanded(child: Text("Spots\nFilled",
                          style: TextStyle(color: Colors.green[200]),),
                          flex: 1,),
                        Expanded(child: Text("Spots\nLeft",
                          style: TextStyle(color: Colors.red[200]),), flex: 1,),
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
                          Expanded(child: Text("Female\nStaff",
                            style: TextStyle(color: Colors.green[200]),),
                            flex: 1,),
                          Expanded(child: Text("Male\nStaff",
                            style: TextStyle(color: Colors.red[200]),),
                            flex: 1,),
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
    }catch(_){
      return BarLoadingScreen();
    }
  }

  void onTap1(){
    showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text(
          'Spots Filled vs Spots Left', style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]),
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
            textColor: TodoColors.baseColors[widget.colorIndex],
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
            'Female Staff vs Male Staff', style: TextStyle(color: TodoColors.baseColors[widget.colorIndex]),
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
              textColor: TodoColors.baseColors[widget.colorIndex],
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
