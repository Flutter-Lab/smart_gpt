import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gpt_ai/screens/settings_screen/settings_card.dart';
import 'package:smart_gpt_ai/widgets/translate_language_dialog.dart';

import '../../constants/constants.dart';
import '../../docs/terms_and_condition.dart';
import '../../services/subscription_service.dart';
import '../../utilities/shared_prefs.dart';
import 'settings_close_button.dart';

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

  String? transLanguage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalSent = sharedPreferencesUtil.getInt('totalSent');
    isPremium = sharedPreferencesUtil.getBool('isPremium');

    getTransLang();
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
          children: [
            SettingsCloseButton(),
            SettingsCard(
              icon: Icons.generating_tokens,
              title: 'Chat Points',
              trailing: isPremium ? 'Unlimited' : '$chatPoints',
            ),
            SettingsCard(
                icon: Icons.translate,
                title: 'Translate Language',
                trailing: transLanguage != null ? transLanguage! : 'Select',
                onTap: () async {
                  await TransLangDialog(context);
                  await getTransLang();
                }),
            SettingsCard(
              icon: Icons.do_disturb_alt_outlined,
              title: 'Remove Ad',
              trailing: '🚷',
              onTap: () async {
                Navigator.pop(context);
                await SubscriptionService.showSubscriptionScreen(
                    context: context);
              },
            ),
            SettingsCard(
              icon: Icons.policy_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserNoticeMD(
                              noticeLocation: 'assets/docs/privacy_policy.md',
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getTransLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transLangCode = await prefs.getString('transLanguage') ?? null;

    if (transLangCode != null) {
      String language = '';
      for (var languageMap in transLanguageList) {
        if (languageMap['code'] == transLangCode) {
          language = languageMap['language']!;
          break;
        }
      }

      setState(() {
        transLanguage = language;
      });
    } else {
      setState(() {
        transLanguage = 'Select';
      });
    }
  }
}
