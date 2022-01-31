import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationShowcaseWidget extends StatefulWidget {
  final Launch? _launch;

  const LocationShowcaseWidget(this._launch);

  @override
  State createState() => LocationShowcaseState(_launch);
}

class LocationShowcaseState extends State<LocationShowcaseWidget> {
  LocationShowcaseState(this._launch);

  final Launch? _launch;
  Uri? staticMapUri;

  @override
  void initState() {
    if (_launch!.pad!.mapImage != null) {
      staticMapUri = Uri.parse(_launch!.pad!.mapImage!);
    }
    if (_launch!.pad!.location!.mapImage != null) {
      staticMapUri = Uri.parse(_launch!.pad!.mapImage!);
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

    if (_launch!.pad!.mapURL != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.map),
        onPressed: () {
          launch(_launch!.pad!.mapURL!);
        },
        tooltip: "Map",
      ));
    }

    if (_launch!.pad!.wikiURL != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          launch(_launch!.pad!.wikiURL!);
        },
        tooltip: "Wikipedia",
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: materialButtons,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
            child: Text(
              "Launch Location",
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            )),
        Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Text(
              _launch!.pad!.name!,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline5,
            )),
        Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Text(
              _launch!.pad!.location!.name!,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.subtitle1,
            )),
        _buildActionButtons(theme),
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
          child: InkWell(
            child: Center(
              child: Image.network(_launch!.pad!.location!.mapImage!),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            _launch!.pad!.location!.name!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption!.copyWith(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 0.0, left: 8.0, right: 8.0),
          child: InkWell(
            child: Center(
              child: Image.network(_launch!.pad!.mapImage!),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            _launch!.pad!.name!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        const SizedBox(height: 100)
      ],
    );
  }
}
