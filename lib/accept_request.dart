import 'package:flutter/material.dart';

class AcceptRequestPage extends StatefulWidget {
  @override
  AcceptRequestPageState createState() => AcceptRequestPageState();
}

class AcceptRequestPageState extends State<AcceptRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      body: CustomScrollView
        (
        slivers: <Widget>
        [
          SliverAppBar
            (
            expandedHeight: 170.0,
            backgroundColor: Colors.red,
            flexibleSpace: FlexibleSpaceBar
              (
              title: Text('Erin Niamkey'),
              background: SizedBox.expand
                (
                child: Stack
                  (
                  alignment: Alignment.center,
                  children: <Widget>
                  [
                    Image.asset('res/shoes1.png'),
                    Container(color: Colors.black26)
                  ],
                ),
              ),
            ),
            elevation: 2.0,
            forceElevated: true,
            pinned: true,
          ),
          SliverList
            (
            delegate: SliverChildListDelegate
              (
                <Widget>
                [
                  Center
                    (
                    child: Container
                      (
                        margin: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 54.0),
                        child: Material
                          (
                          elevation: 8.0,
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(32.0),
                          child: InkWell
                            (
                            onTap: () {},
                            child: Padding
                              (
                              padding: EdgeInsets.all(12.0),
                              child: Row
                                (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.add, color: Colors.white),
                                  Padding(
                                      padding: EdgeInsets.only(right: 16.0)),
                                  Text('ACCEPT',
                                      style: TextStyle(color: Colors.white)),
                                  Padding(
                                      padding: EdgeInsets.only(right: 16.0)),
                                  Icon(Icons.remove, color: Colors.white),
                                  Padding(
                                      padding: EdgeInsets.only(right: 16.0)),
                                  Text('REJECT',
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                        )
                    ),
                  ),

                  /// Rating average
                  Center
                    (
                    child: Container
                      (
                      margin: EdgeInsets.only(top: 16.0),
                      child: Text
                        (
                          '4.6',
                          style: TextStyle(color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 64.0)
                      ),
                    ),
                  ),

                  /// Rating stars
                  Padding
                    (
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    child: Row
                      (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>
                      [
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.amber, size: 48.0),
                        Icon(Icons.star, color: Colors.black12, size: 48.0),
                      ],
                    ),
                  ),

                  /// Rating chart lines
                  Padding
                    (
                    padding: EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: Column
                      (
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>
                      [

                        /// 5 stars and progress bar
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.green),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.9,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(
                                      accentColor: Colors.lightGreen),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.7,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.yellow),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.25,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.orange),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.07,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding
                          (
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Row
                            (
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>
                            [
                              Row
                                (
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>
                                [
                                  Icon(Icons.star, color: Colors.black54,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                  Icon(Icons.star, color: Colors.black12,
                                      size: 16.0),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(right: 24.0)),
                              Expanded
                                (
                                child: Theme
                                  (
                                  data: ThemeData(accentColor: Colors.red),
                                  child: LinearProgressIndicator
                                    (
                                    value: 0.12,
                                    backgroundColor: Colors.black12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),

                  /// Review
                  Padding
                    (
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
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
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: Container
                          (
                          child: ListTile
                            (
                            leading: CircleAvatar
                              (
                              backgroundColor: Colors.purple,
                              child: Text('IA'),
                            ),
                            title: Text(
                                'Ivascu Adrian ★★★★★', style: TextStyle()),
                            subtitle: Text(
                                'Erin was great during this project. He always showed upon time and did a great job interviewing people :).',
                                style: TextStyle()),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Review reply
                  Padding
                    (
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    child: Row
                      (
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Material
                          (
                          elevation: 12.0,
                          color: Colors.tealAccent,
                          borderRadius: BorderRadius.only
                            (
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          child: Container
                            (
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text('Happy to hear that!', style: Theme
                                .of(context)
                                .textTheme
                                .subhead),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),

                  /// Review
                  Padding
                    (
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
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
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: Column
                          (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>
                          [
                            Container
                              (
                              child: ListTile
                                (
                                leading: CircleAvatar
                                  (
                                  backgroundColor: Colors.purple,
                                  child: Text('MK'),
                                ),
                                title: Text(
                                    'Mani Koristus ★★★★★', style: TextStyle()),
                                subtitle: Text(
                                    'Erin was great during this project. He always showed upon time and did a great job interviewing people :).',
                                    style: TextStyle()),
                              ),
                            ),
                            Padding
                              (
                              padding: EdgeInsets.only(top: 4.0, right: 10.0),
                              child: FlatButton.icon
                                (
                                  onPressed: () {},
                                  icon: Icon(
                                      Icons.reply, color: Colors.blueAccent),
                                  label: Text('Reply', style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0))
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),

                  /// Review
                  Padding
                    (
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
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
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 0.0),
                        child: Column
                          (
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>
                          [
                            Container
                              (
                              child: ListTile
                                (
                                leading: CircleAvatar
                                  (
                                  backgroundColor: Colors.purple,
                                  child: Text('MA'),
                                ),
                                title: Text(
                                    'Moribon Ali ★★★★★', style: TextStyle()),
                                subtitle: Text(
                                    'Erin was great during this project. He always showed upon time and did a great job interviewing people :).',
                                    style: TextStyle()),
                              ),
                            ),
                            Padding
                              (
                              padding: EdgeInsets.only(top: 4.0, right: 10.0),
                              child: FlatButton.icon
                                (
                                  onPressed: () {},
                                  icon: Icon(
                                      Icons.reply, color: Colors.blueAccent),
                                  label: Text('Reply', style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0))
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}