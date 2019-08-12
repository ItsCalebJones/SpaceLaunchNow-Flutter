import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationShowcaseWidget extends StatefulWidget {
  final Launch _launch;

  LocationShowcaseWidget(this._launch);

  @override
  State createState() => new LocationShowcaseState(this._launch);
}

class LocationShowcaseState extends State<LocationShowcaseWidget> {
  LocationShowcaseState(this._launch);

  final Launch _launch;
  Uri staticMapUri;

  @override
  void initState() {
    if (_launch.pad.mapImage != null) {
      staticMapUri = Uri.parse(_launch.pad.mapImage);
    }
    if (_launch.pad.location.mapImage != null) {
      staticMapUri = Uri.parse(_launch.pad.mapImage);
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildActionButtons(ThemeData theme) {
    List<Widget> materialButtons = [];

    if (_launch.pad.mapURL != null) {
      materialButtons.add(new MaterialButton(
        elevation: 2.0,
        minWidth: 130.0,
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          _launchURL(_launch.pad.mapURL);
        },
        child: new Text('Explore Map'),
      ));
    }

    if (_launch.pad.wikiURL != null) {
      materialButtons.add(new MaterialButton(
        elevation: 2.0,
        minWidth: 130.0,
        color: Colors.redAccent,
        textColor: Colors.white,
        onPressed: () {
          _launchURL(_launch.pad.wikiURL);
        },
        child: new Text('Location Wiki'),
      ));
    }

    return new Padding(
      padding:
          const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: materialButtons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(
              top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
          child: new InkWell(
            child: new Center(
              child: new Image.network(_launch.pad.location.mapImage),
            ),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 2.0, left: 16.0, right: 16.0, bottom: 4.0),
          child: new Text(
            _launch.pad.location.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption.copyWith(),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 0.0, left: 8.0, right: 8.0),
          child: new InkWell(
            child: new Center(
              child: new Image.network(_launch.pad.mapImage),
            ),
          ),
        ),
        new Text(
          _launch.pad.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
        _buildActionButtons(theme),
      ],
    );
  }
}
