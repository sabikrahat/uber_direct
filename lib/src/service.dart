import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'model/quote/enum.dart';

import 'error/error.dart';
import 'model/delivery/delivery.dart';
import 'model/quote/delivery_quote.dart';

class UberDirectClient {
  final String uberClientId;
  final String uberClientSecret;
  final String uberCustomerId;

  String? _accessToken;
  DateTime? _tokenExpiry;
  late http.Client? _client;

  UberDirectClient({
    required this.uberClientId,
    required this.uberClientSecret,
    required this.uberCustomerId,
  }) {
    _client = http.Client();
  }

  static const String _baseUrl = 'https://api.uber.com/v1';
  static const String _authUrl = 'https://login.uber.com/oauth/v2/token';
  final String _proxyUrl = 'https://cors-proxy-smoky-iota.vercel.app/api/proxy';

  bool get _isTokenValid =>
      _accessToken != null &&
      _tokenExpiry != null &&
      _tokenExpiry!.isAfter(DateTime.now().add(const Duration(minutes: 10)));

  Future<String> get _token async =>
      _isTokenValid ? _accessToken! : await _authenticate();

  Future<String> _authenticate() async {
    try {
      final response = await _client!.post(
        Uri.parse('$_proxyUrl?url=$_authUrl'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'client_id': uberClientId,
          'client_secret': uberClientSecret,
          'grant_type': 'client_credentials',
          'scope': 'eats.deliveries direct.organizations',
        },
      );

      if (response.statusCode != 200) {
        throw UberAuthException(
          'Authentication failed: ${response.statusCode} ${response.body}',
        );
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      _accessToken = data['access_token'] as String;
      final expiresIn = data['expires_in'] as int;
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
      return _accessToken!;
    } catch (e) {
      throw UberAuthException('Failed to authenticate: $e');
    }
  }

  Future<DeliveryQuote> createQuote({
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupPhoneNumber,
    required String dropoffAddress,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String dropoffPhoneNumber,
    DateTime? pickupReadyDt,
    DateTime? pickupDeadlineDt,
    DateTime? dropoffReadyDt,
    DateTime? dropoffDeadlineDt,
    int manifestTotalValue = 1000, // in cents
    String externalStoreId = '123456789',
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final token = await _token;
      final response = await _client!.post(
        Uri.parse(
            '$_proxyUrl?url=${Uri.encodeComponent('$_baseUrl/customers/$uberCustomerId/delivery_quotes')}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "pickup_phone_number": pickupPhoneNumber,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "dropoff_phone_number": dropoffPhoneNumber,
          "pickup_ready_dt":
              pickupReadyDt?.toIso8601String() ?? now.toIso8601String(),
          "pickup_deadline_dt": pickupDeadlineDt?.toIso8601String() ??
              now.add(const Duration(hours: 1)).toIso8601String(),
          "dropoff_ready_dt": dropoffReadyDt?.toIso8601String() ??
              now.add(const Duration(hours: 1)).toIso8601String(),
          "dropoff_deadline_dt": dropoffDeadlineDt?.toIso8601String() ??
              now.add(const Duration(minutes: 90)).toIso8601String(),
          "manifest_total_value": manifestTotalValue,
          "external_store_id": externalStoreId,
        }),
      );

      _handleErrorResponse(response);

      return DeliveryQuote.fromRawJson(response.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<DeliveryEntity> createDelivery({
    required String pickupName,
    String? pickupBusinessName,
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupAddress,
    required String pickupPhoneNumber,
    required String dropoffName,
    required double dropoffLatitude,
    required double dropoffLongitude,
    required String dropoffAddress,
    required String dropoffPhoneNumber,
    required String dropoffNotes,
    required String dropoffSellerNotes,
    required List<String> manifestItemNames,
    required List<int> manifestItemQuantities,
    required List<String> manifestItemSizes,
    required List<int> manifestItemLengths,
    required List<int> manifestItemHeights,
    required List<int> manifestItemDepths,
    required List<int> manifestItemPrices,
    required List<int> manifestItemWeights,
    required List<int> manifestItemVatPercentages,
    DeliverableAction deliverableAction =
        DeliverableAction.deliverableActionMeetAtDoor,
    int? manifestTotalValue, // in cents
    int tip = 0,
    String returnNotes =
        'Please contact the store to arrange the return of the order.',
    DateTime? mercentAccountCreated,
    required String merchantAccountEmail,
    String? deviceId,
    String? externalId,
  }) async {
    try {
      if (manifestItemNames.length != manifestItemQuantities.length ||
          manifestItemNames.length != manifestItemSizes.length ||
          manifestItemNames.length != manifestItemLengths.length ||
          manifestItemNames.length != manifestItemHeights.length ||
          manifestItemNames.length != manifestItemDepths.length ||
          manifestItemNames.length != manifestItemPrices.length ||
          manifestItemNames.length != manifestItemWeights.length ||
          manifestItemNames.length != manifestItemVatPercentages.length) {
        throw ArgumentError('Manifest item lists must be of equal length');
      }
      final token = await _token;
      final response = await _client!.post(
        Uri.parse(
            '$_proxyUrl?url=${Uri.encodeComponent('$_baseUrl/customers/$uberCustomerId/deliveries')}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "pickup_name": pickupName,
          "pickup_business_name": pickupBusinessName ?? pickupName,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "pickup_address": pickupAddress,
          "pickup_phone_number": pickupPhoneNumber,
          "dropoff_name": dropoffName,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "dropoff_address": dropoffAddress,
          "dropoff_phone_number": dropoffPhoneNumber,
          "dropoff_notes": dropoffNotes,
          "dropoff_seller_notes": dropoffSellerNotes,
          "manifest_items": List.generate(
            manifestItemNames.length,
            (i) => {
              "name": manifestItemNames[i],
              "quantity": manifestItemQuantities[i],
              "size": manifestItemSizes[i],
              "dimensions": {
                "length": manifestItemLengths[i],
                "height": manifestItemHeights[i],
                "depth": manifestItemDepths[i]
              },
              "price": manifestItemPrices[i],
              "weight": manifestItemWeights[i],
              "vat_percentage": manifestItemVatPercentages[i]
            },
          ),
          "deliverable_action": deliverableAction.name,
          "manifest_total_value": manifestTotalValue ??
              manifestItemPrices.fold<int>(0, (a, b) => a + b),
          "tip": tip,
          "return_notes": returnNotes,
          "external_user_info": {
            "merchant_account": {
              "account_created_at": mercentAccountCreated?.toIso8601String() ??
                  DateTime.now().toIso8601String(),
              "email": merchantAccountEmail,
            },
            "device": {"id": deviceId ?? 'f2bdcb36-f86b-4197-89f8-54c72f98d24b'}
          },
          "external_id": externalId ?? '1234567890',
        }),
      );

      _handleErrorResponse(response);

      return DeliveryEntity.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<DeliveryEntity?> getDelivery(String id) async {
    try {
      final tkn = await _token;
      final response = await http.get(
        Uri.parse(
            '$_proxyUrl?url=$_baseUrl/customers/$uberCustomerId/deliveries/$id'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $tkn',
        },
      );

      _handleErrorResponse(response);

      return DeliveryEntity.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  void _handleErrorResponse(http.Response response) {
    if (response.statusCode >= 400) {
      try {
        final body = json.decode(response.body) as Map<String, dynamic>;

        debugPrint('\n=== Debug: Error Details ===');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Error Body: ${response.body}');
        if (body['errors'] != null) {
          debugPrint('Validation Errors:');
          for (var error in body['errors']) {
            debugPrint('- Field: ${error['field']}');
            debugPrint('  Code: ${error['code']}');
            debugPrint('  Message: ${error['message']}');
          }
        }

        throw UberApiException(
          statusCode: response.statusCode,
          message: body['message'] ?? 'Unknown error',
          code: body['code'] ?? 'unknown_error',
          errors: body['errors'] != null
              ? (body['errors'] as List)
                  .map((e) => UberError.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
        );
      } catch (e) {
        debugPrint('Error parsing response: $e');
        throw UberApiException(
          statusCode: response.statusCode,
          message: 'Failed to parse error response: ${response.body}',
          code: 'parse_error',
        );
      }
    }
  }

  void dispose() {
    _client?.close();
    _client = null;
  }
}
