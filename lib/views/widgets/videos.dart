import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/vidurls.dart';
import 'package:spacelaunchnow_flutter/util/url_helper.dart';


Widget buildVideos(

    List<VidURL> videos, BuildContext context) {

  var placeholder = "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/static/home/img/placeholder.jpg";

  if (videos.isNotEmpty && videos.length > 1) {
    List<Widget> widgets = <Widget>[];
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 0.0),
        child: Text(
          "Live Coverage",
          textAlign: TextAlign.left,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
    );
    List<VidURL> newVideos = [];
    if (videos.length >= 10) {
      newVideos = videos.sublist(0, 5);
    } else {
      newVideos = videos;
    }

    for (VidURL video in newVideos) {
      widgets.add(Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            onTap: () => openUrl(video.url!),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(video.featureImage ?? placeholder),
            ),
            title: Text(
                video.title!,
                style: Theme.of(context).textTheme.titleSmall),
          )));
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
