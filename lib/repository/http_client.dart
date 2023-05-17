import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:spacelaunchnow_flutter/config/env.dart';

class ClientWithUserAgent extends http.BaseClient {
  final http.Client _client;
  final bool useSLNAuth;

  ClientWithUserAgent(this._client, {this.useSLNAuth = false});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var token = Secret.ll_api_key;
    var logger = Logger();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    logger.d("useSLNAuth: $useSLNAuth | SpaceLaunchNow-Flutter-${packageInfo.version}");
    request.headers['User-Agent'] = 'SpaceLaunchNow-Flutter-${packageInfo.version}';

    if (useSLNAuth) {
      request.headers['Authorization'] = 'Token $token';
    }

    logger.d(request.headers);
    return _client.send(request);
  }
}
