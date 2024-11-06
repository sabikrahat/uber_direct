// {
//     "kind": "delivery_quote",
//     "id": "dqt_wfBSE5ALTYuxtjZ0j6a2cw",
//     "created": "2024-11-03T12:32:30.516Z",
//     "expires": "2024-11-03T12:47:30.516Z",
//     "fee": 1100,
//     "currency": "aud",
//     "currency_type": "AUD",
//     "dropoff_eta": "2024-11-03T19:31:41Z",
//     "duration": 419,
//     "pickup_duration": 364,
//     "dropoff_deadline": "2024-11-03T20:01:41Z"
// }

import 'dart:convert';

part 'delivery_quote.ext.dart';

class DeliveryQuote {
  final String kind;
  final String id;
  final DateTime created;
  final DateTime expires;
  final double fee;
  final String currency;
  final String currencyType;
  final DateTime dropoffEta;
  final int duration;
  final int pickupDuration;
  final DateTime dropoffDeadline;

  DeliveryQuote({
    required this.kind,
    required this.id,
    required this.created,
    required this.expires,
    required this.fee,
    required this.currency,
    required this.currencyType,
    required this.dropoffEta,
    required this.duration,
    required this.pickupDuration,
    required this.dropoffDeadline,
  });

  factory DeliveryQuote.fromJson(Map<String, dynamic> json) {
    return DeliveryQuote(
      kind: json[_Json.kind] as String,
      id: json[_Json.id] as String,
      created: DateTime.parse(json[_Json.created] as String).toLocal(),
      expires: DateTime.parse(json[_Json.expires] as String).toLocal(),
      fee: (json[_Json.fee] as num).toDouble(),
      currency: json[_Json.currency] as String,
      currencyType: json[_Json.currencyType] as String,
      dropoffEta: DateTime.parse(json[_Json.dropoffEta] as String).toLocal(),
      duration: json[_Json.duration] as int,
      pickupDuration: json[_Json.pickupDuration] as int,
      dropoffDeadline:
          DateTime.parse(json[_Json.dropoffDeadline] as String).toLocal(),
    );
  }

  factory DeliveryQuote.fromRawJson(String str) =>
      DeliveryQuote.fromJson(json.decode(str));

  @override
  String toString() => toRawJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeliveryQuote && other.id == id;
  }

  @override
  int get hashCode => kind.hashCode ^ id.hashCode;
}

class _Json {
  static const String kind = 'kind';
  static const String id = 'id';
  static const String created = 'created';
  static const String expires = 'expires';
  static const String fee = 'fee';
  static const String currency = 'currency';
  static const String currencyType = 'currency_type';
  static const String dropoffEta = 'dropoff_eta';
  static const String duration = 'duration';
  static const String pickupDuration = 'pickup_duration';
  static const String dropoffDeadline = 'dropoff_deadline';
}
