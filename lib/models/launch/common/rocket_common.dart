import 'launcher_configuration_common.dart';

class RocketCommon {
  final int? id;
  final LauncherConfigurationCommon? configuration;

  RocketCommon({this.id, this.configuration});

  factory RocketCommon.fromJson(Map<String, dynamic> json) {
    return RocketCommon(
      id: json['id'],
      configuration:
          LauncherConfigurationCommon.fromJson(json['configuration']),
    );
  }
}
