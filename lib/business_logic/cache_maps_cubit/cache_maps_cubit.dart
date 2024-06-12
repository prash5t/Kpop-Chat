import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kpopchat/business_logic/fmtc_cubit/fmtc_cubit.dart';
import 'package:kpopchat/core/constants/shared_preferences_keys.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:kpopchat/data/models/lat_long_name_model.dart';
import 'package:kpopchat/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:kpopchat/business_logic/cache_maps_cubit/cache_maps_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheMapsCubit extends Cubit<CacheMapsState> {
  CacheMapsCubit() : super(InitialState());

  Stream<DownloadProgress>? downloadProgress;

  void setDownloadProgress(
    Stream<DownloadProgress>? newStream,
    LatLng areaToCache,
    String name,
    num radiusKm,
  ) {
    downloadProgress = newStream;
    if (newStream != null) {
      newStream.forEach((element) {
        debugPrint(
            "debugProgress: CachedSize: ${element.cachedSize / 1000}, CachedTiles: ${element.cachedTiles}, isComplete: ${element.isComplete}, bufferedSize: ${element.bufferedSize}, totalTiles: ${element.maxTiles}");
        if (element.cachedTiles == element.maxTiles) {
          List<String> cachedLocations = locator<SharedPreferences>()
                  .getStringList(SharedPrefsKeys.kCachedLocations) ??
              [];
          LatLongNameModel area = LatLongNameModel(
              latlng: areaToCache,
              name: name,
              radiusKm: radiusKm,
              sizeKB: element.cachedSize);
          cachedLocations.add(jsonEncode(area.toJson()));
          // FYI: updaing cachedLocationRecord to prevent caching same location next time
          if (!areaIsAlreadyCached(area)) {
            locator<SharedPreferences>().setStringList(
              SharedPrefsKeys.kCachedLocations,
              cachedLocations,
            );
          }
          emit(CacheSuccesState());
        } else {
          emit(CachingState(
            areaToCache,
            downloadProgress: element,
          ));
        }
      });
    }
  }

  void cacheMapViaPlaceName(String areaToCache, double radius) async {
    emit(CachingState(LatLng(0, 0), downloadProgress: null));
    try {
      List<Location> locations = await locationFromAddress(areaToCache);
      if (locations.isNotEmpty) {
        LatLng toCache = LatLng(locations[0].latitude, locations[0].longitude);

        if (!areaIsAlreadyCached(LatLongNameModel(
            sizeKB: 0, radiusKm: radius, latlng: toCache, name: areaToCache))) {
          try {
            FMTCStore? store =
                BlocProvider.of<FmtcCubit>(navigatorKey.currentContext!)
                    .fmtcStore;
            if (store != null) {
              // final metadata = await store.metadata.read;

              setDownloadProgress(
                  store.download.startForeground(
                      parallelThreads: 5,
                      region: CircleRegion(toCache, radius).toDownloadable(
                        minZoom: 2,
                        maxZoom: 18,
                        options: TileLayer(
                          urlTemplate:
                              //  metadata['sourceURL'],
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                      )),
                  toCache,
                  areaToCache,
                  radius);
            } else {
              emit(CacheFailureState(msg: "Caching Server Not Found"));
            }
          } catch (e) {
            emit(CacheFailureState(msg: e.toString()));
          }
        } else {
          emit(CacheSuccesState());
        }
      } else {
        emit(CacheFailureState(msg: "Location not found"));
      }
    } catch (e) {
      emit(CacheFailureState(msg: e.toString()));
    }
  }

  void cacheMapOfSelectedArea(LatLng areaToCache, double radius) async {
    emit(CachingState(areaToCache, downloadProgress: null));
    List<Placemark> placemarks = await placemarkFromCoordinates(
        areaToCache.latitude, areaToCache.longitude);
    if (!areaIsAlreadyCached(LatLongNameModel(
        sizeKB: 0,
        radiusKm: radius,
        latlng: areaToCache,
        name: placemarks.first.name ?? "Unknown Location"))) {
      try {
        FMTCStore? store =
            BlocProvider.of<FmtcCubit>(navigatorKey.currentContext!).fmtcStore;
        if (store != null) {
          // final metadata = await store.metadata.read;

          setDownloadProgress(
              store.download.startForeground(
                  parallelThreads: 5,
                  region: CircleRegion(areaToCache, radius).toDownloadable(
                    minZoom: 2,
                    maxZoom: 18,
                    options: TileLayer(
                      urlTemplate:
                          //  metadata['sourceURL'],
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                  )),
              areaToCache,
              placemarks.first.name ?? "Unknown Location",
              radius);
        } else {
          emit(CacheFailureState(msg: "Caching Server Not Found"));
        }
      } catch (e) {
        emit(CacheFailureState(msg: e.toString()));
      }
    } else {
      emit(CacheSuccesState());
    }
  }

  bool areaIsAlreadyCached(LatLongNameModel areaToCache) {
    bool isAlreadyCached = false;
    List<String> cachedLocations = locator<SharedPreferences>()
            .getStringList(SharedPrefsKeys.kCachedLocations) ??
        [];
    for (String cachedArea in cachedLocations) {
      LatLongNameModel cached =
          LatLongNameModel.fromJson(jsonDecode(cachedArea));
      if ((cached.latlng.latitude == areaToCache.latlng.latitude) &&
          (cached.latlng.longitude == areaToCache.latlng.longitude)) {
        isAlreadyCached = true;
      }
    }
    return isAlreadyCached;
  }
}
