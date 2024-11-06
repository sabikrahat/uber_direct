import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uber_direct/uber_direct.dart';
import 'package:uberdirect/constant.dart';

late UberDirectClient uberDirectClient;

void main() {
  uberDirectClient = UberDirectClient(
    uberClientId: uberClientId,
    uberClientSecret: uberClientSecret,
    uberCustomerId: uberCustomerId,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Direct',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DeliveryQuote? deliveryQuote;
  DeliveryEntity? delivery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Uber Direct'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (deliveryQuote == null)
                  const Text(
                    'Press the button to get a quote',
                  ),
                if (deliveryQuote != null) ...[
                  Text(
                    'Quote: $deliveryQuote',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        EasyLoading.show();
                        delivery = await uberDirectClient.createDelivery(
                          pickupName: "Latash Properties",
                          pickupLatitude: -33.935670,
                          pickupLongitude: 151.041460,
                          pickupAddress:
                              "85 King Georges Rd, Wiley Park NSW 2195",
                          pickupPhoneNumber: "+61412345678",
                          dropoffName: "AF Motors Automotive Services",
                          dropoffLatitude: -33.927040,
                          dropoffLongitude: 151.057320,
                          dropoffAddress: "27 Moxon Rd, Punchbowl NSW 2196",
                          dropoffPhoneNumber: "+61412345678",
                          dropoffNotes:
                              "Second floor, black door to the right.",
                          dropoffSellerNotes:
                              "Fragile content - please handle the box with care.",
                          manifestItemNames: ["Bow tie"],
                          manifestItemQuantities: [1],
                          manifestItemSizes: ["small"],
                          manifestItemLengths: [20],
                          manifestItemHeights: [20],
                          manifestItemDepths: [20],
                          manifestItemPrices: [100],
                          manifestItemWeights: [300],
                          manifestItemVatPercentages: [1250000],
                          merchantAccountEmail: 'sabikrahat72428@gmail.com',
                        );
                        setState(() {});
                        EasyLoading.dismiss();
                      } on UberApiException catch (e) {
                        EasyLoading.showError(
                            e.errors?.first.message ?? e.message);
                      }
                    },
                    child: const Text('Create Delivery'),
                  ),
                  const SizedBox(height: 12),
                  if (delivery != null) ...[
                    Text(
                      'Delivery: $delivery',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        try {
                          EasyLoading.show();
                          delivery =
                              await uberDirectClient.getDelivery(delivery!.id);
                          setState(() {});
                          EasyLoading.dismiss();
                        } on UberApiException catch (e) {
                          EasyLoading.showError(
                              e.errors?.first.message ?? e.message);
                        }
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ]
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            EasyLoading.show();
            deliveryQuote = await uberDirectClient.createQuote(
              pickupAddress: "85 King Georges Rd, Wiley Park NSW 2195",
              pickupLatitude: -33.935670,
              pickupLongitude: 151.041460,
              pickupPhoneNumber: "+61412345678",
              dropoffAddress: "27 Moxon Rd, Punchbowl NSW 2196",
              dropoffLatitude: -33.927040,
              dropoffLongitude: 151.057320,
              dropoffPhoneNumber: "+61412345678",
            );
            setState(() {});
            EasyLoading.dismiss();
          } on UberApiException catch (e) {
            EasyLoading.showError(e.errors?.first.message ?? e.message);
          }
        },
        tooltip: 'add-quote',
        child: const Icon(Icons.add),
      ),
    );
  }
}
