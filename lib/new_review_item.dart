import 'project_details.dart';
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewReviewItem extends StatelessWidget
{
  final int colorIndex;
  final String project_description = "This project is hkkjdkja ljdslad ladjlja alsdjla aljdsla adljld";

  const NewReviewItem({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  Widget build(BuildContext context)
  {
    return Padding
      (
      padding: EdgeInsets.only(bottom: 16.0),
      child: Align
        (
        alignment: Alignment.topCenter,
        child: SizedBox.fromSize
          (
            size: Size.fromHeight(172.0),
            child: Stack
              (
              fit: StackFit.expand,
              children: <Widget>
              [
                InkWell
                  (
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProjectDetailsPage(colorIndex: colorIndex, projectDocumentID: '-LGtLKKphde0FGD8R7U9', canRecruit: false,))),
                  child:
                  /// Item description inside a material
                  Container
                    (
                    margin: EdgeInsets.only(top: 24.0),
                    child: Material
                      (
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(12.0),
                      shadowColor: Color(0x802196F3),
                      color: Colors.white,
                      child: Padding
                        (
                        padding: EdgeInsets.all(24.0),
                        child: Column
                          (
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>
                          [
                            /// Title and rating
                            Column
                              (
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>
                              [
                                Text('[New] MISM', style: TextStyle(color: Colors.blueAccent)),
                                Row
                                  (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>
                                  [
                                    Text('No reviews', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 34.0)),
                                  ],
                                ),
                                /// Infos
                                Row
                                  (
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>
                                  [
                                    Expanded(child:Text(project_description,), flex: 1),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
