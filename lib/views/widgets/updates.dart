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
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 0.0),
        child: Text(
          "Status Updates",
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
    );
    List<Update> newUpdates = [];
    if (updates.length >= 6) {
      newUpdates = updates.sublist(0, 5);
    } else {
      newUpdates = updates;
    }
    for (Update update in newUpdates) {
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
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Text(comment, style: Theme.of(context).textTheme.bodySmall),
          )));
    }
    if (newUpdates.length >= 6) {
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
