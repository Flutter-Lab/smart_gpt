// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gpt_ai/screens/start_screen.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../glassfy_iap/purchase_api.dart';

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
        padding: EdgeInsets.all(8),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                TextWidget(label: 'Get Pro Access', fontSize: 30),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectOption = 1;
                      offerID = 'Premium-Yearly';
                    });
                  },
                  child: Text(
                    'Yearly Access',
                    style: TextStyle(
                        color:
                            selectOption == 1 ? Colors.white : Colors.black87),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectOption == 1 ? Colors.green : Colors.white),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectOption = 2;
                      offerID = 'Pro-Access';
                    });
                  },
                  child: Text(
                    'Weekly Access',
                    style: TextStyle(
                      color: selectOption == 2 ? Colors.white : Colors.black87,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectOption == 2 ? Colors.green : Colors.white,
                      side: selectOption == 2
                          ? BorderSide(width: 2, color: Colors.amber)
                          : BorderSide(width: 0, color: Colors.amber)),
                ),
                SizedBox(height: 8),
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
