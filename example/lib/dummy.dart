Map<String, dynamic> get sampleCreateDeliveryQuote {
  final now = DateTime.now().toUtc();
  return {
    "pickup_address": "85 King Georges Rd, Wiley Park NSW 2195",
    "pickup_latitude": -33.935670,
    "pickup_longitude": 151.041460,
    "pickup_phone_number": "+61412345678",
    "dropoff_address": "27 Moxon Rd, Punchbowl NSW 2196",
    "dropoff_latitude": -33.927040,
    "dropoff_longitude": 151.057320,
    "dropoff_phone_number": "+61412345678",
    "pickup_ready_dt": now.toIso8601String(),
    "pickup_deadline_dt": now.add(const Duration(hours: 1)).toIso8601String(),
    "dropoff_ready_dt": now.add(const Duration(hours: 1)).toIso8601String(),
    "dropoff_deadline_dt":
        now.add(const Duration(minutes: 90)).toIso8601String(),
    "manifest_total_value": 1000,
    "external_store_id": "1234567890"
  };
}

const Map<String, Object> sampleCreateDelivery = {
  "pickup_name": "Latash Properties",
  "pickup_phone_number": "+61412345678",
  "dropoff_name": "AF Motors Automotive Services",
  "pickup_address": "85 King Georges Rd, Wiley Park NSW 2195",
  "dropoff_address": "27 Moxon Rd, Punchbowl NSW 2196",
  "dropoff_phone_number": "+61412345678",
  "manifest_items": [
    {
      "name": "Bow tie",
      "quantity": 1,
      "size": "small",
      "dimensions": {"length": 20, "height": 20, "depth": 20},
      "price": 100,
      "weight": 300,
      "vat_percentage": 1250000
    }
  ],
  "pickup_business_name": "Store Name",
  "pickup_latitude": -33.935670,
  "pickup_longitude": 151.041460,
  "dropoff_latitude": -33.927040,
  "dropoff_longitude": 151.057320,
  "dropoff_notes": "Second floor, black door to the right.",
  "dropoff_seller_notes": "Fragile content - please handle the box with care.",
  "deliverable_action": "deliverable_action_meet_at_door",
  "manifest_total_value": 1000,
  "tip": 0,
  "return_notes":
      "Please meet store members at the counter to scan and verify the return of the order.",
  "external_user_info": {
    "merchant_account": {
      "account_created_at": "2019-10-12T07:20:50.520Z",
      "email": "2019-10-12T07:20:50.520Z"
    },
    "device": {"id": "f2bdcb36-f86b-4197-89f8-54c72f98d24b"}
  },
  "external_id": "1234567890"
};
