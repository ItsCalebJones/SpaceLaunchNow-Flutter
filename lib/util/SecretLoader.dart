import 'dart:async' show Future;
import 'dart:convert' show json;

import 'package:flutter/services.dart' show rootBundle;
import 'package:spacelaunchnow_flutter/util/Secret.dart';

class SecretLoader {
  final String? secretPath;

  SecretLoader({this.secretPath});
  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(secretPath!,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
