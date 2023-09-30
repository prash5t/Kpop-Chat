class UserInfoFromIPModel {
  String? status;
  String? country;
  String? countryCode;
  String? phoneCode;
  String? region;
  String? regionName;
  String? city;
  String? zip;
  double? lat;
  double? lon;
  String? timezone;
  String? isp;
  String? org;
  String? as;
  String? query;

  UserInfoFromIPModel(
      {this.status,
      this.country,
      this.countryCode,
      this.region,
      this.regionName,
      this.city,
      this.zip,
      this.lat,
      this.lon,
      this.timezone,
      this.isp,
      this.org,
      this.as,
      this.query});

  UserInfoFromIPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    country = json['country'];
    countryCode = json['countryCode'];
    phoneCode = json['phoneCode'];
    region = json['region'];
    regionName = json['regionName'];
    city = json['city'];
    zip = json['zip'];
    lat = json['lat'];
    lon = json['lon'];
    timezone = json['timezone'];
    isp = json['isp'];
    org = json['org'];
    as = json['as'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['country'] = country;
    data['countryCode'] = countryCode;
    data['phoneCode'] = phoneCode;
    data['region'] = region;
    data['regionName'] = regionName;
    data['city'] = city;
    data['zip'] = zip;
    data['lat'] = lat;
    data['lon'] = lon;
    data['timezone'] = timezone;
    data['isp'] = isp;
    data['org'] = org;
    data['as'] = as;
    data['query'] = query;
    return data;
  }
}
