import 'dart:convert';

import '../quote/enum.dart';
import 'location.dart';
import 'manifest.dart';
import 'manifest_item.dart';

class DeliveryEntity {
  final String id;
  final String quoteId;
  final String status;
  final bool complete;
  final String kind;
  final LocationEntity pickup;
  final LocationEntity dropoff;
  final ManifestEntity manifest;
  final List<ManifestItem> manifestItems;
  final DateTime created;
  final DateTime updated;
  final DateTime pickupReady;
  final DateTime pickupDeadline;
  final DateTime dropoffReady;
  final DateTime dropoffDeadline;
  final DateTime pickupEta;
  final DateTime dropoffEta;
  final double fee;
  final String currency;
  final String trackingUrl;
  final String undeliverableAction;
  final bool courierImminent;
  final dynamic courier;
  final bool liveMode;
  final String undeliverableReason;
  final String uuid;
  final dynamic fences;
  final String externalId;
  final dynamic itemsAcquired;
  final dynamic stateChanges;
  final DeliverableAction deliverableAction;
  final LocationEntity? returnLocation;
  final dynamic refunds;

  DeliveryEntity({
    required this.id,
    required this.quoteId,
    required this.status,
    required this.complete,
    required this.kind,
    required this.pickup,
    required this.dropoff,
    required this.manifest,
    required this.manifestItems,
    required this.created,
    required this.updated,
    required this.pickupReady,
    required this.pickupDeadline,
    required this.dropoffReady,
    required this.dropoffDeadline,
    required this.pickupEta,
    required this.dropoffEta,
    required this.fee,
    required this.currency,
    required this.trackingUrl,
    required this.undeliverableAction,
    required this.courierImminent,
    required this.courier,
    required this.liveMode,
    required this.undeliverableReason,
    required this.uuid,
    required this.fences,
    required this.externalId,
    required this.itemsAcquired,
    required this.stateChanges,
    required this.deliverableAction,
    this.returnLocation,
    this.refunds,
  });

