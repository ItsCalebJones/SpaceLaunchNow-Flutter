import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/footer/launch_detail_footer.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/header/launch_detail_header.dart';
import 'package:spacelaunchnow_flutter/views/launchdetails/launch_detail_body.dart';

class LaunchDetailPage extends StatefulWidget {

  LaunchDetailPage(
      this.launch, {
        @required this.avatarTag,
      });

  final Launch launch;
  final Object avatarTag;

  @override
  _LaunchDetailsPageState createState() => new _LaunchDetailsPageState();
}

class _LaunchDetailsPageState extends State<LaunchDetailPage> with TickerProviderStateMixin {
  AnimationController _controller;


  @override
  void initState() {
    super.initState();
    var until = widget.launch.net.difference(new DateTime.now());
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: until.inSeconds),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {

    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          const Color(0xFF2196F3),
          const Color(0xFFF44336),
        ],
      ),
    );

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new LaunchDetailHeader(
                widget.launch,
                _controller,
                widget.launch.net.difference(new DateTime.now()).inSeconds,
                avatarTag: widget.avatarTag,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new LaunchDetailBody(widget.launch),
              ),
              new LaunchShowcase(widget.launch),
            ],
          ),
        ),
      ),
    );
  }
}
