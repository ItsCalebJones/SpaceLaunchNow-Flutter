import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify(name: 'Secret')
abstract class Secret {
  /// Holds the LL_API_KEY.
  static const ll_api_key = _Secret.ll_api_key;
}