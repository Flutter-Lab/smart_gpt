// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smart_gpt_ai/constants/api_consts.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'package:smart_gpt_ai/services/api_service.dart';
import 'package:smart_gpt_ai/widgets/image_scanning_animation_widget.dart';
import '../constants/constants.dart';
import '../services/image_to_text_service.dart';
import '../utilities/shared_prefs.dart';
import '../widgets/chat_card_widget.dart';
import '../widgets/prompt_input_widget.dart';
import '../widgets/text_widget.dart';
import 'start_screen.dart';
import 'subscription_screen.dart';

final myBox = Hive.box('myBox');

class ChatScreen extends StatefulWidget {
  final List<Map<String, dynamic>> conversation;
  final int id;
  final int gobackPageIndex;
  final String dateTime;

  const ChatScreen({
    Key? key,
    required this.conversation,
    required this.id,
    required this.gobackPageIndex,
    required this.dateTime,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> oldConversation = [];
  List<Map<String, dynamic>> conv = [];
  List<Map<String, dynamic>> addedConversation = [];
  List<Map<String, dynamic>> modifiedList = [];
  int id = 0;
  String dateTime = '';
  int indexNumber = 0;
  int checkLength = 0;
  int count = 0;

  bool gettingReply = false;
  TextEditingController controller = TextEditingController();

  late String question = '';
  late String replyByBot;

  ScrollController? scrollController;
  final sharedPreferencesUtil = SharedPreferencesUtil();

  bool imageProcessing = false;

  void replyFunction() async {
    setState(() {
      gettingReply = true;
    });
    // await Future.delayed(const Duration(seconds: 1));

    String botReply = await ApiService.sendMessage(contextList: getContext());
    setState(() {
      gettingReply = false;
      conv.add({"msg": botReply, "index": 1});
      addedConversation.add({"msg": botReply, "index": 1});
    });

    scrollToBottom();
  }

  late int totalSent;
  late bool isPremium;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = ScrollController();
      scrollToBottom();
    });
    totalSent = sharedPreferencesUtil.getInt('totalSent');
    isPremium = sharedPreferencesUtil.getBool('isPremium');
    id = widget.id;
  }

  @override
  void dispose() {
    scrollController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    conv = widget.conversation;

    dateTime = widget.dateTime;
    indexNumber = widget.gobackPageIndex;

    if (count < 1) {
      if (conv.length == 1) {
        replyFunction();
      }
      question = widget.conversation[0]["msg"];
      oldConversation = widget.conversation;
      // print(widget.conversation);
      checkLength = widget.conversation.length;
      count++;
    }

    print('Total Sent: $totalSent');

    if (totalSent < freeChatLimit - 1 || isPremium) {
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
                                        itemCount: widget.conversation.length,
                                        itemBuilder: (context, index) {
                                          String msg =
                                              widget.conversation[index]["msg"];
                                          int chatIndex = widget
                                              .conversation[index]["index"];

                                          return GestureDetector(
                                            onTap: () {
                                              // When tapped outside of the keyboard, unfocus the current focus node.
                                              final currentFocus =
                                                  FocusScope.of(context);
                                              if (!currentFocus
                                                  .hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                            },
                                            child: ChatCardWidget(
                                                chatIndex: chatIndex, msg: msg),
                                          );
                                        },
                                      ),
                                      if (imageProcessing == true)
                                        ImageScanAnimationWidget()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (gettingReply)
                              const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 18,
                              ),

                            //Send Message Input Section
                            PromptInputWidget(
                                controller: controller,
                                onPressedSendButton: () async {
                                  scrollToBottom();
                                  print('Total Sent: $totalSent');
                                  print(('Premium Status: $isPremium'));

                                  //If freeLimit cross and User is not Premium
                                  //Then Go to Subscription Screen
                                  limitCheckAndSend(question: controller.text);
                                },
                                onPressedCameraButton: () async {
                                  int? selectedImgSrc =
                                      await ImageToTextService.getImageSrc(
                                          context);

                                  if (selectedImgSrc != null) {
                                    setState(() {
                                      imageProcessing = true;
                                    });

                                    String? question = await ImageToTextService
                                        .getTextFromImage(selectedImgSrc);

                                    setState(() {
                                      imageProcessing = false;
                                    });
                                    if (question != null) {
                                      limitCheckAndSend(question: question);
                                    }
                                  }
                                }),
                          ],
                        ),
                      );
              }));
    } else {
      return SubscriptionScreen();
    }
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
            DateTime now = DateTime.now();
            int milliseconds = now.millisecondsSinceEpoch;
            String uniqueId = '$milliseconds';
            String formattedDate = DateFormat('dd/MM/yyyy hh:mm a').format(now);
            if (checkLength == conv.length) {
              //if true means no changes happed.
            } else {
              if (id == 0) {
                List<Map<String, dynamic>> conWithTime = [];
                conWithTime.add({
                  "conversation": conv,
                  "ID": uniqueId,
                  "timeStamp": formattedDate
                });
                await myBox.add(conWithTime);
              } else {
                modifiedList = [];
                final hiveList = myBox.values.toList();
                modifiedList.add({
                  "conversation": hiveList[indexNumber][0]["conversation"],
                  "ID": uniqueId,
                  "timeStamp": formattedDate
                });
                myBox.put(indexNumber, modifiedList);

                addedConversation.forEach((element) async {
                  await hiveList[indexNumber][0]["conversation"].add(element);
                });
              }
            }

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
    for (int i = conv.length - 1; i >= 0; i--) {
      totalWords += conv[i]['msg'].toString().split(' ').length;

      if (totalWords > contextLimit) {
        break;
      }
      try {
        contextList.add({
          'role': conv[i]['index'] == 0 ? 'user' : 'assistant',
          'content': conv[i]['msg']
        });
      } catch (e) {
        print('Erron in making contest list');
      }
    }
    ;

    print('Total Words: $totalWords');
    contextList = contextList.reversed.toList();
    print(contextList);
    return contextList;
  }

  void scrollToBottom() {
    if (scrollController != null && scrollController!.hasClients) {
      print('Scrolling to Bottom');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController!.animateTo(
          scrollController!.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void limitCheckAndSend({required String question}) {
    if (totalSent > freeChatLimit && !isPremium) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SubscriptionScreen()));
    } else {
      controller.clear();
      setState(() {
        conv.add({"msg": question, "index": 0});
        addedConversation.add({"msg": question, "index": 0});
      });
      replyFunction();
      sharedPreferencesUtil.saveInt('totalSent', totalSent + 1);
      setState(() {
        totalSent = sharedPreferencesUtil.getInt('totalSent');
      });
      print('Total Sent: $totalSent');
    }
  }
}
