import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';

class LocationShowcaseWidget extends StatefulWidget {
  final Launch? _launch;

  const LocationShowcaseWidget(this._launch, {super.key});

  @override
  State<LocationShowcaseWidget> createState() => LocationShowcaseState(_launch);
}

class LocationShowcaseState extends State<LocationShowcaseWidget> {
  LocationShowcaseState(this._launch);

  final Launch? _launch;
  Uri? staticMapUri;

  @override
  void initState() {
    super.initState();
    if (_launch!.pad!.mapImage != null) {
      staticMapUri = Uri.parse(_launch!.pad!.mapImage!);
    }
    if (_launch!.pad!.location!.mapImage != null) {
      staticMapUri = Uri.parse(_launch!.pad!.mapImage!);
    }
  }

  Widget _buildActionButtons(ThemeData theme) {
    List<Widget> materialButtons = [];

    if (_launch!.pad!.mapURL != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.map),
        onPressed: () {
          openUrl(_launch!.pad!.mapURL!);
        },
        tooltip: "Map",
      ));
    }

    if (_launch!.pad!.wikiURL != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          openUrl(_launch!.pad!.wikiURL!);
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
                  .headlineMedium!
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
              style: Theme.of(context).textTheme.headlineSmall,
            )),
        Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Text(
              _launch!.pad!.location!.name!,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium,
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
            style: Theme.of(context).textTheme.bodySmall!.copyWith(),
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
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 100)
      ],
    );
  }
}
