import 'package:flutter/material.dart';
import 'constants.dart';

class AnimatedLogo extends AnimatedWidget {
  final message;
  final factor;
  AnimatedLogo({Key key, Animation<double> animation, this.message, this.factor})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: new Container(
        height: animation.value/2.0,
        width: animation.value/factor,
        child: Column(
            children: <Widget>[
              Expanded(
                child:
                Image.asset('assets/diamond.png',),
                flex: 1,
              ),
              SizedBox(height: 16.0),
              Expanded(
                child:Text(
                  message,
                  style: TodoColors.textStyle6,
                ),
                flex: 1,),
            ]
        ),
      ),
    );
  }
}