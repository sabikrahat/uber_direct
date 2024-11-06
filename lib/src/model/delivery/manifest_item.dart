// {
//   "name": "Bow tie",
//   "quantity": 1,
//   "size": "small",
//   "price": 100,
//   "dimensions": {
//       "length": 20,
//       "height": 20,
//       "depth": 20
//   },
//   "must_be_upright": false,
//   "weight": 300
// }

import 'dart:convert';

import 'dimension.dart';

class ManifestItem {
  final String name;
  final int quantity;
  final String size;
  final int price;
  final DimensionEntity dimensions;
  bool? mustBeUpright;
  final int weight;
  int? vatPercentage;

  ManifestItem({
    required this.name,
    required this.quantity,
    required this.size,
    required this.price,
    required this.dimensions,
    this.mustBeUpright,
    required this.weight,
    this.vatPercentage,
  });

  factory ManifestItem.fromJson(Map<String, dynamic> json) {
    return ManifestItem(
      name: json[_Json.name] as String,
      quantity: json[_Json.quantity] as int,
      size: json[_Json.size] as String,
      price: (json[_Json.price] as num).toInt(),
      dimensions: DimensionEntity.fromJson(
          json[_Json.dimensions] as Map<String, dynamic>),
      mustBeUpright: json[_Json.mustBeUpright] as bool?,
      weight: (json[_Json.weight] as num).toInt(),
      vatPercentage: json[_Json.vatPercentage] as int?,
    );
  }

  factory ManifestItem.fromRawJson(String str) =>
      ManifestItem.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      _Json.name: name,
      _Json.quantity: quantity,
      _Json.size: size,
      _Json.price: price,
      _Json.dimensions: dimensions.toJson(),
      _Json.mustBeUpright: mustBeUpright,
      _Json.weight: weight,
      _Json.vatPercentage: vatPercentage,
    }..removeWhere((_, v) => v == null);
  }

  String toRawJson() => json.encode(toJson());

  @override
  String toString() => toRawJson();
}

class _Json {
  static const String name = 'name';
  static const String quantity = 'quantity';
  static const String size = 'size';
  static const String price = 'price';
  static const String dimensions = 'dimensions';
  static const String mustBeUpright = 'must_be_upright';
  static const String weight = 'weight';
  static const String vatPercentage = 'vat_percentage';
}
