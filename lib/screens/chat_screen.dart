// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smart_gpt_ai/constants/api_consts.dart';
import 'package:smart_gpt_ai/glassfy_iap/purchase_api.dart';

import 'package:smart_gpt_ai/services/api_service.dart';

import '../constants/constants.dart';
import '../utilities/shared_prefs.dart';
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

  // List<Map<String, dynamic>> getConversation() {
  //   return conversation;
  // }
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

  ScrollController scrollController = ScrollController();
  final sharedPreferencesUtil = SharedPreferencesUtil();

  void replyFunction() async {
    setState(() {
      gettingReply = true;
    });
    await Future.delayed(const Duration(seconds: 1));

    String botReply = await ApiService.sendMessage(message: question);
    setState(() {
      gettingReply = false;
      conv.add({"msg": botReply, "index": 1});
      addedConversation.add({"msg": botReply, "index": 1});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalSent = sharedPreferencesUtil.getInt('totalSent');

    bool isPremium = sharedPreferencesUtil.getBool('isPremium');

    conv = widget.conversation;
    id = widget.id;
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

    // scrollToBottom();

    // if (totalSent < freeChatLimit - 1 ||
    //     isPremium && scrollController.hasClients) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     // Perform auto-scrolling here
    //     scrollController.animateTo(
    //       scrollController.position.maxScrollExtent,
    //       duration: Duration(milliseconds: 1000),
    //       curve: Curves.easeInOut,
    //     );
    //   });
    // }

    return totalSent < freeChatLimit - 1 || isPremium
        ? FutureBuilder<bool>(
            future: PurchaseApi.isUserPremium(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  : Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        title: Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.navigate_before,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                DateTime now = DateTime.now();
                                int milliseconds = now.millisecondsSinceEpoch;
                                String uniqueId = '$milliseconds';
                                String formattedDate =
                                    DateFormat('dd/MM/yyyy hh:mm a')
                                        .format(now);
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
                                      "conversation": hiveList[indexNumber][0]
                                          ["conversation"],
                                      "ID": uniqueId,
                                      "timeStamp": formattedDate
                                    });
                                    myBox.put(indexNumber, modifiedList);

                                    addedConversation.forEach((element) async {
                                      await hiveList[indexNumber][0]
                                              ["conversation"]
                                          .add(element);
                                    });
                                  }
                                }

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return StartScreen(
                                      pageIndex: widget.gobackPageIndex);
                                }));
                              },
                            ),
                            const Center(
                              child: Text(
                                "Chat screen",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        backgroundColor: ColorPallate.cardColor,
                      ),
                      body: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Flexible(
                                child: NotificationListener<ScrollNotification>(
                                  //Hide keyboard on Scroll
                                  onNotification: (scrollNotification) {
                                    if (scrollNotification
                                            is ScrollUpdateNotification &&
                                        scrollNotification.metrics.axis ==
                                            Axis.vertical &&
                                        scrollNotification.dragDetails !=
                                            null) {
                                      // Hide the keyboard when scrolling starts
                                      FocusScope.of(context).unfocus();
                                    }
                                    return false;
                                  },
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: widget.conversation.length,
                                    itemBuilder: (context, index) {
                                      String msg =
                                          widget.conversation[index]["msg"];
                                      int chatIndex =
                                          widget.conversation[index]["index"];

                                      return GestureDetector(
                                        onTap: () {
                                          // When tapped outside of the keyboard, unfocus the current focus node.
                                          final currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: 4,
                                                  bottom: 8,
                                                  left: chatIndex == 0 ? 24 : 4,
                                                  right:
                                                      chatIndex == 0 ? 4 : 24,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: chatIndex == 0
                                                        ? const Color.fromARGB(
                                                            255, 28, 196, 103)
                                                        : cardColor,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            const Radius.circular(
                                                                12),
                                                        topRight:
                                                            const Radius.circular(
                                                                12),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                chatIndex == 0
                                                                    ? 12
                                                                    : 0),
                                                        bottomRight: Radius.circular(
                                                            chatIndex == 0 ? 0 : 12))),
                                                padding: EdgeInsets.only(
                                                    top: chatIndex == 0 ? 8 : 0,
                                                    left: 8,
                                                    bottom:
                                                        chatIndex == 0 ? 8 : 16,
                                                    right: 8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          chatIndex == 0
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Flexible(
                                                                      child:
                                                                          TextWidget(
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        label:
                                                                            msg,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : DefaultTextStyle(
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              msg);

                                                                          Clipboard.setData(
                                                                              ClipboardData(text: msg));
                                                                          // Show a snackbar or any other feedback to the user indicating successful copy.

                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(content: Text('Copied to clipboard')));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.topRight,
                                                                          padding:
                                                                              EdgeInsets.all(4),
                                                                          child:
                                                                              Icon(
                                                                            Icons.copy,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(msg),
                                                                    ],
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (gettingReply)
                                const SpinKitThreeBounce(
                                  color: Colors.white,
                                  size: 18,
                                ),

                              ElevatedButton(
                                  onPressed: getContext,
                                  child: Text('Context')),

                              //Send Message Input Section
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                color: ColorPallate.cardColor,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: ColorPallate.bgColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: TextField(
                                          maxLines: 2,
                                          minLines: 1,
                                          keyboardType: TextInputType.multiline,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          controller: controller,
                                          onSubmitted: (value) async {},
                                          decoration: InputDecoration.collapsed(
                                              hintText: 'How can I help you?',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey
                                                      .withOpacity(0.4))),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        print('Total Sent: $totalSent');
                                        print(('Premium Status: $isPremium'));

                                        //If freeLimit cross and User is not Premium
                                        //Then Go to Subscription Screen
                                        if (totalSent > freeChatLimit &&
                                            !isPremium) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SubscriptionScreen()));
                                        }
                                        question = controller.text;
                                        controller.clear();
                                        setState(() {
                                          conv.add(
                                              {"msg": question, "index": 0});
                                          addedConversation.add(
                                              {"msg": question, "index": 0});
                                        });
                                        replyFunction();
                                        sharedPreferencesUtil.saveInt(
                                            'totalSent', totalSent + 1);
                                        setState(() {
                                          totalSent = sharedPreferencesUtil
                                              .getInt('totalSent');
                                        });

                                        print('Total Sent: $totalSent');
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            })
        : SubscriptionScreen();
  }

  List<Map<String, String>> getContext() {
    List<Map<String, String>> contextList = [];
    int totalWords = 0;
    print('Coversation List: $conv');

    for (Map<String, dynamic> map in conv) {
      // }

      // conv.forEach((map) {
      if (totalWords + map['msg'].toString().length > contextLimit) {
        break;
      }
      try {
        contextList.add({
          'role': map['index'] == 0 ? 'user' : 'assistant',
          'content': map['msg']
        });

        totalWords += map['msg'].toString().split(' ').length;
      } catch (e) {
        print('Erron in making contest list');
      }
    }
    ;

    print('Context List: $contextList');
    print('Total Words: $totalWords');

    return contextList;
  }

  void scrollToBottom() {
    print('Scrolling to Bottom');
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
