import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch_list.dart';
import 'package:spacelaunchnow_flutter/models/launches_list.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:material_search/material_search.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

class UpcomingLaunchListPage extends StatefulWidget {
  UpcomingLaunchListPage(this._configuration, this.searchQuery, this.searchActive);

  final AppConfiguration _configuration;
  final String searchQuery;
  final bool searchActive;

  @override
  _LaunchListPageState createState() => new _LaunchListPageState();
}

class _LaunchListPageState extends State<UpcomingLaunchListPage> {
  List<LaunchList> _launches = [];
  int nextOffset = 0;
  int totalCount = 0;
  int offset = 0;
  int limit = 30;
  bool loading = false;
  SLNRepository _repository = new Injector().slnRepository;


  @override
  void initState() {
    super.initState();
    print("Initing state of Upcoming!");

    List<LaunchList> launches = PageStorage.of(context).readState(
        context, identifier: 'upcomingLaunches');
    if (launches != null) {
      _launches = launches;
      nextOffset = PageStorage.of(context).readState(
          context, identifier: 'upcomingLaunchesNextOffset');
      totalCount = PageStorage.of(context).readState(
          context, identifier: 'upcomingLaunchesnextTotalCount');
    }

    if (widget.searchActive){
      _getLaunchBySearch(widget.searchQuery);
    } else if (launches != null) {
      _launches = launches;
      nextOffset = PageStorage.of(context).readState(
          context, identifier: 'upcomingLaunchesNextOffset');
      totalCount = PageStorage.of(context).readState(
          context, identifier: 'upcomingLaunchesnextTotalCount');
    } else {
      lockedLoadNext();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(UpcomingLaunchListPage oldWidget) {
    if (oldWidget.searchActive != widget.searchActive ||
        oldWidget.searchQuery != widget.searchQuery) {
      // values changed, restart animation.
      setState(() {
        if (widget.searchActive) {
          _getLaunchBySearch(widget.searchQuery);
        } else {
          _handleRefresh();
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void onLoadLaunchesComplete(LaunchesList launches, [bool reload = false]) {
    loading = false;
    nextOffset = launches.nextOffset;
    totalCount = launches.count;
    print(
        "Next: " + nextOffset.toString() + " Total: " + totalCount.toString());
    if (reload) {
      _launches.clear();
    }
    setState(() {
      _launches.addAll(launches.launches);
      PageStorage.of(context).writeState(
          context, _launches, identifier: 'upcomingLaunches');
      PageStorage.of(context).writeState(
          context, nextOffset, identifier: 'upcomingLaunchesNextOffset');
      PageStorage.of(context).writeState(
          context, totalCount, identifier: 'upcomingLaunchesnextTotalCount');
    });
  }


  void onLoadContactsError([bool search]) {
    print("Error occured");
    loading = false;
    if (search == true) {
      setState(() {
        _launches.clear();
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: new Duration(seconds: 10),
        content: new Text('Unable to load launches matching search.'),
        action: new SnackBarAction(
          label: 'Refresh',
          onPressed: () {
            // Some code to undo the change!
            _handleRefresh();
          },
        ),
      )
      );
    }
  }

  ThemeData get appBarTheme {
    if (widget._configuration.nightMode) {
      return kIOSThemeDarkAppBar;
    } else {
      return kIOSThemeAppBar;
    }
  }

  Widget _buildLaunchListTile(BuildContext context, int index) {
    var launch = _launches[index];
    var formatter = new DateFormat.yMd();

    if (index > _launches.length - 10) {
      notifyThreshold();
    }


    return new Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: new ListTile(
        onTap: () => _navigateToLaunchDetails(launch: null, avatarTag: index, launchId: launch.id),
        leading: new Hero(
          tag: index,
          child: new CircleAvatar(
            backgroundImage: new CachedNetworkImageProvider(launch.image),
          ),
        ),
        title: new Text(launch.name, style: Theme
            .of(context)
            .textTheme
            .subhead
            .copyWith(fontSize: 15.0)),
        subtitle: new Text(launch.location),
        trailing: new Text(formatter.format(launch.net), style: Theme
            .of(context)
            .textTheme
            .caption),
      ),
    );
  }

  void _navigateToLaunchDetails(
      {LaunchList launch, Object avatarTag, String launchId}) {
    Ads.hideBannerAd();
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(widget._configuration, launch: null,
            avatarTag: avatarTag,
            launchId: launchId,);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    print("Upcoming build!");

    if (_launches.isEmpty && loading) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else if (_launches.isEmpty) {
      content = new Center(
        child: new Text("No Launches Loaded"),
      );
    } else {
      ListView listView = new ListView.builder(
        itemCount: _launches.length,
        itemBuilder: _buildLaunchListTile,
      );

      content = new RefreshIndicator(
          onRefresh: _handleRefresh,
          child: listView
      );
    }

    return content;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void notifyThreshold() {
    lockedLoadNext();
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadNext();
    }
  }

  void loadNext() {
    loading = true;
    if (totalCount == 0 || nextOffset != null) {
      _repository.fetchUpcoming(
          limit: limit.toString(), offset: nextOffset.toString())
          .then((launches) => onLoadLaunchesComplete(launches))
          .catchError((onError) {
        print(onError);
        onLoadContactsError();
      });
    }
  }

  Future<Null> _handleRefresh() async {
    _launches.clear();
    loading == false;
    totalCount = 0;
    limit = 0;
    nextOffset = 0;
    loading = true;
    LaunchesList responseLaunches = await _repository.fetchUpcoming(
        limit: limit.toString(),
        offset: nextOffset.toString())
        .catchError((onError) {
      onLoadContactsError();
    });
    onLoadLaunchesComplete(responseLaunches);
    return null;
  }

  void _getLaunchBySearch(String value) {
    _launches.clear();
    loading = true;
    totalCount = 0;
    limit = 0;
    nextOffset = 0;
    _repository.fetchUpcoming(limit: limit.toString(),
        offset: nextOffset.toString(),
        search: value).then((launches) {
      onLoadLaunchesComplete(launches, true);
    }).catchError((onError) {
      onLoadContactsError(true);
    });
  }
}