class UberErrorResponse {
  final String message;
  final String code;
  final List<UberError>? errors;

  UberErrorResponse({
    required this.message,
    required this.code,
    this.errors,
  });

  factory UberErrorResponse.fromJson(Map<String, dynamic> json) {
    return UberErrorResponse(
      message: json['message'] as String,
      code: json['code'] as String,
      errors: json['errors'] != null
          ? (json['errors'] as List)
              .map((e) => UberError.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class UberError {
  final String code;
  final String message;
  final String? field;
  final dynamic value;

  UberError({
    required this.code,
    required this.message,
    this.field,
    this.value,
  });

  factory UberError.fromJson(Map<String, dynamic> json) {
    return UberError(
      code: json['code'] as String,
      message: json['message'] as String,
      field: json['field'] as String?,
      value: json['value'],
    );
  }

  @override
  String toString() => 'Field: $field, Code: $code, Message: $message';
}

abstract class UberException implements Exception {
  final String message;

  UberException(this.message);

  @override
  String toString() => message;
}

class UberAuthException extends UberException {
  UberAuthException(super.message);
}

class UberApiException extends UberException {
  final int statusCode;
  final String code;
  final List<UberError>? errors;

  UberApiException({
    required this.statusCode,
    required String message,
    required this.code,
    this.errors,
  }) : super(message);

  @override
  String toString() {
    final buffer = StringBuffer('UberApiException: [$statusCode] $message');
    if (errors != null && errors!.isNotEmpty) {
      buffer.writeln('\nDetailed errors:');
      for (final error in errors!) {
        buffer.writeln('- ${error.toString()}');
      }
    }
    return buffer.toString();
  }
}
