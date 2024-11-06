// {
//   "name": "Store Name",
//   "phone_number": "+61412345678",
//   "address": "85 King Georges Rd, Wiley Park NSW 2195",
//   "detailed_address": {
//       "street_address_1": "85 King Georges Rd",
//       "street_address_2": "",
//       "city": "Wiley Park",
//       "state": "",
//       "zip_code": "2195",
//       "country": "AU"
//   },
//   "notes": "",
//   "location": {
//       "lat": -33.93567,
//       "lng": 151.04146
//   }
// }

import 'dart:convert';

import 'address.dart';
import 'lat_lng.dart';

class LocationEntity {
  final String name;
  final String phoneNumber;
  final String address;
  final AddressEntity detailedAddress;
  final String notes;
  final LatLngEntity location;

  LocationEntity({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.detailedAddress,
    required this.notes,
    required this.location,
  });

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      name: json[_Json.name] as String,
      phoneNumber: json[_Json.phoneNumber] as String,
      address: json[_Json.address] as String,
      detailedAddress: AddressEntity.fromJson(json[_Json.detailedAddress]),
      notes: json[_Json.notes] as String,
      location: LatLngEntity.fromJson(json[_Json.location]),
    );
  }

  factory LocationEntity.fromRawJson(String str) =>
      LocationEntity.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      _Json.name: name,
      _Json.phoneNumber: phoneNumber,
      _Json.address: address,
      _Json.detailedAddress: detailedAddress.toJson(),
      _Json.notes: notes,
      _Json.location: location.toJson(),
    };
  }

  String toRawJson() => json.encode(toJson());

  @override
  String toString() => toRawJson();
}

class _Json {
  static const String name = 'name';
  static const String phoneNumber = 'phone_number';
  static const String address = 'address';
  static const String detailedAddress = 'detailed_address';
  static const String notes = 'notes';
  static const String location = 'location';
}
