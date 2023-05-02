import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

openUrl(String url) async {
  Uri? uri = Uri.tryParse(url);
  if (uri != null && uri.host.contains("youtube.com") && Platform.isIOS) {
    var youtubeUri = Uri.parse("youtube://${uri.host}${uri.path}?${uri.query}");
    if (await canLaunchUrl(youtubeUri)) {
      await launchUrl(youtubeUri);
    }
  } else {
    if (await canLaunchUrl(uri!)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}