import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/testings/hive-test/chat_model.dart';

import 'package:smart_gpt_ai/widgets/task_cards/task_card_widget_full_width.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../../../data/homepage_taskcard_list_data.dart';
import '../../models/full_width_task_card_model.dart';
import '../../screens/chat_screen.dart';

class TaskCardSectionListWidget extends StatelessWidget {
  const TaskCardSectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> conversation = [];
    return Column(
      children: [
        for (TaskCardSectionModel taskSection in fullWidthTaskCardSectionList)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 16, bottom: 4),
                child: TextWidget(
                  label: taskSection.sectionTitle,
                  fontSize: 18,
                ),
              ),
              Column(
                children: [
                  for (TaskCardModelFullWidth taskCard
                      in taskSection.taskCardModelList)
                    TaskCardFullWidth(
                      title: taskCard.title,
                      icon: taskCard.icon,
                      onPressed: () {
                        Chat chat = Chat(chatMessageList: [
                          ChatMessage(msg: taskCard.msg, senderIndex: 0)
                        ], lastUpdateTime: '');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    chatObject: chat,
                                    conversation: conversation,
                                    gobackPageIndex: 0)));
                      },
                    ),
                ],
              )
            ],
          ),
      ],
    );
  }
}
