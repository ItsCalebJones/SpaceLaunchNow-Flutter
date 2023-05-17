import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spacelaunchnow_flutter/models/agency.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';

class AgenciesShowcase extends StatelessWidget {
  const AgenciesShowcase(this.mLaunch, {Key? key}) : super(key: key);

  final Launch? mLaunch;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    Agency? lsp = mLaunch!.launchServiceProvider;
    String? lspName = "Unknown";
    String? lspAdmin = "Unknown Administrator";
    String lspFounded = "Founded: Unknown";
    String? lspDescription = "";

    if (lsp != null) {
      String? lspFoundedYear = lsp.foundingYear;
      if (lspFoundedYear != null) {
        lspFounded = "Founded: ${lsp.foundingYear!}";
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

    Widget? buildStats(TextTheme theme) {
      if (lsp != null &&
          lsp.successfulLaunches != null &&
          lsp.failedLaunches != null &&
          lsp.pendingLaunches != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "$lspName Stats",
                style:
                    textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Successful:",
                            style: textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              lsp.successfulLaunches.toString(),
                              maxLines: 1,
                              style: textTheme.subtitle1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Pending:",
                            style: textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              lsp.pendingLaunches.toString(),
                              maxLines: 1,
                              style: textTheme.subtitle1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Failed:",
                            style: textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              lsp.failedLaunches.toString(),
                              maxLines: 1,
                              style: textTheme.subtitle1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
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

    Widget buildAvatar() {
      String? url =
          "https://spacelaunchnow-prod-east.nyc3.cdn.digitaloceanspaces.com/static/home/img/placeholder_agency.jpg";
      if (lsp!.nationURL != null && lsp.nationURL!.isNotEmpty) {
        url = lsp.nationURL;
      } else if (lsp.imageURL != null && lsp.imageURL!.isNotEmpty) {
        url = lsp.imageURL;
      }

      return Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 4.0, top: 8.0, bottom: 4.0),
              child: Container(
                width: 125.0,
                height: 125.0,
                padding: const EdgeInsets.all(2.0),
                // border width
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor, // border color
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  backgroundImage: NetworkImage(url!),
                  radius: 50.0,
                  backgroundColor: Colors.white,
                ),
              )),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    lspAdmin!,
                    style: textTheme.subtitle1!.copyWith(),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    lspFounded,
                    style: textTheme.subtitle1!.copyWith(),
                    textAlign: TextAlign.left,
                  ),
                ),
                _buildActionButtons(),
              ],
            ),
          )
        ],
      );
    }

    Widget buildLSP() {
      List<Widget> lspWidgets = [];
      if (lsp != null) {
      } else {
        lspWidgets.add(Text(
          "Unknown",
          style: textTheme.subtitle1!.copyWith(),
          textAlign: TextAlign.left,
        ));
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Text(
              "Launch Agency",
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              lspName!,
              style: textTheme.headline6,
            ),
          ),
          buildAvatar(),
          const Padding(
            padding: EdgeInsets.all(4.0),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
            child: Text(
              lspDescription!,
              style: textTheme.bodyText1!.copyWith(),
              textAlign: TextAlign.start,
            ),
          ),
          Column(children: lspWidgets),
          buildStats(textTheme)!,
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[buildLSP()],
      ),
    );
  }

  List<Widget> _buildLandingWidgets(TextTheme textTheme) {
    if (mLaunch!.launchServiceProvider != null &&
        mLaunch!.launchServiceProvider!.attemptedLandings! > 0) {
      List<Widget> widgets = <Widget>[];
      widgets.add(
        Row(
          children: <Widget>[
            Text(
              "Attempted Landing:",
              style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                mLaunch!.launchServiceProvider!.attemptedLandings.toString(),
                maxLines: 1,
                style: textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );
      widgets.add(
        Row(
          children: <Widget>[
            Text(
              "Successful Landing:",
              style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                mLaunch!.launchServiceProvider!.successfulLandings.toString(),
                maxLines: 1,
                style: textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );
      widgets.add(
        Row(
          children: <Widget>[
            Text(
              "Consecutive Landing:",
              style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                mLaunch!.launchServiceProvider!.consecutiveSuccessfulLandings
                    .toString(),
                maxLines: 1,
                style: textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );
      widgets.add(
        Row(
          children: <Widget>[
            Text(
              "Failed Landing:",
              style: textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                mLaunch!.launchServiceProvider!.failedLandings.toString(),
                maxLines: 1,
                style: textTheme.subtitle1,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      );

      return widgets;
    } else {
      List<Widget> widgets = <Widget>[];
      return widgets;
    }
  }

  Widget _buildActionButtons() {
    List<Widget> materialButtons = [];

    if (mLaunch!.launchServiceProvider!.infoURL != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.desktop),
        onPressed: () {
          openUrl(mLaunch!.launchServiceProvider!.infoURL!);
        },
        tooltip: "Website",
      ));
    }

    if (mLaunch!.launchServiceProvider!.wikiURL != null) {
      materialButtons.add(IconButton(
        icon: const Icon(FontAwesomeIcons.wikipediaW),
        onPressed: () {
          openUrl(mLaunch!.launchServiceProvider!.wikiURL!);
        },
        tooltip: "Wikipedia",
      ));
    }

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: materialButtons,
      ),
    );
  }
}
