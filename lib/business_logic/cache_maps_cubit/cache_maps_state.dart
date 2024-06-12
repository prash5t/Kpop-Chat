import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

abstract class CacheMapsState {}

class InitialState extends CacheMapsState {}

class CachingState extends CacheMapsState {
  final DownloadProgress? downloadProgress;

  final LatLng cachingLocation;
  CachingState(this.cachingLocation, {required this.downloadProgress});
}

class CacheSuccesState extends CacheMapsState {}

class CacheFailureState extends CacheMapsState {
  final String msg;

  CacheFailureState({required this.msg});
}
