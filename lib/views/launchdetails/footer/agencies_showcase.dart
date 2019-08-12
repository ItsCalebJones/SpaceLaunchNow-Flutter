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

    Agency lsp = mLaunch.launchServiceProvider;
    String lspName = "Unknown";
    String lspAdmin = "Unknown Administrator";
    String lspfounded = "Founded: Unknown";
    String lspDescription = "";

    if (lsp != null) {
      String lspFoundedYear = lsp.foundingYear;
      if (lspFoundedYear != null) {
        lspfounded = "Founded: " + lsp.foundingYear;
      }

      if (lsp.name != null) {
        lspName = lsp.name;
      }
      if (lsp.administrator != null) {
        lspAdmin = lsp.administrator;
      }
      if (lsp.description != null) {
        lspDescription = lsp.description;
      }
    }

    Widget _buildStats() {
      if (lsp != null &&
          lsp.successfulLaunches != null &&
          lsp.failedLaunches != null &&
          lsp.pendingLaunches != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "Launch Stats",
                style: textTheme.headline.copyWith(fontWeight: FontWeight.bold),
              ),
              new Text(
                "Successful: " + lsp.successfulLaunches.toString(),
                style: textTheme.subhead.copyWith(),
                textAlign: TextAlign.start,
              ),
              new Text(
                "Failed: " + lsp.failedLaunches.toString(),
                style: textTheme.subhead.copyWith(),
                textAlign: TextAlign.start,
              ),
              new Text(
                "Pending: " + lsp.pendingLaunches.toString(),
                style: textTheme.subhead.copyWith(),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        );
      }
      return null;
    }

    Widget _buildAvatar() {
      if (lsp.nationURL != null) {
        return Row(
          children: <Widget>[
            new Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 4.0, top: 8.0, bottom: 4.0),
                child: new Container(
                  width: 125.0,
                  height: 125.0,
                  padding: const EdgeInsets.all(2.0),
                  // borde width
                  decoration: new BoxDecoration(
                    color: Theme.of(context).highlightColor, // border color
                    shape: BoxShape.circle,
                  ),
                  child: new CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundImage: new NetworkImage(lsp.nationURL),
                    radius: 50.0,
                    backgroundColor: Colors.white,
                  ),
                )),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(
                    lspName,
                    style: textTheme.title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    lspAdmin,
                    style: textTheme.subhead.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    lspfounded,
                    style: textTheme.subhead.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        );
      } else
        return new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                lspName,
                style: textTheme.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                lspAdmin,
                style: textTheme.subhead.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                lspfounded,
                style: textTheme.subhead.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
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
            child: new Text('Website'),
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
            child: new Text('Wiki'),
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
          style: textTheme.subhead.copyWith(),
          textAlign: TextAlign.left,
        ));
      }

      return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatar(),
          new Column(children: lspWidgets),
          Padding(
            padding: const EdgeInsets.all(4.0),
          ),
          new Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
            child: new Text(
              lspDescription,
              style: textTheme.body1.copyWith(),
              textAlign: TextAlign.start,
            ),
          ),
          _buildStats(),
        ],
      );
    }

    return new Padding(
      padding: const EdgeInsets.all(0.0),
      child: new Column(
        children: <Widget>[_buildLSP()],
      ),
    );
  }
}