  factory DeliveryEntity.fromJson(Map<String, dynamic> json) {
    return DeliveryEntity(
      id: json[_Json.id] as String,
      quoteId: json[_Json.quoteId] as String,
      status: json[_Json.status] as String,
      complete: json[_Json.complete] as bool,
      kind: json[_Json.kind] as String,
      pickup:
          LocationEntity.fromJson(json[_Json.pickup] as Map<String, dynamic>),
      dropoff:
          LocationEntity.fromJson(json[_Json.dropoff] as Map<String, dynamic>),
      manifest:
          ManifestEntity.fromJson(json[_Json.manifest] as Map<String, dynamic>),
      manifestItems: (json[_Json.manifestItems] as List)
          .map((e) => ManifestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      created: DateTime.parse(json[_Json.created] as String).toLocal(),
      updated: DateTime.parse(json[_Json.updated] as String).toLocal(),
      pickupReady: DateTime.parse(json[_Json.pickupReady] as String).toLocal(),
      pickupDeadline:
          DateTime.parse(json[_Json.pickupDeadline] as String).toLocal(),
      dropoffReady:
          DateTime.parse(json[_Json.dropoffReady] as String).toLocal(),
      dropoffDeadline:
          DateTime.parse(json[_Json.dropoffDeadline] as String).toLocal(),
      pickupEta: DateTime.parse(json[_Json.pickupEta] as String).toLocal(),
      dropoffEta: DateTime.parse(json[_Json.dropoffEta] as String).toLocal(),
      fee: (json[_Json.fee] as num).toDouble(),
      currency: json[_Json.currency] as String,
      trackingUrl: json[_Json.trackingUrl] as String,
      undeliverableAction: json[_Json.undeliverableAction] as String,
      courierImminent: json[_Json.courierImminent] as bool,
      courier: json[_Json.courier],
      liveMode: json[_Json.liveMode] as bool,
      undeliverableReason: json[_Json.undeliverableReason] as String,
      uuid: json[_Json.uuid] as String,
      fences: json[_Json.fences],
      externalId: json[_Json.externalId] as String,
      itemsAcquired: json[_Json.itemsAcquired],
      stateChanges: json[_Json.stateChanges],
      deliverableAction: (json[_Json.deliverableAction] as String).toDeliverableAction,
      returnLocation: json[_Json.returnLocation] == null
          ? null
          : LocationEntity.fromJson(json[_Json.returnLocation]),
      refunds: json[_Json.refunds],
    );
  }

  factory DeliveryEntity.fromRawJson(String str) =>
      DeliveryEntity.fromJson(json.decode(str));

  Map<String, dynamic> toJson() {
    return {
      _Json.id: id,
      _Json.quoteId: quoteId,
      _Json.status: status,
      _Json.complete: complete,
      _Json.kind: kind,
      _Json.pickup: pickup.toJson(),
      _Json.dropoff: dropoff.toJson(),
      _Json.manifest: manifest.toJson(),
      _Json.manifestItems: manifestItems.map((e) => e.toJson()).toList(),
      _Json.created: created.toIso8601String(),
      _Json.updated: updated.toIso8601String(),
      _Json.pickupReady: pickupReady.toIso8601String(),
      _Json.pickupDeadline: pickupDeadline.toIso8601String(),
      _Json.dropoffReady: dropoffReady.toIso8601String(),
      _Json.dropoffDeadline: dropoffDeadline.toIso8601String(),
      _Json.pickupEta: pickupEta.toIso8601String(),
      _Json.dropoffEta: dropoffEta.toIso8601String(),
      _Json.fee: fee,
      _Json.currency: currency,
      _Json.trackingUrl: trackingUrl,
      _Json.undeliverableAction: undeliverableAction,
      _Json.courierImminent: courierImminent,
      _Json.courier: courier,
      _Json.liveMode: liveMode,
      _Json.undeliverableReason: undeliverableReason,
      _Json.uuid: uuid,
      _Json.fences: fences,
      _Json.externalId: externalId,
      _Json.itemsAcquired: itemsAcquired,
      _Json.stateChanges: stateChanges,
      _Json.deliverableAction: deliverableAction.name,
      _Json.returnLocation: returnLocation?.toJson(),
      _Json.refunds: refunds,
    };
  }

  String toRawJson() => json.encode(toJson());

  @override
  String toString() => toRawJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DeliveryEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _Json {
  static const String id = 'id';
  static const String quoteId = 'quote_id';
  static const String status = 'status';
  static const String complete = 'complete';
  static const String kind = 'kind';
  static const String pickup = 'pickup';
  static const String dropoff = 'dropoff';
  static const String manifest = 'manifest';
  static const String manifestItems = 'manifest_items';
  static const String created = 'created';
  static const String updated = 'updated';
  static const String pickupReady = 'pickup_ready';
  static const String pickupDeadline = 'pickup_deadline';
  static const String dropoffReady = 'dropoff_ready';
  static const String dropoffDeadline = 'dropoff_deadline';
  static const String pickupEta = 'pickup_eta';
  static const String dropoffEta = 'dropoff_eta';
  static const String fee = 'fee';
  static const String currency = 'currency';
  static const String trackingUrl = 'tracking_url';
  static const String undeliverableAction = 'undeliverable_action';
  static const String courierImminent = 'courier_imminent';
  static const String courier = 'courier';
  static const String liveMode = 'live_mode';
  static const String undeliverableReason = 'undeliverable_reason';
  static const String uuid = 'uuid';
  static const String fences = 'fences';
  static const String externalId = 'external_id';
  static const String itemsAcquired = 'items_acquired';
  static const String stateChanges = 'state_changes';
  static const String deliverableAction = 'deliverable_action';
  static const String returnLocation = 'return';
  static const String refunds = 'refunds';
}
