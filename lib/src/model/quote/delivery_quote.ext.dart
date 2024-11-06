part of 'delivery_quote.dart';

extension DeliveryQuoteExtension on DeliveryQuote {
  DeliveryQuote copyWith({
    String? kind,
    String? id,
    DateTime? created,
    DateTime? expires,
    double? fee,
    String? currency,
    String? currencyType,
    DateTime? dropoffEta,
    int? duration,
    int? pickupDuration,
    DateTime? dropoffDeadline,
  }) {
    return DeliveryQuote(
      kind: kind ?? this.kind,
      id: id ?? this.id,
      created: created ?? this.created,
      expires: expires ?? this.expires,
      fee: fee ?? this.fee,
      currency: currency ?? this.currency,
      currencyType: currencyType ?? this.currencyType,
      dropoffEta: dropoffEta ?? this.dropoffEta,
      duration: duration ?? this.duration,
      pickupDuration: pickupDuration ?? this.pickupDuration,
      dropoffDeadline: dropoffDeadline ?? this.dropoffDeadline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _Json.kind: kind,
      _Json.id: id,
      _Json.created: created.toIso8601String(),
      _Json.expires: expires.toIso8601String(),
      _Json.fee: fee,
      _Json.currency: currency,
      _Json.currencyType: currencyType,
      _Json.dropoffEta: dropoffEta.toIso8601String(),
      _Json.duration: duration,
      _Json.pickupDuration: pickupDuration,
      _Json.dropoffDeadline: dropoffDeadline.toIso8601String(),
    };
  }

  String toRawJson() => json.encode(toJson());
}