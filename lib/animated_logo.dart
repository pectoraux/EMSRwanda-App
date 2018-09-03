import 'package:flutter/material.dart';
import 'constants.dart';

class AnimatedLogo extends AnimatedWidget {
  final int colorIndex;
  final String message;
  final double factor;
  final loginPage;

  AnimatedLogo({
    Key key,
    @required this.colorIndex,
    @required this.factor,
    @required this.message,
    @required animation,
    this.loginPage,
  }) : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return new Center(
      child: new Container(
        height: animation.value/2.0,
        width: animation.value/factor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child:
                Image.asset('assets/icons/launcher.png',),
                flex: 1,
              ),
//              SizedBox(height: 16.0),

//              Card(
//                color: TodoColors.baseColors[colorIdx],
              Expanded(
            child: loginPage == null ? Material( child:
            Theme(
              // Create a unique theme with "ThemeData"
              data: ThemeData(
//                accentColor: Colors.yellow,
              ),
                child: Text(
                  message,
                  style: TodoColors.textStyle6.apply(color: TodoColors.baseColors[colorIndex],),
//                    softWrap: true, overflow: TextOverflow.fade,
                ),
            ),) : Text(
              message,
              style: TodoColors.textStyle6,),
              flex: 1,
    ),
            ]
        ),
      ),
    );
  }
}