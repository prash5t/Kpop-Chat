import 'package:location/location.dart';

class LatLong {
  double? lat;
  double? long;
  LatLong({this.lat, this.long});

  static const String kLat = "latitude";
  static const String kLong = "longitude";

  LatLong.fromJson(Map<String, dynamic> json) {
    lat = json[kLat];
    long = json[kLong];
  }

  Map<String, dynamic> toJson() {
    return {
      kLat: lat,
      kLong: long,
    };
  }

  LocationData toLocationData() {
    return LocationData.fromMap(toJson());
  }
}

/// Usable in Friends Map Screen with value notifier when there is need to zoom on user's location
class LatLongAndZoom {
  LatLong? latLong;
  double? zoom;
  LatLongAndZoom({this.latLong, this.zoom});
}
