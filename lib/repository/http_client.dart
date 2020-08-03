import 'dart:convert';

import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

class ClientWithUserAgent extends http.BaseClient {

  final http.Client _client;

  ClientWithUserAgent(this._client);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    request.headers['User-Agent'] = 'SpaceLaunchNow-Flutter-' + packageInfo.version;
    return _client.send(request);
  }


}