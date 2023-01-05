import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'package:spacelaunchnow_flutter/config/env.dart';

class ClientWithUserAgent extends http.BaseClient {
  final http.Client _client;
  final bool useSLNAuth = false;

  ClientWithUserAgent(this._client, {useSLNAuth = false});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var token = Secret.ll_api_key;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (useSLNAuth) {
      request.headers['User-Agent'] =
          'SpaceLaunchNow-Flutter-${packageInfo.version}';
      request.headers['Authorization'] = 'Token $token';
    }
    return _client.send(request);
  }
}
