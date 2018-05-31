import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/repository/launches_repository.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

class UpcomingLaunchListPage extends StatefulWidget {

  UpcomingLaunchListPage(this._configuration);

  final AppConfiguration _configuration;

  @override
  _LaunchListPageState createState() => new _LaunchListPageState();
}

class _LaunchListPageState extends State<UpcomingLaunchListPage> {
  List<Launch> _launches = [];
  LaunchesRepository _repository = new Injector().launchRepository;

  @override
  void initState() {
    super.initState();
  }

  void onLoadLaunchesComplete(List<Launch> items) {
    PageStorage.of(context).writeState(context, items, identifier: 'launches');
    setState(() {
      _launches = items;
    });
  }

  void onLoadLaunchersError() {
    // TODO: implement onLoadContactsError
  }

  Widget _buildLaunchListTile(BuildContext context, int index) {
    var launch = _launches[index];

    return new ListTile(
      onTap: () => _navigateToLaunchDetails(launch, index),
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(launch.rocket.imageURL),
        ),
      ),
      title: new Text(launch.name),
      subtitle: new Text(launch.location.name),
    );
  }

  void _navigateToLaunchDetails(Launch launch, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(widget._configuration, launch: launch, avatarTag: avatarTag,);
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    Widget content;

    List<Launch> launches = PageStorage.of(context).readState(context, identifier: 'launches');
    if (launches != null){
     _launches = launches;
    }
    if (_launches.isEmpty) {
      _repository.fetch()
          .then((contacts) => onLoadLaunchesComplete(contacts))
          .catchError((onError) {
        print(onError);
        onLoadLaunchersError();
      });
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = new ListView.builder(
        itemCount: _launches.length,
        itemBuilder: _buildLaunchListTile,
      );
    }

    return new Scaffold(
      appBar: new PlatformAdaptiveAppBar(
        text: "Upcoming",
        platform: Theme.of(context).platform,
      ),
      body: content
    );
  }
}