import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';

class LaunchListPage extends StatefulWidget {
  @override
  _LaunchListPageState createState() => new _LaunchListPageState();
}

class _LaunchListPageState extends State<LaunchListPage> {
  List<Launch> _launches = [];

  @override
  void initState() {
    super.initState();
    _loadLaunch();
  }

  Future<void> _loadLaunch() async {
    http.Response response =
    await http.get('https://launchlibrary.net/1.4/launch/next/100');

    setState(() {
      _launches = Launch.allFromResponse(response.body);
    });
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
          return new LaunchDetailPage(launch: launch, avatarTag: avatarTag,);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_launches.isEmpty) {
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
      appBar: new AppBar(title: new Text('Home')),
      body: content,
    );
  }
}