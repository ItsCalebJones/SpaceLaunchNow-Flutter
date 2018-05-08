import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spacelaunchnow_flutter/models/launch.dart';
import 'package:spacelaunchnow_flutter/models/launches.dart';

Future<Launches> fetchLaunches() async {
  final response =
      await http.get('https://launchlibrary.net/1.4/launch/next/2');
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
      ),
      home: new MyHomePage(title: 'Space Launch Now - Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(widget.title),
        ),
        body: new Container(
          child: new Center(
            // Use future builder and DefaultAssetBundle to load the local JSON file
            child: new FutureBuilder(
                future: fetchLaunches(),
                builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("GOT DATA");
                      List<Launch> launches = snapshot.data.launches;
                      return new ListView.builder(
                        // Build the ListView
                        itemBuilder: (BuildContext context, int index) {
                          Launch launch = launches[index];
                          return _buildLaunchCard(launch);
                        },
                        itemCount: launches.length,
                      );
                    } else {
                      return new Card(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Text("Connecting"),
                          ],
                        ),
                      );
                    }
                }),
          ),
        ));
  }
}

Widget _buildLaunchCard(Launch launch) {
  return GestureDetector(
//    onTap: () {
//      showProductDetails(context, product);
//    },
    child: Row(children: [
      Container(
        height: 64.0,
        width: 64.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Image.network(launch.rocket.imageURL),
      ),
      Expanded(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Flexible(
            child: Text(
              launch.name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 8.0),
        child: Text(
          launch.id.toString(),
          textAlign: TextAlign.end,
        ),
      ),
    ]),
  );
}
