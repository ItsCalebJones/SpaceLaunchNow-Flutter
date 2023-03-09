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
import 'package:spacelaunchnow_flutter/views/settings/app_settings.dart';

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
  const LaunchDetailPage(this._configuration,
      {Key? key, this.launch, this.launchId, this.avatarTag}) : super(key: key);

  final AppConfiguration _configuration;
  final Launch? launch;
  final String? launchId;
  final Object? avatarTag;

  @override
  _LaunchDetailsPageState createState() => _LaunchDetailsPageState();
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
      Launch? mLaunch = PageStorage.of(context)!
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
    PageStorage.of(context)!
        .writeState(context, nextLaunches!.first, identifier: 'next_launch');
    setState(() {
      launch = nextLaunches!.first;
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
    List<Color> colors = [];
    if (!widget._configuration.nightMode) {
      colors.addAll([Colors.blue[700]!, Colors.blueGrey[400]!]);
    } else {
      colors.addAll([Colors.grey[800]!, Colors.blueGrey[700]!]);
    }
    var linearGradient = BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: colors,
      ),
    );

    if (launch == null) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      content = Scaffold(body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LaunchDetailHeader(
                  launch,
                  loadLaunch: _loadLaunch,
                  avatarTag: widget.avatarTag,
                  backEnabled: backEnabled,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: LaunchDetailBodyWidget(
                      launch, widget._configuration, _news),
                ),
              ],
            ),
          ),
        );
      }));
    }
    return content;
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
    List<News> response =
        await _repository.fetchNewsByLaunch(id: id).catchError((onError) {});
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
