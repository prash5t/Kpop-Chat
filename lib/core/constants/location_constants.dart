import 'package:kpopchat/data/models/lat_long_model.dart';
import 'package:latlong2/latlong.dart';

class LocationConstants {
  /// assign its value on app launch (service locator)
  static LatLong? userLocationFromIP;

  static double latOfAreaToFetch = 26.643190;
  static double lonOfAreaToFetch = 87.991882;
  static double radiusOfAreaToFetch = 1;

  static LatLng areaToProgramitcallyCache =
      LatLng(latOfAreaToFetch, lonOfAreaToFetch);
}
