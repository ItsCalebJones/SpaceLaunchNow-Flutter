import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/injection/dependency_injection.dart';
import 'package:spacelaunchnow_flutter/models/launch/detailed/launch.dart';
import 'package:spacelaunchnow_flutter/models/news.dart';
import 'package:spacelaunchnow_flutter/repository/http_client.dart';
import 'package:spacelaunchnow_flutter/repository/sln_repository.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/launch_detail_header.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_body.dart';

class ElapsedTime {
  final int? hundreds;
  final int? seconds;
  final int? minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final Stopwatch stopwatch = Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
}

class LaunchDetailPage extends StatefulWidget {
  const LaunchDetailPage({super.key, this.launch, this.launchId, this.avatarTag});


  final Launch? launch;
  final String? launchId;
  final Object? avatarTag;

  @override
  State<LaunchDetailPage> createState() => _LaunchDetailsPageState();
}

class _LaunchDetailsPageState extends State<LaunchDetailPage>
    with TickerProviderStateMixin {
  final List<News> _news = [];
  late AnimationController _controller;
  Launch? launch;
  bool? backEnabled;
  Timer? timer;
  final int timerMillisecondsRefreshRate = 100;
  final Stopwatch stopwatch = Stopwatch();
  final SLNRepository _repository = Injector().slnRepository;

  @override
  void initState() {
    super.initState();
    if (widget.launch != null) {
      launch = widget.launch;
      setController();
      backEnabled = true;
    } else if (widget.launchId != null) {
      _loadLaunch(widget.launchId);
      backEnabled = true;
    } else {
      Launch? mLaunch = PageStorage.of(context)
          .readState(context, identifier: 'next_launch');
      if (mLaunch != null) {
        launch = mLaunch;
        setController();
      } else {
        _loadNextLaunch();
      }
      backEnabled = false;
    }
    if (launch != null) {
      _loadNews(launch!.id);
    }
    timer = Timer.periodic(
        Duration(milliseconds: timerMillisecondsRefreshRate), callback);
  }

  void callback(Timer timer) {}

  Future<void> _loadLaunch(String? id) async {
    setState(() {
      launch = null;
    });
    final client = ClientWithUserAgent(http.Client(), useSLNAuth: true);
    http.Response response = await client.get(Uri.parse(
        'https://spacelaunchnow.me/api/ll/2.2.0/launch/$id/?mode=detailed'));

    setState(() {
      launch = Launch.fromResponse(response);
      if (launch != null) {
        _loadNews(launch!.id);
      }
      setController();
    });
  }

  Future<void> _loadNextLaunch() async {
    List<Launch>? nextLaunches;
    final client = ClientWithUserAgent(http.Client(), useSLNAuth: true);
    http.Response response = await client.get(Uri.parse(
        'https://spacelaunchnow.me/api/ll/2.2.0/launch/upcoming/?limit=1&mode=detailed'));
    nextLaunches = Launch.allFromResponse(response);
    setState(() {
      PageStorage.of(context).writeState(context, nextLaunches!.first, identifier: 'next_launch');
      launch = nextLaunches.first;
      _loadNews(launch!.id);
      setController();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (launch == null) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      content = Scaffold(
        body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LaunchDetailHeader(
              launch,
              loadLaunch: _loadLaunch,
              avatarTag: widget.avatarTag,
              backEnabled: backEnabled,
            ),
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (constraints.maxWidth < 600) {
                    return _buildBody();
                  }

              return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: _buildBody(),
                  ),
              );
            }),
          ],
        ),
      )
      );
    }
    return content;
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 48.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LaunchDetailBodyWidget(launch: launch, _news),
      ),
    );
  }

  void setController() {
    var until = launch!.net!.difference(DateTime.now());
    if (until.inSeconds > 0) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: until.inSeconds),
      );
      _controller.forward();
    }
  }

  void _loadNews(String? id) async {
    List<News> response = await _repository.fetchNewsByLaunch(id: id);
    onLoadResponseComplete(response);
  }

  void onLoadResponseComplete(List<News> response, [bool reload = false]) {
    if (reload) {
      _news.clear();
    }
    setState(() {
      _news.addAll(response);
    });
  }
}
