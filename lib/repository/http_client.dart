import 'dart:convert';

import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:yaml/yaml.dart';

class ClientWithUserAgent extends http.BaseClient {

  final http.Client _client;
  final bool useSLNAuth = false;

  ClientWithUserAgent(this._client, {useSLNAuth: false});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    String data = await rootBundle.loadString("config.yaml");
    Map config = loadYaml(data)['token'];
    var token = config['token'];
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (useSLNAuth) {
      request.headers['User-Agent'] =
          'SpaceLaunchNow-Flutter-' + packageInfo.version;
      request.headers['Authorization'] = 'Token ' + token;
    }
    return _client.send(request);
  }


}