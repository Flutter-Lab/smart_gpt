import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../../constants/constants.dart';
import '../../utilities/shared_prefs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final sharedPreferencesUtil = SharedPreferencesUtil();

  late int totalSent;
  late bool isPremium;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalSent = sharedPreferencesUtil.getInt('totalSent');
    isPremium = sharedPreferencesUtil.getBool('isPremium');
  }

  @override
  Widget build(BuildContext context) {
    int chatPoints = freeChatLimit - totalSent;
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: BoxDecoration(
          color: ColorPallate.bgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ))),
            Card(
              color: ColorPallate.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                        label: 'Chat Points', fontWeight: FontWeight.normal),
                    TextWidget(
                        label: isPremium ? 'Unlimited' : '$chatPoints',
                        fontWeight: FontWeight.normal),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
