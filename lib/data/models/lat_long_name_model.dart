import 'package:latlong2/latlong.dart';

class LatLongNameModel {
  late LatLng latlng;
  late String name;
  late num radiusKm;
  late num sizeKB;

  LatLongNameModel(
      {required this.latlng,
      required this.name,
      required this.radiusKm,
      required this.sizeKB});

  LatLongNameModel.fromJson(Map<String, dynamic> json) {
    // Assuming the coordinates are directly nested inside the 'latlng' key
    var coordinates = json['latlng']['coordinates'];
    latlng = LatLng(coordinates[1], coordinates[0]);
    name = json['name'];
    radiusKm = json['radiusKm'];
    sizeKB = json['sizeKB'];
  }

  Map<String, dynamic> toJson() {
    return {
      'latlng': {
        'coordinates': [latlng.longitude, latlng.latitude]
      },
      'name': name,
      'radiusKm': radiusKm,
      'sizeKB': sizeKB
    };
  }
}
