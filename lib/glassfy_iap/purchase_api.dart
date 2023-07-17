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
      GlassfyTransaction transaction = await Glassfy.purchaseSku(sku);

      try {
        var p = transaction.permissions?.all?.singleWhere((permission) {
          print('Current Permission ID is: ${permission.permissionId}');
          return permission.permissionId == 'premium';
        });
        print('ID is: ${p!.permissionId}');
        if (p.isValid == true) {
          // unlock aFeature
          print('Purchase Successfull');
        } else {
          // lock aFeature
          print('Purchase Unsuccesfull');
        }
      } catch (e) {
        // initialization error
        print('Purchase Validation Error:');
        print(e);
      }

      // print('Transaction::');
      // print(transaction.productIdentifier.);

      return transaction;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

void purchaseValidation(GlassfyTransaction transaction) {
  try {
    var p = transaction.permissions?.all?.singleWhere((permission) {
      print('Current Permission ID is: ${permission.permissionId}');
      return permission.permissionId == 'premium';
    });
    print('ID is: ${p!.permissionId}');
    if (p?.isValid == true) {
      // unlock aFeature
      print('Purchase Successfull');
    } else {
      // lock aFeature
      print('Purchase Unsuccesfull');
    }
  } catch (e) {
    // initialization error
    print('Purchase Validation Error:');
    print(e);
  }
}
