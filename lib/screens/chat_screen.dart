// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls, deprecated_member_use, prefer_const_constructors, must_be_immutable

import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_gpt_ai/constants/api_consts.dart';
import 'package:smart_gpt_ai/data/response_helper.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'package:smart_gpt_ai/services/api_service.dart';
import 'package:smart_gpt_ai/widgets/image_scanning_animation_widget.dart';
import 'package:smart_gpt_ai/widgets/sub_or_ad_show_alert_widget.dart';
import '../Admob/ad_helpter_test.dart';
import '../constants/constants.dart';
import '../testings/hive-test/chat_model.dart';
import '../services/image_to_text_service.dart';
import '../utilities/shared_prefs.dart';
import '../widgets/chat_card_widget.dart';
import '../widgets/prompt_input_widget.dart';
import '../widgets/text_widget.dart';
import 'start_screen.dart';

class ChatScreen extends StatefulWidget {
  List<Map<String, dynamic>>? conversation;
  final int gobackPageIndex;
  Chat? chatObject;

  ChatScreen({
    Key? key,
    this.chatObject,
    this.conversation,
    required this.gobackPageIndex,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController inputTextcontroller = TextEditingController();

  ScrollController scrollController = ScrollController();

  final sharedPreferencesUtil = SharedPreferencesUtil();

  bool imageProcessing = false;

  int count = 0;

  late int totalSent;
  late bool isPremium;

  late Chat myChat;

  bool isStreaming = false;

  int scrollText = 250;
  bool doScroll = false;

  bool alertShown = false;

  RewardedAd? _rewardedAd;

  Future<void> showSubOrAdAlert() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => SubOrAdAlertWidget());
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // scrollController = ScrollController();

      scrollToBottom();

      _loadRewardedAd();
    });
    totalSent = sharedPreferencesUtil.getInt('totalSent');
    isPremium = sharedPreferencesUtil.getBool('isPremium');

    if (widget.chatObject != null) {
      myChat = widget.chatObject!;
    }
  }

  StreamController<String> _replyStreamController =
      StreamController<String>.broadcast();

  @override
  void dispose() {
    scrollController.dispose();
    _replyStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Total Sent: $totalSent');

    if (totalSent < freeChatLimit - 1 || isPremium) {
      print('is Streaming : $isStreaming');

      if (widget.gobackPageIndex < 2 && count == 0) {
        increaseTotalSent();

        replyFunction();

        count++;
      }
    } else {
      if (alertShown == false) {
        showSubOrAdAlert();
        sharedPreferencesUtil.saveBool('adUser', true);
        print('showSubOrAdAlert : firest');
        setState(() {
          alertShown = true;
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: appBarTitleWidget(context),
          backgroundColor: ColorPallate.cardColor,
        ),
        body: FutureBuilder<bool>(
            future: PurchaseApi.isUserPremium(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  : SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          NotificationListener<ScrollNotification>(
                            //Hide keyboard on Scroll
                            onNotification: (scrollNotification) {
                              if (scrollNotification
                                      is ScrollUpdateNotification &&
                                  scrollNotification.metrics.axis ==
                                      Axis.vertical &&
                                  scrollNotification.dragDetails != null) {
                                // Hide the keyboard when scrolling starts
                                FocusScope.of(context).unfocus();
                              }

                              return false;
                            },
                            child: Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      controller: scrollController,
                                      itemCount: myChat.chatMessageList.length,
                                      itemBuilder: (context, index) {
                                        String msg =
                                            myChat.chatMessageList[index].msg;
                                        int chatIndex = myChat
                                            .chatMessageList[index].senderIndex;

                                        return GestureDetector(
                                          onTap: () {
                                            // When tapped outside of the keyboard, unfocus the current focus node.
                                            final currentFocus =
                                                FocusScope.of(context);
                                            if (!currentFocus.hasPrimaryFocus) {
                                              currentFocus.unfocus();
                                            }
                                          },
                                          child: isStreaming &&
                                                  myChat.chatMessageList
                                                          .length ==
                                                      index + 1
                                              ? MessageCardWidget(
                                                  convLength: myChat
                                                      .chatMessageList.length,
                                                  currentMsgIndex: index,
                                                  stream: _replyStreamController
                                                      .stream,
                                                  chatIndex: chatIndex,
                                                  msg: msg)
                                              : MessageCardWidget(
                                                  chatIndex: chatIndex,
                                                  msg: msg,
                                                  convLength: myChat
                                                      .chatMessageList.length,
                                                  currentMsgIndex: index),
                                        );
                                      },
                                    ),
                                    if (imageProcessing == true)
                                      ImageScanAnimationWidget(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (!isStreaming) reponseHelperWidget(),
                          PromptInputWidget(
                              isStreaming: isStreaming,
                              controller: inputTextcontroller,
                              onPressedSendButton: () {
                                if (isStreaming) {
                                  setState(() {
                                    isStreaming = false;
                                  });
                                } else {
                                  sendMessage(msg: inputTextcontroller.text);
                                }
                              },
                              onPressedCameraButton: () async {
                                int? selectedImgSrc =
                                    await ImageToTextService.getImageSrc(
                                        context);
                                if (selectedImgSrc != null) {
                                  setState(() {
                                    imageProcessing = true;
                                  });

                                  String? question =
                                      await ImageToTextService.getTextFromImage(
                                          selectedImgSrc);

                                  setState(() {
                                    imageProcessing = false;
                                  });
                                  if (question != null) {
                                    await limitCheckAndSend();
                                  }
                                }
                              }),
                        ],
                      ),
                    );
            }));
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

  Container reponseHelperWidget() {
    return Container(
      height: 36,
      margin: EdgeInsets.only(bottom: 8),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: responseHelperList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                sendMessage(msg: responseHelperList[index]);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    color: ColorPallate.light1,
                    borderRadius: BorderRadius.circular(16)),
                child: Text(
                  responseHelperList[index],
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }),
    );
  }

  void sendMessage({required String msg}) async {
    scrollToBottom();
    print('Total Sent: $totalSent');
    print(('Premium Status: $isPremium'));

    //Add Message to Chat object
    ChatMessage chatMessage = ChatMessage(msg: msg, senderIndex: 0);

    myChat.chatMessageList.add(chatMessage);

    //If freeLimit cross and User is not Premium Then Go to Subscription Screen
    await limitCheckAndSend();
  }

  Stack appBarTitleWidget(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            setState(() {
              isStreaming = false;
            });
            DateTime now = DateTime.now();
            int milliseconds = now.millisecondsSinceEpoch;
            //Adding mychat to Hive
            var chatBox = await Hive.openBox<Chat>('chatBox');
            myChat.lastUpdateTime = milliseconds.toString();

            //If not from History Screen
            if (widget.gobackPageIndex == 2) {
              await chatBox.delete(myChat.key);
            }
            await chatBox.put(myChat.lastUpdateTime, myChat);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return StartScreen(pageIndex: widget.gobackPageIndex);
            }));
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: TextWidget(label: 'Smart Chat', fontSize: 20),
          ),
        )
      ],
    );
  }

  List<Map<String, String>> getContext() {
    List<Map<String, String>> contextList = [];
    int totalWords = 0;
    for (int i = myChat.chatMessageList.length - 1; i >= 0; i--) {
      // totalWords += conv[i]['msg'].toString().split(' ').length;
      totalWords += myChat.chatMessageList[i].msg.split(' ').length;

      if (totalWords > contextLimit) {
        break;
      }
      try {
        contextList.add({
          'role':
              myChat.chatMessageList[i].senderIndex == 0 ? 'user' : 'assistant',
          'content': myChat.chatMessageList[i].msg
        });
      } catch (e) {
        print('Erron in making contest list');
      }
    }
    ;

    print('Total Words: $totalWords');
    contextList = contextList.reversed.toList();
    print('New Context: $contextList');
    return contextList;
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      // print('Scrolling to Bottom');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> replyFunction() async {
    setState(() {
      isStreaming = true;
    });

    getStreamResponse(contextMapList: getContext());

    setState(() {
      myChat.chatMessageList.add(ChatMessage(msg: '', senderIndex: 1));
    });

    scrollToBottom();
  }

  Future<void> limitCheckAndSend() async {
    print('Limit Check Called');
    if (totalSent > freeChatLimit && !isPremium) {
      // await showSubscriptionScreen();
      await showSubOrAdAlert();
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => SubscriptionScreen()));
    } else {
      inputTextcontroller.clear();
      increaseTotalSent();
      // setState(() {});
      await replyFunction();
    }
  }

  void increaseTotalSent() {
    if (totalSent < freeChatLimit) {
      print('Saving New Total Sent');
      sharedPreferencesUtil.saveInt('totalSent', totalSent + 1);
      print('Saved Total Sent');
      totalSent = sharedPreferencesUtil.getInt('totalSent');
    }

    print('Total Sent New: $totalSent');
  }

  late Stream<OpenAIStreamChatCompletionModel> chatStream;

  late StreamSubscription<OpenAIStreamChatCompletionModel>
      chatStreamSubscription;

  Future<String> getStreamResponse(
      {required List<Map<String, String>> contextMapList}) async {
    doScroll = true;
    setState(() {
      isStreaming = true;
    });

    OpenAI.apiKey = await ApiService.getApiKey();
    String fullText = '';

//Converting Context List
    List<OpenAIChatCompletionChoiceMessageModel> contextList =
        contextMapList.map((data) {
      return OpenAIChatCompletionChoiceMessageModel(
          content: data['content']!,
          role: data['role'] == 'user'
              ? OpenAIChatMessageRole.user
              : OpenAIChatMessageRole.assistant);
    }).toList();

    chatStream = OpenAI.instance.chat
        .createStream(model: "gpt-3.5-turbo", messages: contextList);

    chatStreamSubscription = chatStream.listen((streamChatCompletion) {
      final content = streamChatCompletion.choices.first.delta.content;
      // print(content);
      if (content != null) {
        if (isStreaming == true) {
          fullText = fullText + content;
          _replyStreamController.add(fullText);

          //Auto Scroll Logics

          if (fullText.length < scrollText) {
            scrollToBottom();
          }
          if (fullText.length > scrollText &&
              scrollController.hasClients &&
              doScroll == true &&
              scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent) {
            print('User Scrolls in End Position');
            scrollText += fullText.length;
            doScroll = false;
          }
        } else {
          print('Stream is Cancelled');
          setState(() {
            myChat.chatMessageList.last =
                ChatMessage(msg: fullText, senderIndex: 1);
          });

          chatStreamSubscription.cancel();
        }
      }
    }, onDone: () {
      print('Stream is Done');
      setState(() {
        myChat.chatMessageList.last =
            ChatMessage(msg: fullText, senderIndex: 1);

        isStreaming = false;
      });
    });

    _replyStreamController.done;

    // botReply = fullText;
    print('Full Text: $fullText');
    return fullText;
  }
}

class SimpleButton extends StatelessWidget {
  final String btnText;
  final Color txtColor;
  const SimpleButton({
    required this.btnText,
    required this.txtColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: ColorPallate.cardColor,
          borderRadius: BorderRadius.circular(16)),
      child: TextWidget(
        label: btnText,
        color: txtColor,
      ),
    );
  }
}
