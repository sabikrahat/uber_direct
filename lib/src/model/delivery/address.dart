// {
//   "street_address_1": "85 King Georges Rd",
//   "street_address_2": "",
//   "city": "Wiley Park",
//   "state": "",
//   "zip_code": "2195",
//   "country": "AU"
// }

import 'dart:convert';

class AddressEntity {
  final String streetAddress1;
  final String streetAddress2;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  AddressEntity({
    required this.streetAddress1,
    required this.streetAddress2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory AddressEntity.fromJson(Map<String, dynamic> json) {
    return AddressEntity(
      streetAddress1: json[_Json.streetAddress1] as String,
      streetAddress2: json[_Json.streetAddress2] as String,
      city: json[_Json.city] as String,
      state: json[_Json.state] as String,
      zipCode: json[_Json.zipCode] as String,
      country: json[_Json.country] as String,
    );
  }

  factory AddressEntity.fromRawJson(String str) =>
      AddressEntity.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      _Json.streetAddress1: streetAddress1,
      _Json.streetAddress2: streetAddress2,
      _Json.city: city,
      _Json.state: state,
      _Json.zipCode: zipCode,
      _Json.country: country,
    };
  }

  String toRawJson() => json.encode(toJson());

  @override
  String toString() => toRawJson();
}

class _Json {
  static const String streetAddress1 = 'street_address_1';
  static const String streetAddress2 = 'street_address_2';
  static const String city = 'city';
  static const String state = 'state';
  static const String zipCode = 'zip_code';
  static const String country = 'country';
}
