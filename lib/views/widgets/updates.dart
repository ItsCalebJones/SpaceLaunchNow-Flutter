import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/models/update.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';


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
    List<Update> updates = [];
    if (updates.length >= 6) {
      updates = updates.sublist(0, 5);
    } else {
      updates = updates;
    }
    for (Update update in updates) {
      var comment = update.comment ?? "N/A";
      if (update.infoUrl != null) {
        comment += "\n\nSource:\n${update.infoUrl!}";
      }
      widgets.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            onTap: () => openUrl(update.infoUrl!),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(update.profileImage!),
            ),
            title: Text(
                "${update.createdBy!} - ${formatter.format(update.createdOn!)}",
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
                openUrl(rootSlug);
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
