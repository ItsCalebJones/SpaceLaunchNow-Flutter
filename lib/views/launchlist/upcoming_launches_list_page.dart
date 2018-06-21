import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';
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
  List<Launch> _launches = [];
  int count = 0;
  int total = 0;
  int offset = 0;
  bool loading = false;
  bool searchActive = false;
  LaunchesRepository _repository = new Injector().launchRepository;

  @override
  void initState() {
    super.initState();
    List<Launch> launches = PageStorage.of(context).readState(context, identifier: 'upcomingLaunches');
    if (launches != null){
      _launches = launches;
    } else {
      lockedLoadNext();
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  void onLoadLaunchesComplete(Launches launches, [bool reload = false]) {
    loading = false;
    count = launches.count;
    total = launches.total;
    offset = launches.offset;
    print("Count: " + count.toString() + " Total: " + total.toString() + " Offset: " + offset.toString());
    if (reload){
      _launches.clear();
    }
    setState(() {
      _launches.addAll(launches.launches);
      PageStorage.of(context).writeState(context, _launches, identifier: 'upcomingLaunches');
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
            onRefresh();
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

    if (index + count > _launches.length) {
      notifyThreshold();
    }


    return new Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: new ListTile(
        onTap: () => _navigateToLaunchDetails(launch: launch, avatarTag: index),
        leading: new Hero(
          tag: index,
          child: new CircleAvatar(
            backgroundImage: new NetworkImage(launch.rocket.imageURL),
          ),
        ),
        title: new Text(launch.name, style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 15.0)),
        subtitle: new Text(launch.location.name),
        trailing: new Text(formatter.format(launch.net), style: Theme.of(context).textTheme.caption),
      ),
    );
  }

  void _navigateToLaunchDetails({Launch launch, Object avatarTag, int launchId}) {
    Ads.hideBannerAd();
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LaunchDetailPage(widget._configuration, launch: launch, avatarTag: avatarTag, launchId: launchId,);
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
    } else if ( _launches.isEmpty) {
      content = new Center(
          child: new Text("No Launches Loaded"),
      );
    } else {
      ListView listView = new ListView.builder(
        itemCount: _launches.length,
        itemBuilder: _buildLaunchListTile,
      );

      content = new RefreshIndicator(
          onRefresh: onRefresh,
          child: listView
      );
    }

    return new Scaffold(
      appBar: new PlatformAdaptiveAppBar(
          color: Theme.of(context).primaryColor,
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
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
          name: 'material_search',
          isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<Launch>(
              placeholder: 'Search',
              results: _launches.map((Launch v) => new MaterialSearchResult<Launch>(
                icon: Icons.launch,
                value: v,
                text: v.name,
              )).toList(),
              filter: (dynamic value, String criteria) {
                return value.name.toLowerCase().trim()
                    .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) => Navigator.of(context).pop(value.id.toString()),
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
          if (value is String){
            if (isNumeric(value)){
              _navigateToLaunchDetails(launchId: int.parse(value));
            } else {
              searchActive = true;
              _getLaunchBySearch(value);
            }
          } else if (value == Launch) {
              _navigateToLaunchDetails(launch: value);
          }
//      setState(() => Launch_name = value as Launch);
    });
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void notifyThreshold() {
    if (!searchActive) {
      lockedLoadNext();
    }
  }

  void lockedLoadNext() {
    if (loading == false) {
      loadNext();
      }
    }

  void loadNext() {
    loading = true;
    int newOffset = (offset + count);
    if (total == 0 || newOffset < total) {
      _repository.fetchUpcoming(offset: newOffset.toString())
          .then((launches) => onLoadLaunchesComplete(launches))
          .catchError((onError) {
        print(onError);
        onLoadContactsError();
      });
    }
  }

  Future<Null> onRefresh() async {
    final Completer<Null> completer = new Completer<Null>();
    loading == false;
    total = 0;
    offset = 0;
    count = 0;
    print("Going to fetch");
    searchActive = false;
    if (total != 0 || offset > total) {
      print("$total, $offset, $total");
      completer.complete(null);
      return completer.future;
    } else {
      loading = true;
      _repository.fetchUpcoming(offset: offset.toString())
          .then((launches) {
        print("Loaded successfully.");
        onLoadLaunchesComplete(launches, true);
        completer.complete(null);
        return completer.future;
      })
          .catchError((onError) {
        print("Failed!");
        print(onError);
        onLoadContactsError();
        completer.complete(null);
        return completer.future;
      });
    }
  }

  void _getLaunchBySearch(String value) {
    loading = true;
    searchActive = true;
    _repository.fetchUpcoming(search: value).then((launches){
      onLoadLaunchesComplete(launches, true);
    }).catchError((onError){
      onLoadContactsError(true);
    });
  }
}