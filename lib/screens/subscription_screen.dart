// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gpt_ai/screens/start_screen.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../glassfy_iap/purchase_api.dart';
import '../widgets/premium_features_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectOption = 2;
  String offerID = 'Pro-Access';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 36),
            TextWidget(
              label: 'Get Pro Access',
              fontSize: 30,
            ),
            SizedBox(height: 48),
            PremiumFeaturesWidget(),
            Spacer(),
            //Yearly Access Card
            Card(
              color: selectOption == 1
                  ? const Color.fromARGB(255, 2, 92, 165)
                  : Colors.black87,
              child: ListTile(
                onTap: () {
                  setState(() {
                    selectOption = 1;
                    offerID = 'Premium-Yearly';
                  });
                },
                selectedColor:
                    selectOption == 1 ? Colors.white : Colors.black87,
                title: TextWidget(
                  label: 'Yearly Access',
                  fontSize: 16,
                  // color: ,
                ),
                subtitle: TextWidget(
                  label: '\$34.99 / year',
                  fontSize: 14,
                ),
                trailing: TextWidget(
                  label: '     Only\n\$0.67/week',
                  fontSize: 14,
                ),
                leading: Icon(
                  Icons.check,
                  color: selectOption == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),
            //Weekly Access Card
            Card(
              color: selectOption == 2
                  ? const Color.fromARGB(255, 2, 92, 165)
                  : Colors.black87,
              child: ListTile(
                  onTap: () {
                    setState(() {
                      selectOption = 2;
                      offerID = 'Pro-Access';
                    });
                  },
                  selectedColor:
                      selectOption == 2 ? Colors.white : Colors.black87,
                  title: TextWidget(
                    label: 'Weekly Access',
                    fontSize: 16,
                    // color: ,
                  ),
                  subtitle: TextWidget(
                    label: '\$4.99 / week',
                    fontSize: 14,
                  ),
                  leading: Icon(
                    Icons.check,
                    color: selectOption == 2 ? Colors.white : Colors.black,
                  )),
            ),

            SizedBox(height: 8),

            SizedBox(height: 24),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // }
                  onPressed: fetchOffers,

                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Continue',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(252, 64, 212, 163),
                    foregroundColor: Colors.white,
                  ),
                )),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();

    final offer =
        offerings.singleWhere((offering) => offering.offeringId == offerID);

    if (!mounted) return;

    var transaction = await PurchaseApi.purchaseSku(offer.skus![0]);

    //Purchase Proccessing
    if (transaction != null) {
      bool isValidPurchase = await PurchaseApi.isValidPurchase(transaction);

      if (isValidPurchase) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isPremium', true);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => StartScreen(pageIndex: 0)));
      }
    } else {
      print('No Transaction Found');
    }
  }
}
