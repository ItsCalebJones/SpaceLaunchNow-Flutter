import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    Widget _buildStats(TextTheme theme) {
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
                "$lspName Stats",
                style: textTheme.headline.copyWith(fontWeight: FontWeight.bold),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(
                            "Successful:",
                            style: textTheme.subhead
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: new Text(
                              lsp.successfulLaunches.toString() ?? "",
                              maxLines: 1,
                              style: textTheme.subhead,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text(
                            "Pending:",
                            style: textTheme.subhead
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: new Text(
                              lsp.pendingLaunches.toString() ?? "",
                              maxLines: 1,
                              style: textTheme.subhead,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        children: <Widget>[
                          new Text(
                            "Failed:",
                            style: textTheme.subhead
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: new Text(
                              lsp.failedLaunches.toString() ?? "",
                              maxLines: 1,
                              style: textTheme.subhead,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildLandingWidgets(textTheme))
                ],
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
            Flexible(
              child: new Column(
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
                  _buildActionButtons(),
                ],
              ),
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
            _buildActionButtons(),
          ],
        );
    }

    Widget _buildLSP() {
      List<Widget> lspWidgets = [];
      if (lsp != null) {
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: new Text(
              "Launch Agency",
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          _buildAvatar(),
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
          new Column(children: lspWidgets),
          _buildStats(textTheme),
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

  List<Widget> _buildLandingWidgets(TextTheme textTheme) {
    if (mLaunch.launchServiceProvider != null &&
        mLaunch.launchServiceProvider.attemptedLandings > 0) {
      List<Widget> widgets = new List<Widget>();
      widgets.add(
        new Row(
          children: <Widget>[
            new Text(
              "Attempted Landing:",
              style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                mLaunch.launchServiceProvider.attemptedLandings.toString() ??
                    "",
                maxLines: 1,
                style: textTheme.subhead,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );
      widgets.add(
        new Row(
          children: <Widget>[
            new Text(
              "Successful Landing:",
              style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                mLaunch.launchServiceProvider.successfulLandings.toString() ??
                    "",
                maxLines: 1,
                style: textTheme.subhead,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );
      widgets.add(
        new Row(
          children: <Widget>[
            new Text(
              "Consecutive Landing:",
              style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                mLaunch.launchServiceProvider.consecutiveSuccessfulLandings
                        .toString() ??
                    "",
                maxLines: 1,
                style: textTheme.subhead,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );
      widgets.add(
        new Row(
          children: <Widget>[
            new Text(
              "Failed Landing:",
              style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(
                mLaunch.launchServiceProvider.failedLandings.toString() ?? "",
                maxLines: 1,
                style: textTheme.subhead,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );

      return widgets;
    } else {
      List<Widget> widgets = new List<Widget>();
      return widgets;
    }
  }

  Widget _buildActionButtons() {
    List<Widget> materialButtons = [];

    if (mLaunch.launchServiceProvider.infoURL != null) {
      materialButtons.add(new IconButton(
        icon:Icon(FontAwesomeIcons.desktop),
        onPressed: () {
          launch(mLaunch.launchServiceProvider.infoURL);
        },
        tooltip: "Website",
      ));
    }

    if (mLaunch.launchServiceProvider.wikiURL != null) {
      materialButtons.add(new IconButton(
        icon:Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          launch(mLaunch.launchServiceProvider.wikiURL);
        },
        tooltip: "Wikipedia",
      ));
    }

    return new Padding(
      padding: const EdgeInsets.all(0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: materialButtons,
      ),
    );
  }
}
