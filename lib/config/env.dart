import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied()
abstract class Secret {
  /// Holds the LL_API_KEY.
  @EnviedField(varName: 'LL_API_KEY')
  static const String ll_api_key = _Secret.ll_api_key;
}