// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls, deprecated_member_use, prefer_const_constructors, must_be_immutable

import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_gpt_ai/constants/api_consts.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';
import 'package:smart_gpt_ai/services/api_service.dart';
import 'package:smart_gpt_ai/widgets/image_scanning_animation_widget.dart';
import '../constants/constants.dart';
import '../hive-test/chat_model.dart';
import '../services/image_to_text_service.dart';
import '../utilities/shared_prefs.dart';
import '../widgets/chat_card_widget.dart';
import '../widgets/prompt_input_widget.dart';
import '../widgets/text_widget.dart';
import 'start_screen.dart';
import 'subscription_screen.dart';

final myBox = Hive.box('myBox');

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

  late int totalSent;
  late bool isPremium;

  late Chat myChat;

  void replyFunction() async {
    setState(() {
      isStreaming = true;
    });

    getStreamResponse(contextMapList: getContext());

    setState(() {
      myChat.chatMessageList.add(ChatMessage(msg: '', senderIndex: 1));
    });

    scrollToBottom();
  }

  bool isStreaming = false;

  int scrollText = 250;
  bool doScroll = false;

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

    Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat
        .createStream(model: "gpt-3.5-turbo", messages: contextList);

    chatStream.listen((streamChatCompletion) {
      final content = streamChatCompletion.choices.first.delta.content;
      // print(content);
      if (content != null) {
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
      }
    }).onDone(() {
      print('Stream is Done');
      setState(() {
        // conv.last = {"msg": fullText, "index": 1};

        myChat.chatMessageList.last =
            ChatMessage(msg: fullText, senderIndex: 1);

        isStreaming = false;

        //Adding Bot Message to myChat
        // ChatMessage botMsg = ChatMessage(msg: fullText, senderIndex: 1);
        // myChat.chatMessageList.add(botMsg);
      });
    });

    _replyStreamController.done;

    // botReply = fullText;
    print('Full Text: $fullText');
    return fullText;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController = ScrollController();

      scrollToBottom();
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
    scrollController!.dispose();
    _replyStreamController.close();

    super.dispose();
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    print('is Streaming : $isStreaming');

    if (widget.gobackPageIndex < 2 && count == 0) {
      replyFunction();
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
              future: PurchaseApi.is_userPremium(),
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
                                        itemCount:
                                            myChat.chatMessageList.length,
                                        itemBuilder: (context, index) {
                                          String msg =
                                              myChat.chatMessageList[index].msg;
                                          int chatIndex = myChat
                                              .chatMessageList[index]
                                              .senderIndex;

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
                                            child: isStreaming &&
                                                    myChat.chatMessageList
                                                            .length ==
                                                        index + 1
                                                ? MessageCardWidget(
                                                    convLength: myChat
                                                        .chatMessageList.length,
                                                    currentMsgIndex: index,
                                                    stream:
                                                        _replyStreamController
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
                                        ImageScanAnimationWidget()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PromptInputWidget(
                                controller: inputTextcontroller,
                                onPressedSendButton: () async {
                                  scrollToBottom();
                                  print('Total Sent: $totalSent');
                                  print(('Premium Status: $isPremium'));

                                  //Add Message to Chat object
                                  ChatMessage chatMessage = ChatMessage(
                                      msg: inputTextcontroller.text,
                                      senderIndex: 0);

                                  myChat.chatMessageList.add(chatMessage);

                                  //If freeLimit cross and User is not Premium
                                  //Then Go to Subscription Screen
                                  limitCheckAndSend();
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
                                      limitCheckAndSend();
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
            print(myBox.keys);
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
      print('Scrolling to Bottom');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void limitCheckAndSend() {
    if (totalSent > freeChatLimit && !isPremium) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SubscriptionScreen()));
    } else {
      inputTextcontroller.clear();
      setState(() {});
      replyFunction();
      sharedPreferencesUtil.saveInt('totalSent', totalSent + 1);
      setState(() {
        totalSent = sharedPreferencesUtil.getInt('totalSent');
      });
      print('Total Sent: $totalSent');
    }
  }
}
