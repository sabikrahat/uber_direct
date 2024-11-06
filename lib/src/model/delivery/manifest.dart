// {
//   "description": "1 X Bow tie\n",
//   "total_value": 1000
// }

import 'dart:convert';

class ManifestEntity {
  final String description;
  final double totalValue;

  ManifestEntity({
    required this.description,
    required this.totalValue,
  });

  factory ManifestEntity.fromJson(Map<String, dynamic> json) {
    return ManifestEntity(
      description: json[_Json.description] as String,
      totalValue: (json[_Json.totalValue] as num).toDouble(),
    );
  }

  factory ManifestEntity.fromRawJson(String str) =>
      ManifestEntity.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      _Json.description: description,
      _Json.totalValue: totalValue,
    };
  }
}

class _Json {
  static const String description = 'description';
  static const String totalValue = 'total_value';
}
