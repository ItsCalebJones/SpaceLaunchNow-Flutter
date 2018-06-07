import 'dart:async';

export 'camera_position.dart';
export 'location.dart';
export 'marker.dart';
export 'static_map_provider.dart';
export 'toolbar_action.dart';
export 'map_view_type.dart';
export 'camera_position.dart';
export 'map_options.dart';
export 'locations.dart';

import 'package:flutter/services.dart';
import 'camera_position.dart';
import 'location.dart';
import 'map_options.dart';
import 'marker.dart';
import 'toolbar_action.dart';

class MapView {
  MethodChannel _channel = const MethodChannel("com.apptreesoftware.map_view");
  StreamController<Marker> _annotationStreamController =
      new StreamController.broadcast();
  StreamController<Location> _locationChangeStreamController =
      new StreamController.broadcast();
  StreamController<Location> _mapInteractionStreamController =
      new StreamController.broadcast();
  StreamController<CameraPosition> _cameraStreamController =
      new StreamController.broadcast();
  StreamController<int> _toolbarActionStreamController =
      new StreamController.broadcast();
  StreamController<Null> _mapReadyStreamController =
      new StreamController.broadcast();
  StreamController<Marker> _infoWindowStreamController =
      new StreamController.broadcast();

  Map<String, Marker> _annotations = {};

  MapView() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static bool _apiKeySet = false;

  static void setApiKey(String apiKey) {
    MethodChannel c = const MethodChannel("com.apptreesoftware.map_view");
    c.invokeMethod('setApiKey', apiKey);
    _apiKeySet = true;
  }

  void show(MapOptions mapOptions, {List<ToolbarAction> toolbarActions}) {
    if (!_apiKeySet) {
      throw "API Key must be set before calling `show`. Use MapView.setApiKey";
    }
    List<Map> actions = [];
    if (toolbarActions != null) {
      actions = toolbarActions.map((t) => t.toMap).toList();
    }
    _channel.invokeMethod(
        'show', {"mapOptions": mapOptions.toMap(), "actions": actions});
  }

  void dismiss() {
    _annotations.clear();
    _channel.invokeMethod('dismiss');
  }

  List<Marker> get markers => _annotations.values.toList(growable: false);

  void setMarkers(List<Marker> annotations) {
    _annotations.clear();
    annotations.forEach((a) => _annotations[a.id] = a);
    _channel.invokeMethod('setAnnotations',
        annotations.map((a) => a.toMap()).toList(growable: false));
  }

  void addMarker(Marker marker) {
    if (_annotations.containsKey(marker.id)) {
      return;
    }
    _annotations[marker.id] = marker;
    _channel.invokeMethod('addAnnotation', marker.toMap());
  }

  void removeMarker(Marker marker) {
    if (!_annotations.containsKey(marker.id)) {
      return;
    }
    _annotations.remove(marker.id);
    _channel.invokeMethod('removeAnnotation', marker.toMap());
  }

  void zoomToFit({int padding: 50}) {
    _channel.invokeMethod('zoomToFit', padding);
  }

  void zoomTo(List<String> annotationIds, {double padding: 50.0}) {
    _channel.invokeMethod('zoomToAnnotations',
        {"annotations": annotationIds, "padding": padding});
  }

  void setCameraPosition(double latitude, double longitude, double zoom) {
    _channel.invokeMethod("setCamera",
        {"latitude": latitude, "longitude": longitude, "zoom": zoom});
  }

  Future<Location> get centerLocation async {
    Map locationMap = await _channel.invokeMethod("getCenter");
    return new Location(locationMap["latitude"], locationMap["longitude"]);
  }

  Future<double> get zoomLevel async {
    return await _channel.invokeMethod("getZoomLevel");
  }

  Future<List<Marker>> get visibleAnnotations async {
    List<String> ids = await _channel.invokeMethod("getVisibleMarkers");
    var annotations = <Marker>[];
    for (var id in ids) {
      var annotation = _annotations[id];
      annotations.add(annotation);
    }
    return annotations;
  }

  Stream<Marker> get onTouchAnnotation => _annotationStreamController.stream;

  Stream<Location> get onLocationUpdated =>
      _locationChangeStreamController.stream;

  Stream<Location> get onMapTapped => _mapInteractionStreamController.stream;

  Stream<CameraPosition> get onCameraChanged => _cameraStreamController.stream;

  Stream<int> get onToolbarAction => _toolbarActionStreamController.stream;

  Stream<Null> get onMapReady => _mapReadyStreamController.stream;

  Stream<Marker> get onInfoWindowTapped => _infoWindowStreamController.stream;

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onMapReady":
        _mapReadyStreamController.add(null);
        return new Future.value("");
      case "locationUpdated":
        Map args = call.arguments;
        _locationChangeStreamController.add(new Location.fromMap(args));
        return new Future.value("");
      case "annotationTapped":
        String id = call.arguments;
        var annotation = _annotations[id];
        if (annotation != null) {
          _annotationStreamController.add(annotation);
        }
        return new Future.value("");
      case "infoWindowTapped":
        String id = call.arguments;
        var annotation = _annotations[id];
        if (annotation != null) {
          _infoWindowStreamController.add(annotation);
        }
        return new Future.value("");
      case "mapTapped":
        Map locationMap = call.arguments;
        Location location = new Location.fromMap(locationMap);
        _mapInteractionStreamController.add(location);
        return new Future.value("");
      case "cameraPositionChanged":
        _cameraStreamController.add(new CameraPosition.fromMap(call.arguments));
        return new Future.value("");
      case "onToolbarAction":
        _toolbarActionStreamController.add(call.arguments);
        break;
    }
    return new Future.value("");
  }
}
