import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/launches.dart';
import 'package:spacelaunchnow_flutter/views/launchlist/launches_list_page.dart';

Future<Launches> fetchLaunches() async {
  final response =
      await http.get('https://launchlibrary.net/1.4/launch/next/100');
  final responseJson = json.decode(response.body);

  return new Launches.fromJson(responseJson);
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Space Launch Now',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        accentColor: Colors.redAccent,
      ),
      home: new LaunchListPage(),
    );
  }
}
