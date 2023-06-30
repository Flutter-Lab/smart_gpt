// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_gpt_ai/functions/send_message.dart';
import 'package:smart_gpt_ai/widgets/task_card_section_list_widget.dart';
import 'package:smart_gpt_ai/widgets/task_card_widget.dart';

import '../providers/chats_provider.dart';
import '../widgets/send_message_input_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ChatProvider chatProvider;
  @override
  Widget build(BuildContext context) {
    chatProvider = Provider.of<ChatProvider>(context);
    return Column(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TaskCard(
                        title: 'Studying',
                        titleFontSize: 18,
                        subtitle: 'Explain a theorem to me',
                        icon: '💡',
                        onPressed: () {
                          taskCardTap("Explain Newton 1st law like I'm 10");
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: TaskCard(
                          title: 'Promotion',
                          titleFontSize: 18,
                          subtitle: 'Draft an email',
                          icon: '📧'),
                    ),
                  ],
                ),
                TaskCardSectionListWidget()
              ],
            ),
          ),
        ),
        SendMessageInputWidget(
            textEditingController: chatProvider.textEditingController,
            isChatScreen: false),
      ],
    );
  }

  void taskCardTap(String msg) {
    SendMessage.sendMessage(
      // chatProvider: chatProvider,
      context: context,
      currentMessage: msg,
    );
  }
}
