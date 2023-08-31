// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smart_gpt_ai/widgets/home_screen_top_section.dart';
import 'package:smart_gpt_ai/widgets/task_cards/task_card_full_width_widget_list.dart';
import '../admob/ad_helpter_test.dart';
import '../constants/constants.dart';
import '../testings/hive-test/chat_model.dart';
import '../services/image_to_text_service.dart';
import '../utilities/shared_prefs.dart';
import '../widgets/image_scanning_animation_widget.dart';
import '../widgets/prompt_input_widget.dart';
import '../widgets/task_cards/task_card_ocr_summary_widget.dart';
import '../widgets/task_cards/task_card_widget_half_width.dart';
import '../widgets/text_widget.dart';
import 'chat_screen.dart';
import 'settings_screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  BannerAd? _bannerAd;

  bool imageProcessing = false;

  final sharedPreferencesUtil = SharedPreferencesUtil();

  late bool adUser;

  @override
  void initState() {
    super.initState();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    adUser = sharedPreferencesUtil.getBool('adUser');
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorPallate.cardColor,
        title: Stack(
          children: [
            Center(
              child: TextWidget(label: 'SmartGPT', fontSize: 20),
            ),
            Positioned(
                left: 0,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) => SettingsScreen());
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Reward Ad Button
          // ElevatedButton(
          //     onPressed: () {
          //       _rewardedAd?.show(
          //         onUserEarnedReward: (_, reward) {
          //           // QuizManager.instance.useHint();
          //         },
          //       );
          //     },
          //     child: Text('Show Ad')),

          // TODO: Display a banner when ready
          if (_bannerAd != null && adUser == true)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),

          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      // HomeScreenTopSection(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: TaskCardSummaryWidget(onPressed: () async {
                              if (Platform.isAndroid) {
                                await extractAndroidImage();
                              } else {
                                print('Currently Support Only Android');
                              }
                            }),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                for (var cardmodel in card_list)
                                  TaskCardHalfWidth(
                                    color: card_list.indexOf(cardmodel) % 2 == 0
                                        ? Colors.red
                                        : Colors.deepPurple,
                                    taskModel: cardmodel,
                                    onPressed: () {
                                      Chat chat = Chat(chatMessageList: [
                                        ChatMessage(
                                            msg: cardmodel.msg, senderIndex: 0)
                                      ], lastUpdateTime: '');

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  chatObject: chat,
                                                  gobackPageIndex: 0)));
                                    },
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      TaskCardSectionListWidget(),
                    ],
                  )),
                  if (imageProcessing == true) ImageScanAnimationWidget()
                ],
              ),
            ),
          ),

          //Send Message Input Section
          PromptInputWidget(
            isStreaming: false,
            controller: controller,
            onPressedSendButton: () {
              Chat chat = Chat(chatMessageList: [
                ChatMessage(msg: controller.text, senderIndex: 0)
              ], lastUpdateTime: '');

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(chatObject: chat, gobackPageIndex: 0)));
            },
            onPressedCameraButton: () async {
              int? selectedImgSrc =
                  await ImageToTextService.getImageSrc(context);

              if (selectedImgSrc != null) {
                setState(() {
                  imageProcessing = true;
                });

                String? imageText =
                    await ImageToTextService.getTextFromImage(selectedImgSrc);

                setState(() {
                  imageProcessing = false;
                });

                if (imageText != null) {
                  Chat chat = Chat(chatMessageList: [
                    ChatMessage(msg: imageText, senderIndex: 0)
                  ], lastUpdateTime: '');

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              chatObject: chat, gobackPageIndex: 0)));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  extractAndroidImage() async {
    int? selectedImgSrc = await ImageToTextService.getImageSrc(context);

    if (selectedImgSrc != null) {
      setState(() {
        imageProcessing = true;
      });

      String? imageText =
          await ImageToTextService.getTextFromImage(selectedImgSrc);

      setState(() {
        imageProcessing = false;
      });

      if (imageText != null) {
        Chat chat = Chat(
            chatMessageList: [ChatMessage(msg: imageText, senderIndex: 0)],
            lastUpdateTime: '');

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatScreen(chatObject: chat, gobackPageIndex: 0)));
      }
    }
  }
}
