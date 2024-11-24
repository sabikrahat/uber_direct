import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../uber_direct.dart';
import 'model/quote/enum.dart';

class UberDirectClient {
  final String uberClientId;
  final String uberClientSecret;
  final String uberCustomerId;

  String? _accessToken;
  DateTime? _tokenExpiry;
  late http.Client? _client;

  UberDirectClient({
    /// Example: 1f2e3d4c-5b6a-7d8e-9f0a-1b2c3d4e5f6g
    /// The client ID of the application. This is the unique identifier for the application.
    required this.uberClientId,

    /// Example: 1f2e3d4c-5b6a-7d8e-9f0a-1b2c3d4e5f6g
    /// The client Secret of the application. This is the unique identifier for the application.
    required this.uberClientSecret,

    /// Example: a11e6f29-6850-4d8d-b88d-0ae69cec1111
    /// Unique identifier for the organization. Either UUID or starts with cus_.
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
    /// The address of the pickup location.
    /// This is a required field.
    /// Format: "{\"street_address\":[\"100 Maiden Ln\"],\"city\":\"New York\",\"state\":\"NY\",\"zip_code\":\"10023\",\"country\":\"US\"}",
    /// This format is tough to work with, so we'll just use a single string.
    /// Example: "100 Maiden Ln, New York, NY 10023, US"
    /// But for this `pickupLatitude` and `pickupLongitude` are required.
    required String pickupAddress,

    /// The latitude of the pickup location.
    required double pickupLatitude,

    /// The longitude of the pickup location.
    required double pickupLongitude,

    /// The address of the dropoff location.
    /// This is a required field.
    /// Format: "{\"street_address\":[\"30 Lincoln Center Plaza\"],\"city\":\"New York\",\"state\":\"NY\",\"zip_code\":\"10023\",\"country\":\"US\"}",
    /// This format is tough to work with, so we'll just use a single string.
    /// Example: "30 Lincoln Center Plaza, New York, NY 10023, US"
    /// But for this `dropoffLatitude` and `dropoffLongitude` are required.
    required String dropoffAddress,

    /// The latitude of the dropoff location.
    required double dropoffLatitude,

    /// The longitude of the dropoff location.
    required double dropoffLongitude,

    /// The phone number of the person at the pickup location.
    /// Phone number for the pickup location, usually the store's contact.
    /// This number allows the courier to call before heading to the dropoff location.
    String? pickupPhoneNumber,

    /// The phone number of the person at the dropoff location.
    /// Phone number for the dropoff location, usually belonging to the end-user (recipient).
    /// This number enables the courier to make calls after en route to the dropoff and before completing the trip.
    String? dropoffPhoneNumber,

    /// The date and time when the pickup item is ready for start delivery.
    /// Beginning of the window when an order must be picked up. Must be less than 30 days in the future.
    DateTime? pickupReadyDt,

    /// The date and time when the pickup item must be picked up.
    /// End of the window when an order may be picked up.
    /// Must be at least 10 mins later than `pickup_ready_dt` and at least 20 minutes in the future from now.
    DateTime? pickupDeadlineDt,

    /// The date and time when the item is ready for dropoff.
    /// Beginning of the window when an order must be dropped off.
    /// Must be less than or equal to `pickup_deadline_dt`.
    DateTime? dropoffReadyDt,

    /// The date and time when the dropoff item must be dropped off.
    /// End of the window when an order must be dropped off.
    /// Must be at least 20 mins later than `dropoff_ready_dt` and must be greater than or equal to `pickup_deadline_dt`.
    DateTime? dropoffDeadlineDt,

    /// Value in cents ( ¹/₁₀₀ of currency unit ) of the items in the delivery. i.e.: $10.99 => 1099.
    int? manifestTotalValue,

    /// Unique identifier used by our Partners to reference a store or location.
    /// Note: Please be aware that if you utilize `external_store_id` in the Create Delivery process,
    /// you MUST also include this field in your Create Quote API calls.
    String? externalStoreId,
  }) async {
    try {
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
          "pickup_ready_dt": pickupReadyDt?.toIso8601String(),
          "pickup_deadline_dt": pickupDeadlineDt?.toIso8601String(),
          "dropoff_ready_dt": dropoffReadyDt?.toIso8601String(),
          "dropoff_deadline_dt": dropoffDeadlineDt?.toIso8601String(),
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
    /// Designation of the location where the courier will make the pickup.
    /// This information will be visible within the courier app.
    /// Note: The app will prioritize the utilization of the pickup_business_name if this parameter is provided.
    required String pickupName,

    /// Business name of the pickup location. This information will be visible in the courier app
    /// and will override the pickup_name if provided.
    String? pickupBusinessName,

    /// The address of the pickup location.
    /// This is a required field.
    /// Format: "{\"street_address\":[\"100 Maiden Ln\"],\"city\":\"New York\",\"state\":\"NY\",\"zip_code\":\"10023\",\"country\":\"US\"}",
    /// This format is tough to work with, so we'll just use a single string.
    /// Example: "100 Maiden Ln, New York, NY 10023, US"
    /// But for this `pickupLatitude` and `pickupLongitude` are required.
    required String pickupAddress,

    /// The latitude of the pickup location.
    required double pickupLatitude,

    /// The longitude of the pickup location.
    required double pickupLongitude,

    /// Phone number for the pickup location, usually the store's contact. This number allows
    /// the courier to call before heading to the dropoff location.
    required String pickupPhoneNumber,

    /// Additional instructions for the courier at the pickup location.
    /// Max 280 characters.
    String? pickupNotes,

    /// Name of the place where the courier will make the dropoff.
    /// This information will be visible in the courier app.
    required String dropoffName,

    ///	Business name of the dropoff location.
    String? dropoffBusinessName,

    /// The address of the dropoff location.
    /// This is a required field.
    /// Format: "{\"street_address\":[\"30 Lincoln Center Plaza\"],\"city\":\"New York\",\"state\":\"NY\",\"zip_code\":\"10023\",\"country\":\"US\"}",
    /// This format is tough to work with, so we'll just use a single string.
    /// Example: "30 Lincoln Center Plaza, New York, NY 10023, US"
    /// But for this `dropoffLatitude` and `dropoffLongitude` are required.
    required String dropoffAddress,

    /// The latitude of the dropoff location.
    required double dropoffLatitude,

    /// The longitude of the dropoff location.
    required double dropoffLongitude,

    /// Phone number for the dropoff location, usually belonging to the end-user (recipient).
    /// This number enables the courier to make calls after en route to the dropoff and before completing the trip.
    required String dropoffPhoneNumber,

    /// accessible after the courier accepts the trip and before heading to the dropoff location.
    /// Limited to 280 characters.
    String? dropoffNotes,

    /// Merchant's extra dropoff instructions, accessible after the courier accepts the trip and
    /// before heading to the dropoff location. Limited to 280 characters.
    String? dropoffSellerNotes,

    /// List of items being delivered. This information will be visible in the courier app.
    required List<ManifestItem> manifestItems,

    /// Enum: "deliverable_action_meet_at_door" "deliverable_action_leave_at_door"
    /// Enum: `DeliverableAction` Values: `deliverableActionMeetAtDoor`, `deliverableActionLeaveAtDoor`
    /// Default: `DeliverableAction.deliverableActionMeetAtDoor`
    /// Specify the action for the courier to take on a delivery.
    DeliverableAction? deliverableAction,

    /// A reference identifying the manifest. Utilize this to link a delivery with relevant data in your system.
    /// This detail will be visible within the courier app.
    /// Notes:
    /// 1. Please be aware that the combination of this field with external_id must be unique; otherwise, the delivery creation will not succeed.
    /// 2. If you can't ensure uniqueness for the manifest_reference, please include the "idempotency_key" in the request body and make sure it is unique.
    String? manifestReference,

    /// Value in cents ( ¹/₁₀₀ of currency unit ) of the items in the delivery. i.e.: $10.99 => 1099.
    int? manifestTotalValue,

    /// The ID of a previously generated delivery quote.
    String? quoteId,

    /// Beginning of the window when an order must be picked up. Must be less than 30 days in the future.
    DateTime? pickupReadyDt,

    /// End of the window when an order may be picked up. Must be at least 10 mins later than `pickup_ready_dt` and
    /// at least 20 minutes in the future from now.
    DateTime? pickupDeadlineDt,

    /// Beginning of the window when an order must be dropped off. Must be less than or equal to `pickup_deadline_dt`.
    DateTime? dropoffReadyDt,

    /// End of the window when an order must be dropped off. Must be at least 20 mins later than `dropoff_ready_dt` and
    /// must be greater than or equal to `pickup_deadline_dt`.
    DateTime? dropoffDeadlineDt,

    /// integer >= 0
    /// Amount in cents ( ¹/₁₀₀ of currency unit ) that will be paid to the courier as a tip. e.g.: $5.00 => 500.
    /// Note: The fee value in the Create Delivery response includes the tip value.
    int? tip,

    /// A key which is used to avoid duplicate order creation with identical idempotency keys for the same account.
    /// The key persists for a set time frame, defaulting to 60 minutes.
    String? idempotencyKey,

    /// Unique identifier used by our Partners to reference a store or location.
    /// Note: Please be aware that if you utilize external_store_id in the Create Delivery process,
    /// you MUST also include this field in your Create Quote API calls.
    String? externalStoreId,

    /// Additional instructions for the courier for return trips. Max 280 characters.
    String? returnNotes,

    /// End-user's Account creation time.
    DateTime? mercentAccountCreated,

    /// End-user's email used to create the account.
    String? merchantAccountEmail,

    /// A string that represents the end-user unique device id.
    /// string >= 256
    String? deviceId,

    /// Additional reference to identify the manifest. To be used by aggregators, POS systems, and other organization structures
    /// which have an internal reference in addition to the manifest_reference used by your sub-account.
    /// Merchants can search for this value in the dashboard, and it is also visible on the billing details report generated by the dashboard.
    String? externalId,
  }) async {
    try {
      if (manifestItems.isEmpty) {
        throw ArgumentError('Manifest items cannot be empty');
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
          "pickup_business_name": pickupBusinessName,
          "pickup_address": pickupAddress,
          "pickup_latitude": pickupLatitude,
          "pickup_longitude": pickupLongitude,
          "pickup_phone_number": pickupPhoneNumber,
          "pickup_notes": pickupNotes,
          "dropoff_name": dropoffName,
          "dropoff_business_name": dropoffBusinessName,
          "dropoff_address": dropoffAddress,
          "dropoff_latitude": dropoffLatitude,
          "dropoff_longitude": dropoffLongitude,
          "dropoff_phone_number": dropoffPhoneNumber,
          "dropoff_notes": dropoffNotes,
          "dropoff_seller_notes": dropoffSellerNotes,
          "manifest_items": manifestItems.map((e) => e.toJson()).toList(),
          "deliverable_action": deliverableAction?.name,
          "manifest_reference": manifestReference,
          "manifest_total_value": manifestTotalValue,
          "quote_id": quoteId,
          "pickup_ready_dt": pickupReadyDt?.toIso8601String(),
          "pickup_deadline_dt": pickupDeadlineDt?.toIso8601String(),
          "dropoff_ready_dt": dropoffReadyDt?.toIso8601String(),
          "dropoff_deadline_dt": dropoffDeadlineDt?.toIso8601String(),
          "tip": tip,
          "idempotency_key": idempotencyKey,
          "external_store_id": externalStoreId,
          "return_notes": returnNotes,
          "external_user_info": {
            "merchant_account": {
              "account_created_at": mercentAccountCreated?.toIso8601String(),
              "email": merchantAccountEmail,
            },
            "device": {"id": deviceId}
          },
          "external_id": externalId,
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

  Future<DeliveryEntity?> getDelivery(
    /// Example: del_ExLGCyywQ5KlvncU2rUUUd3
    /// Unique identifier for the delivery. Always starts with del_
    String id,
  ) async {
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
