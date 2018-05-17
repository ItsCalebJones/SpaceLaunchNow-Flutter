import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:duration/duration.dart';

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    var theme = Theme.of(context);
    Duration duration = new Duration(seconds: animation.value);
    return new Card(
      elevation: 2.0,
      color: Colors.blue,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)
      ),
      margin: new EdgeInsets.only(left: 16.0, right: 16.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
           ListTile(
             //TODO Copy Duration locally and stop log spam and make it pretty.
            leading: const Icon(Icons.thumb_up, color: Colors.white, size: 32.0,),
            title: Text("Go For Launch",
                style: theme.textTheme.title.copyWith(color: Colors.white),),
            subtitle:  Text('Launch attempt in ${printDuration(duration, conjugation: ' and ', delimiter: ", ", tersity: DurationTersity.minute)}.',
                style: theme.textTheme.subhead.copyWith(color: Colors.white70)),
          ),
//           new ButtonTheme.bar( // make buttons use the appropriate styles for cards
//             child: new ButtonBar(
//               children: <Widget>[
//                 new FlatButton(
//                   child: Text('SHARE',
//                       style: theme.textTheme.button.copyWith(color: Colors.white)),
//                   onPressed: () { /* ... */ },
//                 ),
//                 new FlatButton(
//                   child: Text('WATCH LIVE',
//                       style: theme.textTheme.button.copyWith(color: Colors.white)),
//                   onPressed: () { /* ... */ },
//                 ),
//               ],
//             ),
//           ),
        ],
      ),
    );
  }
}
