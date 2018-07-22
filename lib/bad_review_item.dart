import 'project_details.dart';
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadReviewItem extends StatelessWidget
{
  final int colorIndex;
  final String project_description = "This project is hkkjdkja ljdslad ladjlja alsdjla aljdsla adljld";

  const BadReviewItem({
    @required this.colorIndex,
  }) : assert(colorIndex != null);

  @override
  Widget build(BuildContext context)
  {
    return Padding
      (
      padding: EdgeInsets.only(bottom: 16.0),
      child: Stack
        (
        children: <Widget>
        [
          /// Item card
          Align
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
                          color: Colors.transparent,
                          child: Container
                            (
                            decoration: BoxDecoration
                              (
                                gradient: LinearGradient
                                  (
                                    colors: [ Color(0xFFDA4453), Color(0xFF89216B) ]
                                )
                            ),
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
                                      Text('CookStoves', style: TextStyle(color: Colors.white)),
                                      Row
                                        (
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>
                                        [
                                          Text('1.3', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w700, fontSize: 34.0)),
                                          Icon(Icons.star, color: Colors.amber, size: 24.0),
                                        ],
                                      ),
                                    ],
                                  ),
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
          /// Review
          Padding
            (
            padding: EdgeInsets.only(top: 160.0, right: 32.0,),
            child: Material
              (
              elevation: 12.0,
              color: Colors.white,
              borderRadius: BorderRadius.only
                (
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Container
                (
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile
                  (
                  leading: CircleAvatar
                    (
                    backgroundColor: Colors.purple,
                    child: Text('IA'),
                  ),
                  title: Text('Ivascu Adrian ★☆☆☆☆'),
                  subtitle: Text('Erin\'s work on this project has been a complete mess. She never showed up on time, was always arguing with a'
                      'collegue about something and never seemed to give much consideration to her tasks.', maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}