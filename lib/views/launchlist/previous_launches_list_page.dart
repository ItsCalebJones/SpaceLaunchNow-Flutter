import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:spacelaunchnow_flutter/colors/app_theme.dart';
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launch_list.dart';
import 'package:spacelaunchnow_flutter/models/launch/list/launches_list.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/util/date_formatter.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_page.dart';
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';
import 'package:spacelaunchnow_flutter/views/widgets/ads/ad_widget.dart';

class PreviousLaunchListPage extends StatefulWidget {
  const PreviousLaunchListPage(
      this._configuration, this.searchQuery, this.searchActive, {super.key});

  final AppConfiguration _configuration;
  final String? searchQuery;
  final bool searchActive;

  @override
  State<PreviousLaunchListPage> createState() => _LaunchListPageState();
}

class _LaunchListPageState extends State<PreviousLaunchListPage> {
  List<LaunchList> _launches = [];
  int? nextOffset = 0;
  int? totalCount = 0;
  int offset = 0;
  int limit = 30;
  bool loading = false;
  final SLNRepository _repository = Injector().slnRepository;
  ListAdWidget? _bannerAdWidget;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    List<LaunchList>? launches = PageStorage.of(context)
        .readState(context, identifier: 'previousLaunches');
    if (launches != null) {
      _launches = launches;
      nextOffset = PageStorage.of(context)
          .readState(context, identifier: 'previousLaunchesNextOffset');
      totalCount = PageStorage.of(context)
          .readState(context, identifier: 'previousLaunchesNextTotalCount');
    }

    if (widget.searchActive) {
      _getLaunchBySearch(widget.searchQuery);
    } else if (launches != null) {
      _launches = launches;
      nextOffset = PageStorage.of(context)
          .readState(context, identifier: 'previousLaunchesNextOffset');
      totalCount = PageStorage.of(context)
          .readState(context, identifier: 'previousLaunchesNextTotalCount');
    } else {
      lockedLoadNext();
    }
    _bannerAdWidget = const ListAdWidget(AdSize.largeBanner);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(PreviousLaunchListPage oldWidget) {
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
    logger.d(
        "Next: $nextOffset Total: $totalCount");
    if (reload) {
      _launches.clear();
    }
    setState(() {
      _launches.addAll(launches.launches!);
      PageStorage.of(context)
          .writeState(context, _launches, identifier: 'previousLaunches');
      PageStorage.of(context).writeState(context, nextOffset,
          identifier: 'previousLaunchesNextOffset');
      PageStorage.of(context).writeState(context, totalCount,
          identifier: 'previousLaunchesNextTotalCount');
    });
  }

  void onLoadContactsError([bool? search]) {
    logger.d("Error occurred");
    loading = false;
    if (search == true) {
      setState(() {
        _launches.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 10),
        content: const Text('Unable to load launches matching search.'),
        action: SnackBarAction(
          label: 'Refresh',
          onPressed: () {
            // Some code to undo the change!
            _handleRefresh();
          },
        ),
      ));
    }
  }

  ThemeData get appBarTheme {
    if (widget._configuration.nightMode) {
      return kIOSThemeDark;
    } else {
      return kIOSTheme;
    }
  }

  Widget _buildLaunchListTile(BuildContext context, int index) {
    var launch = _launches[index];
    var formatter = DateFormat.yMd();

    if (index > _launches.length - 10) {
      notifyThreshold();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: ListTile(
        onTap: () => _navigateToLaunchDetails(
            launch: null, avatarTag: index, launchId: launch.id),
        leading: Hero(
          tag: index,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(launch.image!),
          ),
        ),
        title: Text(launch.name!,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontSize: 15.0)),
        subtitle: Text(launch.location!),
        trailing: Text(PrecisionFormattedDate.getShortPrecisionFormattedDate(launch.netPrecision?.id ?? 0, launch.net!),
            style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  void _navigateToLaunchDetails(
      {LaunchList? launch, Object? avatarTag, String? launchId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) {
          return LaunchDetailPage(
            widget._configuration,
            launch: null,
            avatarTag: avatarTag,
            launchId: launchId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_launches.isEmpty && loading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_launches.isEmpty) {
      content = const Center(
        child: Text("No Launches Loaded"),
      );
    } else {
      ListView listView = ListView.builder(
        itemCount: _launches.length,
        itemBuilder: _buildLaunchListTile,
      );

      content =
          RefreshIndicator(onRefresh: _handleRefresh, child: listView);
    }

    return content;
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
      _repository
          .fetchPrevious(limit: limit.toString(), offset: nextOffset.toString())
          .then((launches) => onLoadLaunchesComplete(launches))
          .catchError((onError) {
        logger.d(onError);
        onLoadContactsError();
      });
    }
  }

  Future<void> _handleRefresh() async {
    _launches.clear();
    loading == false;
    totalCount = 0;
    offset = 0;
    nextOffset = 0;
    loading = true;
    LaunchesList responseLaunches = await _repository
        .fetchPrevious(limit: limit.toString(), offset: nextOffset.toString())
        .catchError((onError) {
      onLoadContactsError();
    });
    onLoadLaunchesComplete(responseLaunches);
  }

  void _getLaunchBySearch(String? value) {
    _launches.clear();
    loading = true;
    totalCount = 0;
    limit = 0;
    nextOffset = 0;
    _repository
        .fetchPrevious(
            limit: limit.toString(),
            offset: nextOffset.toString(),
            search: value)
        .then((launches) {
      onLoadLaunchesComplete(launches, true);
    }).catchError((onError) {
      onLoadContactsError(true);
    });
  }
}
