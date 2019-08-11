import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';

class LocationShowcaseWidget extends StatefulWidget {
  final Launch launch;

  LocationShowcaseWidget(this.launch);

  @override
  State createState() => new LocationShowcaseState(this.launch);
}

class LocationShowcaseState extends State<LocationShowcaseWidget> {
  LocationShowcaseState(this.launch);

  final Launch launch;
  Uri staticMapUri;

  @override
  void initState() {
    if (launch.pad.mapImage != null){
      staticMapUri = Uri.parse(launch.pad.mapImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 16.0, right: 16.0, bottom: 8.0),
          child: new Text(
            "Launch Location",
            style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 16.0, right: 16.0, bottom: 8.0),
          child: new Text(
            launch.pad.name,
            style: Theme
                .of(context)
                .textTheme
                .subhead
                .copyWith(color: Colors.white),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: new InkWell(
            child: new Center(
              child: new Image.network(staticMapUri.toString()),
            ),
          ),
        ),
      ],
    );
  }
}
