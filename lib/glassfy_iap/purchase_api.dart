import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glassfy_flutter/glassfy_flutter.dart';
import 'package:glassfy_flutter/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      return transaction;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // print('Current Permission ID is: ${permission.permissionId}');

  static Future<bool> isUserPremium() async {
    if (!Platform.isAndroid) {
      return true;
    }
    bool isPremium = false;
    print('Purchase Checking started');
    try {
      var permission = await Glassfy.permissions();

      if (permission.all!
          .any((p) => p.permissionId == "premium" && p.isValid == true)) {
        // unlock aFeature

        print('User is Premium');
        isPremium = true;
      } else {
        print('User is Free');
        isPremium = false;
      }
      ;
    } catch (e) {
      // initialization error

      print('Error in Purchase Checking');
      isPremium = false;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPremium', isPremium);

    return isPremium;
  }

  static Future<bool> isValidPurchase(GlassfyTransaction transaction) async {
    bool isValidPurchase = false;
    try {
      if (transaction.permissions != null) {
        GlassfyPermissions permissions = transaction.permissions!;

        if (permissions.all!.any((permission) =>
            permission.permissionId == "premium" &&
            permission.isValid == true)) {
          print('Purchase Successful');
          isValidPurchase = true;
        } else {
          print('Purchase Failed');
        }
      } else {
        print('Permisson is null');
      }
    } catch (e) {
      // initialization error
      print('Purchase Failed in catch $e');
    }

    return isValidPurchase;
  }

  static Future<bool> is_userPremium() async {
    bool isPremium = false;

    if (Platform.isAndroid) {
      isPremium = await PurchaseApi.isUserPremium();
    } else {
      isPremium = true;
    }

    return isPremium;
  }
}
