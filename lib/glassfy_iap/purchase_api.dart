import 'package:flutter/material.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';
import 'package:glassfy_flutter/models.dart';

class PurchaseApi {
  static const _apiKey = '76004c7da9c8441197ef7d79123e7723';

  static Future<void> init() async {
    await Glassfy.initialize(_apiKey, watcherMode: false);
  }

  static Future<List<GlassfyOffering>> fetchOffers() async {
    try {
      final offerings = await Glassfy.offerings();
      return offerings.all ?? [];
    } catch (e) {
      print('Error Happaned');
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<GlassfyTransaction?> purchaseSku(GlassfySku sku) async {
    try {
      
      return await Glassfy.purchaseSku(sku);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
