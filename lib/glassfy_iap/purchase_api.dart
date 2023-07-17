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

  // print('Current Permission ID is: ${permission.permissionId}');
  static Future<GlassfyTransaction?> purchaseSku(GlassfySku sku) async {
    try {
      GlassfyTransaction transaction = await Glassfy.purchaseSku(sku);

      try {
        GlassfyPermission? p;
        var temp;
        try {
          // p = transaction.permissions?.all?.singleWhere((permission) {
          //   print('permission ID: ${permission.permissionId}');

          //   return permission.permissionId == 'premium';
          // });

          p = transaction.permissions!.all![0];

          temp = p.permissionId;
          print(temp);
        } catch (error) {
          print('error on catch');
        }

        if (temp == 'premium') {
          print('purchase successful');
        } else {
          print('purchase unsuccessful');
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
