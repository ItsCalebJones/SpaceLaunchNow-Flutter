import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/pad.dart';

class LocationShowcase extends StatelessWidget {

  LocationShowcase(this.launch);

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    var staticMapProvider = new StaticMapProvider("AIzaSyDD5zeDM4DJxLEPK6d7RUyl89wXzlv-354");
    List<Marker> _markers = <Marker>[];
    for (Pad pad in launch.location.pads){
      _markers.add(new Marker(pad.id.toString(), pad.name, pad.latitude, pad.longitude));
    }

    Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(_markers,
        width: 600, height: 400);

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
