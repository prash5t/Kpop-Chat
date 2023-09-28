class LatLong {
  double? lat;
  double? long;
  LatLong({this.lat, this.long});

  static const String kLat = "lat";
  static const String kLong = "long";

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
}
