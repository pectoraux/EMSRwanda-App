import 'package:flutter/material.dart';
import 'flutter_calendar.dart';


class CalendarViewApp extends StatelessWidget {
  void handleNewDate(date) {
    print(date);
  }

  @override
  Widget build(BuildContext context) {
    var stl = FontWeight.normal;
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('FSI Calendar'),
        ),
        body: new Container(
          margin: new EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 10.0,
          ),
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              new Text('Weekly Calendar:'),
              new Calendar(
                onDateSelected: (date) => handleNewDate(date),

                isExpandable: true,
                dayBuilder: (BuildContext context, DateTime day) {
                  return new InkWell(
                    onTap: () => print(day),
                    child: new Container(
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black38)),
                      child: new Text(
                        day.day.toString(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}