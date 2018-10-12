import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/agency.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:url_launcher/url_launcher.dart';

class AgenciesShowcase extends StatelessWidget {
  AgenciesShowcase(this.mLaunch);

  final Launch mLaunch;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    Agency lsp = mLaunch.rocket.configuration.launchServiceProvider;

    Widget _buildLSP() {
      List<Widget> lspWidgets = [];
      List<Widget> lspButtons = [];
      if (lsp != null) {
        lspWidgets.add(new Text(
          lsp.name,
          style: textTheme.subhead.copyWith(color: Colors.white),
          textAlign: TextAlign.left,
        ));

        if (lsp.infoURL != null) {
          lspButtons.add(new MaterialButton(
            elevation: 2.0,
            minWidth: 140.0,
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              launch(lsp.infoURL);
            },
            child: new Text('Info URL'),
          ));
        }

        if (lsp.wikiURL != null) {
          lspButtons.add(new MaterialButton(
            elevation: 2.0,
            minWidth: 140.0,
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              launch(lsp.wikiURL);
            },
            child: new Text('Wiki URL'),
          ));
        }

        if (lspButtons.length > 0) {
          lspWidgets.add(new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: lspButtons,
            ),
          ));
        }
      } else {
        lspWidgets.add(new Text(
          "Unknown",
          style: textTheme.subhead.copyWith(color: Colors.white),
          textAlign: TextAlign.left,
        ));
      }
      return new Column(
        children: <Widget>[
          new Text(
            "Launch Service Provider",
            style: textTheme.title.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          new Column(
              children: lspWidgets
          ),
        ],
      );
    }

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[
          _buildLSP()
        ],
      ),
    );
  }
}
