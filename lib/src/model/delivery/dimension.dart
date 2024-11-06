// {
//   "length": 20,
//   "height": 20,
//   "depth": 20
// }

class DimensionEntity {
  final int length;
  final int height;
  final int depth;

  DimensionEntity({
    required this.length,
    required this.height,
    required this.depth,
  });

  factory DimensionEntity.fromJson(Map<String, dynamic> json) {
    return DimensionEntity(
      length: (json[_Json.length] as num).toInt(),
      height: (json[_Json.height] as num).toInt(),
      depth: (json[_Json.depth] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _Json.length: length,
      _Json.height: height,
      _Json.depth: depth,
    };
  }
}

class _Json {
  static const String length = 'length';
  static const String height = 'height';
  static const String depth = 'depth';
}
