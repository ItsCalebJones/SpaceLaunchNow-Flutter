import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/models/rocket/launcher.dart';

import '../update.dart';
import 'launch_event_list.dart';
import 'live_stream.dart';
import 'notice.dart';
import 'road_closure.dart';

class Starship {
  final LaunchEventList? upcoming;
  final LaunchEventList? previous;
  final List<LiveStream>? liveStream;
  final List<RoadClosure>? roadClosures;
  final List<Update>? updates;
  final List<Notice>? notices;
  final List<Launcher>? launchers;

  Starship(
      {this.upcoming,
      this.previous,
      this.liveStream,
      this.roadClosures,
      this.notices,
      this.updates,
      this.launchers});

  factory Starship.fromJson(Map<String, dynamic> json) {
    var logger = Logger();

    LaunchEventList upcoming = LaunchEventList.fromJson(json['upcoming']);
    LaunchEventList previous = LaunchEventList.fromJson(json['upcoming']);
    List<LiveStream> liveStreams = List<LiveStream>.from(
        json['live_streams'].map((stream) => LiveStream.fromJson(stream)));

    List<RoadClosure> roadClosures = List<RoadClosure>.from(
        json['road_closures'].map((stream) => RoadClosure.fromJson(stream)));

    List<Notice> notices = List<Notice>.from(
        json['notices'].map((stream) => Notice.fromJson(stream)));

    List<Launcher> vehicles = List<Launcher>.from(
        json['vehicles'].map((stream) => Launcher.fromJson(stream)));

    List<Update> updates = List<Update>.from(
        json['updates'].map((stream) => Update.fromJson(stream)));

    logger.d("Made it here.");

    return Starship(
      upcoming: upcoming,
      previous: previous,
      liveStream: liveStreams,
      roadClosures: roadClosures,
      notices: notices,
      launchers: vehicles,
      updates: updates,
    );
  }
}
