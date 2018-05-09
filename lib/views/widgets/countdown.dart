import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Countdown extends AnimatedWidget  {
  Countdown({ Key key, this.animation }) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context){
    var theme = Theme.of(context);
    var textTheme = theme.textTheme.subhead.copyWith(color: const Color(0xBBFFFFFF));
    return new Text(
      animation.value.toString(),
      style: textTheme,
    );
  }
}