import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'update_tag.dart';
import 'constants.dart';
import 'color_override.dart';
import 'my_tags_dialog.dart';

class ViewTagsPage extends StatefulWidget {
  final int colorIndex;

  const ViewTagsPage({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  ViewTagsPageState createState() => ViewTagsPageState();
}

class ViewTagsPageState extends State<ViewTagsPage> {
  static const _padding = EdgeInsets.all(5.0);

  @override
  Widget build(BuildContext context) {
    final _bkey = GlobalKey(debugLabel: 'Back Key');
    final _tagNameController = TextEditingController();
    final _tagName = GlobalKey(debugLabel: 'Tag Name');
    final _tagTypeController = TextEditingController();
    final _tagType = GlobalKey(debugLabel: 'Tag Type');
    List<StaggeredTile> mTiles = [];
    ScrollController controller = new ScrollController();

    return Scaffold
      (
        appBar: AppBar
          (
          leading: new BackButton(key: _bkey, color: Colors.black,),
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: Text('Available Tags', style: TodoColors.textStyle6),
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
                    elevation: 200.0,
                    child: new Icon(Icons.search),
                    backgroundColor: TodoColors.baseColors[widget.colorIndex],
                    onPressed: () {
                      new Container(
                        width: 450.0,
                      );
                      showDialog(context: context, child: new MyTagsDialog(colorIndex: widget.colorIndex,));
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('tables/tags/myTags').getDocuments().asStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
        print("SNAPSHOTn => => => ${snapshot.data.documents}");
        return new Center
        (
        child: new CircularProgressIndicator()
        );
        }

        return StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          controller: controller,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: snapshot.data.documents.map((tag) {

    print(tag.documentID + ': ' + tag['tagName']);

    mTiles.add(StaggeredTile.extent(2, 110.0));

    return _buildTile(
              Padding
                (
                padding: const EdgeInsets.all(24.0),
                child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>
                    [
                      Column
                        (
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>
                        [
                          Text(tag['tagType'],
                              style: TextStyle(color: TodoColors.baseColors[widget.colorIndex])),
                          Text(tag['tagName'], style: TodoColors.textStyle6)
                        ],
                      ),
                      Material
                        (
                          color: TodoColors.baseColors[widget.colorIndex],
                          borderRadius: BorderRadius.circular(24.0),
                          child: Center
                            (
                              child: Padding
                                (
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(Icons.title, color: Colors.white,
                                    size: 30.0),
    )
    )
    )
    ]
    ),
    ),
    tag.documentID
            );
          }).toList(),



          staggeredTiles: mTiles,
        );


        }),
    );
  }


  Widget _buildTile(Widget child, String tagID) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell
          (
          // Do onTap() if it isn't null, otherwise do print()
            onTap: () =>
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => UpdateTagPage(colorIndex:widget.colorIndex, tagDocumentID: tagID,))),
            child: child
        )
    );
  }
}