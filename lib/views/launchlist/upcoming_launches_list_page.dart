import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch_list.dart';
import 'package:spacelaunchnow_flutter/models/launches_list.dart';
import 'package:spacelaunchnow_flutter/repository/launches_repository.dart';
import 'package:spacelaunchnow_flutter/util/ads.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:material_search/material_search.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

class UpcomingLaunchListPage extends StatefulWidget {
  UpcomingLaunchListPage(this._configuration);

  final AppConfiguration _configuration;

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
  bool searchActive = false;
  LaunchesRepository _repository = new Injector().launchRepository;

  @override
  void initState() {
    super.initState();
    List<LaunchList> launches = PageStorage.of(context).readState(
        context, identifier: 'upcomingLaunches');
    if (launches != null) {
      _launches = launches;
    } else {
      lockedLoadNext();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
    var formatter = new DateFormat('MMM yyyy');

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
            backgroundImage: new NetworkImage(launch.image),
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
      {LaunchList launch, Object avatarTag, int launchId}) {
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

    return new Scaffold(
      appBar: new PlatformAdaptiveAppBar(
        color: Theme
            .of(context)
            .primaryColor,
        text: "Upcoming",
        platform: appBarTheme.platform,
        actions: <Widget>[
          new IconButton(
            onPressed: () {
              _showMaterialSearch(context);
            },
            tooltip: 'Search',
            icon: new Icon(Icons.search),
          )
        ],
      ),
      body: content,
    );
  }

  _buildMaterialSearchPage(BuildContext context) {
    var backgroundColor;
    if (widget._configuration.nightMode) {
      backgroundColor = Colors.black26;
    } else {
      backgroundColor = Colors.white;
    }
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
          name: 'material_search',
          isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<LaunchList>(
              barBackgroundColor: backgroundColor,
              placeholder: 'Search',
              results: _launches.map((LaunchList v) =>
              new MaterialSearchResult<LaunchList>(
                icon: Icons.launch,
                value: v,
                text: v.name,
              )).toList(),
              filter: (dynamic value, String criteria) {
                return value.name.toLowerCase().trim()
                    .contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) =>
                  Navigator.of(context).pop(value.id.toString()),
              onSubmit: (String value) => Navigator.of(context).pop(value),
            ),
          );
        }
    );
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      if (value is String) {
        if (isNumeric(value)) {
          _navigateToLaunchDetails(launchId: int.parse(value));
        } else {
          searchActive = true;
          _getLaunchBySearch(value);
        }
      } else if (value == LaunchList) {
        _navigateToLaunchDetails(launch: value);
      }
//      setState(() => Launch_name = value as Launch);
    });
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
    searchActive = false;
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
    searchActive = true;
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