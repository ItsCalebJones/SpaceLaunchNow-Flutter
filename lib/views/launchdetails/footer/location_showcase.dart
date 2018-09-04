import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/map_view/map_view.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/pad.dart';
import 'package:spacelaunchnow_flutter/util/Secret.dart';
import 'package:spacelaunchnow_flutter/util/SecretLoader.dart';

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
    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload
    List<Marker> _markers = <Marker>[];
    for (Pad pad in launch.location.pads){
      _markers.add(new Marker(pad.id.toString(), pad.name, pad.latitude, pad.longitude));
    }

    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    Future<Secret> secret = SecretLoader(secretPath: "api-keys.json").load();
    secret.then((result) {
      var staticMapProvider = new StaticMapProvider(result.apiKey);
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        staticMapUri = staticMapProvider.getStaticUriWithMarkers(_markers, width: 600, height: 350);
      });
    });
  }

  @override
  Widget build(BuildContext context) {

  return new Column(
    children: <Widget>[
      new Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: new InkWell(
              child: new Center(
                child: new Image.network(staticMapUri.toString()),
              ),
            ),
      ),
      new Text(launch.location.pads.first.name, style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white),),
    ],
  );
  }
}
