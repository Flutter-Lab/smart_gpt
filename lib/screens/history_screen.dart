// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_gpt_ai/constants/constants.dart';
import 'package:smart_gpt_ai/hive/hive_model.dart';
import 'package:smart_gpt_ai/models/chat_model.dart';
import 'package:smart_gpt_ai/providers/chats_provider.dart';
import 'package:smart_gpt_ai/screens/chat_screen.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class HistoryScreen extends StatelessWidget with ChangeNotifier {
  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // print('History Screen');
    List chatList = [];
    List<Map<String, dynamic>> chatListAll = [];
    final chatProvider = Provider.of<ChatProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
              future: chatProvider.getAllChatList(),
              builder: (context, snapshot) {
                // print(chatProvider.getAllChatList());
                try {
                  if (snapshot.hasData) {
                    chatListAll = snapshot.data!;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: chatListAll.length,
                          itemBuilder: (context, index) {
                            chatList = chatListAll[index]['chat_list'];

                            // print(chatListAll.length);

                            return Card(
                              color: ColorPallate.cardColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: TextWidget(
                                    label: index.toString(),
                                    color: Colors.amber,
                                  ),
                                  title: TextWidget(
                                    label: chatList[0]['msg'].toString(),
                                    color: Colors.white,
                                  ),
                                  subtitle: TextWidget(
                                    label:
                                        chatListAll[index]['time'].toString(),
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                  onTap: () async {
                                    List<ChatModel> chatModelList = [];
                                    for (Map<dynamic, dynamic> chat
                                        in chatList) {
                                      ChatModel chatModel = ChatModel(
                                          msg: chat['msg'],
                                          chatIndex: chat['chatIndex']);
                                      chatModelList.add(chatModel);
                                    }
                                    chatProvider.currentChatList =
                                        chatModelList;
                                    notifyListeners();

                                    await ChatListHive.deleteChatFromHive(
                                        index);
                                    // chatProvider.currentChatList = [];
                                    // notifyListeners();
                                    // chatProvider.updateChatList(chatModelList);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                                  chatIndex: index,
                                                )));
                                  },
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    // print(snapshot.data);
                    return Expanded(
                      child: Center(
                        child: TextWidget(label: 'Chat List is Empty'),
                      ),
                    );
                  }
                } catch (error) {
                  print(error);
                  return Center(
                    child: Text('Error: $error'),
                  );
                }
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {},
                  child: Text('Add Item'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var box = await Hive.openBox('chat_box');
                    box.clear();
                  },
                  child: Text('Clear List'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
