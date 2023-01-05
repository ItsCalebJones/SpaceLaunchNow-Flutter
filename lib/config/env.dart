import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify(name: 'Secret')
abstract class Secret {
  /// Holds the TWITTER_CONSUMER_KEY.
  static const twitter_consumer_key = _Secret.twitter_consumer_key;

  /// Holds the TWITTER_CONSUMER_SECRET.
  static const twitter_consumer_secret = _Secret.twitter_consumer_secret;

  /// Holds the TWITTER_ACCESS_TOKEN.
  static const twitter_access_token = _Secret.twitter_access_token;

  /// Holds the TWITTER_ACCESS_TOKEN_SECRET.
  static const twitter_access_token_secret = _Secret.twitter_access_token_secret;

  /// Holds the LL_API_KEY.
  static const ll_api_key = _Secret.ll_api_key;
}