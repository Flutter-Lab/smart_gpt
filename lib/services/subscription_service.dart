import 'package:flutter/material.dart';

import '../screens/subscription_screen.dart';

class SubscriptionService {
  static Future<void> showSubscriptionScreen(
      {required BuildContext context}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => SubscriptionScreen());
    });
  }
}
