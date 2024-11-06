// {
//   "lat": -33.93567,
//   "lng": 151.04146
// }

import 'dart:convert';

class LatLngEntity {
  final double lat;
  final double lng;

  LatLngEntity({required this.lat, required this.lng});

  factory LatLngEntity.fromJson(Map<String, dynamic> json) {
    return LatLngEntity(
      lat: json[_Json.lat] as double,
      lng: json[_Json.lng] as double,
    );
  }

  factory LatLngEntity.fromRawJson(String str) =>
      LatLngEntity.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      _Json.lat: lat,
      _Json.lng: lng,
    };
  }

  String toRawJson() => json.encode(toJson());

  @override
  String toString() => toRawJson();
}

class _Json {
  static const String lat = 'lat';
  static const String lng = 'lng';
}
