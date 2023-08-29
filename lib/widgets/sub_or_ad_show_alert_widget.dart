import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../admob/ad_helpter_test.dart';
import '../constants/constants.dart';
import '../screens/chat_screen.dart';
import '../services/subscription_service.dart';
import '../utilities/shared_prefs.dart';

class SubOrAdAlertWidget extends StatefulWidget {
  const SubOrAdAlertWidget({super.key});

  @override
  State<SubOrAdAlertWidget> createState() => _SubOrAdAlertWidgetState();
}

class _SubOrAdAlertWidgetState extends State<SubOrAdAlertWidget> {
  final sharedPreferencesUtil = SharedPreferencesUtil();
  RewardedAd? _rewardedAd;
  late int totalSent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalSent = sharedPreferencesUtil.getInt('totalSent');
    _loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: ColorPallate.bgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: SimpleButton(
                btnText: 'Subscribe for Unlimited Chat',
                txtColor: Colors.greenAccent,
              ),
              onTap: () async {
                Navigator.pop(context);
                await SubscriptionService.showSubscriptionScreen(
                    context: context);
              },
            ),
            GestureDetector(
              child: SimpleButton(
                btnText: 'Continue with Watching Ad',
                txtColor: Colors.amberAccent,
              ),
              onTap: () async {
                _rewardedAd?.show(
                  onUserEarnedReward: (_, reward) {
                    sharedPreferencesUtil.saveInt(
                        'totalSent', totalSent - reward.amount.toInt());

                    // QuizManager.instance.useHint();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }
}
