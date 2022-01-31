import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/models/update.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildUpdates(
    List<Update> updates, BuildContext context, String rootSlug) {
  var formatter = DateFormat.MMMEd().add_jm();
  if (updates.isNotEmpty) {
    List<Widget> widgets = <Widget>[];
    widgets.add(
      Text(
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
      var comment = update.comment ?? "N/A";
      if (update.infoUrl != null) {
        comment += "\n\nSource:\n" + update.infoUrl!;
      }
      widgets.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            onTap: () => _openUrl(update.infoUrl!),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(update.profileImage!),
            ),
            title: Text(
                update.createdBy! + " - " + formatter.format(update.createdOn!),
                style: Theme.of(context).textTheme.subtitle2),
            subtitle: Text(comment, style: Theme.of(context).textTheme.caption),
          )));
    }
    if (updates.length >= 6) {
      widgets.add(
        Center(
          child: CupertinoButton(
              color: Theme.of(context).colorScheme.secondary,
              child: const Text("Read More"),
              onPressed: () {
                _openUrl(rootSlug);
              }),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgets,
      ),
    );
  } else {
    return const SizedBox(height: 0);
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
