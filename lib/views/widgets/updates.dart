import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:spacelaunchnow_flutter/models/update.dart';

Widget buildUpdates(
    List<Update> updates, BuildContext context, String rootSlug) {
  var formatter = new DateFormat.MMMEd().add_jm();
  if (updates.isNotEmpty) {
    List<Widget> widgets = new List<Widget>();
    widgets.add(
      new Text(
        "Status Updates",
        textAlign: TextAlign.left,
        style: Theme.of(context)
            .textTheme
            .headline1!
            .copyWith(fontWeight: FontWeight.bold, fontSize: 26),
      ),
    );
    List<Update> _updates = [];
    if (updates.length >= 6) {
      _updates = updates.sublist(0, 5);
    } else {
      _updates = updates;
    }
    for (Update update in _updates) {
      var comment = update.comment;
      if (update.infoUrl != null) {
        comment += "\n\nSource:\n" + update.infoUrl!;
      }
      widgets.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
              child: new ListTile(
            onTap: () => _openUrl(update.infoUrl!),
            leading: new CircleAvatar(
              backgroundImage:
                  new CachedNetworkImageProvider(update.profileImage!),
            ),
            title: new Text(
                update.createdBy! + " - " + formatter.format(update.createdOn!),
                style: Theme.of(context).textTheme.subtitle2),
            subtitle:
                new Text(comment!, style: Theme.of(context).textTheme.caption),
          ))));
    }
    if (updates.length >= 6) {
      widgets.add(
        Center(
          child: new CupertinoButton(
              color: Theme.of(context).accentColor,
              child: Text("Read More"),
              onPressed: () {
                _openUrl(rootSlug);
              }),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgets,
      ),
    );
  } else {
    return new SizedBox(height: 0);
  }
}

_openUrl(String url) async {
  Uri? _url = Uri.tryParse(url);
  if (_url != null && _url.host.contains("youtube.com") && Platform.isIOS) {
    final String _finalUrl = _url.host + _url.path + "?" + _url.query;
    if (await canLaunch('youtube://$_finalUrl')) {
      await launch('youtube://$_finalUrl', forceSafariVC: false);
    }
  } else {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
