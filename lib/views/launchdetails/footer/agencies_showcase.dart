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
    String lspName = "Unknown";
    String lspAdmin = "Unknown Administrator";
    String lspfounded = "Founded: Unknown";
    String lspDescription = "";

    if (lsp != null) {
      lspName = lsp.name;
      lspAdmin = lsp.administrator;
      lspfounded = "Founded: " + lsp.foundingYear;
      lspDescription = lsp.description;
    }

    Widget _buildFlights() {
      if (lsp != null) {
        return new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Successful: " + lsp.successfulLaunches.toString(),
              style: textTheme.subhead.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
            new Text(
              "Failed: " + lsp.failedLaunches.toString(),
              style: textTheme.subhead.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
            new Text(
              "Pending: " + lsp.pendingLaunches.toString(),
              style: textTheme.subhead.copyWith(color: Colors.white),
              textAlign: TextAlign.start,
            ),
          ],
        );
      }
      return null;
    }

    Widget _buildLSP() {
      List<Widget> lspWidgets = [];
      List<Widget> lspButtons = [];
      if (lsp != null) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top:8.0, bottom: 4.0),
            child: Image.network(lsp.logoURL,
              height: 150.0,
              fit: BoxFit.contain,
            ),
          ),
          new Text(
            lspName,
            style: textTheme.title.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          new Text(
            lspAdmin,
            style: textTheme.subhead.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          new Text(
            lspfounded,
            style: textTheme.subhead.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          new Divider(
            color: Colors.white,
          ),
          _buildFlights(),
          new Divider(
            color: Colors.white,
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: new Text(
              lspDescription,
              style: textTheme.body1.copyWith(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          new Column(children: lspWidgets),
        ],
      );
    }

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        children: <Widget>[_buildLSP()],
      ),
    );
  }
}
