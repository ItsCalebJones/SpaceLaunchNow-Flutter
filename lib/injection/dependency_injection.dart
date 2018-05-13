
import 'package:spacelaunchnow_flutter/repository/launches_repository_impl.dart';
import 'package:spacelaunchnow_flutter/repository/launches_repository.dart';

/// Simple DI
class Injector {

  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  LaunchesRepository get launchRepository {
        return new LaunchesRepositoryImpl();
  }
}
