// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers
// import 'package:flutter/material.dart';
// import 'package:smart_gpt_ai/Data/homepage_taskcard_list.dart';
// import 'package:smart_gpt_ai/constants/constants.dart';
// import 'package:smart_gpt_ai/functions/send_message.dart';
// import 'package:smart_gpt_ai/models/task_card_model.dart';
// import 'package:smart_gpt_ai/screens/chat_screen.dart';
// import 'package:smart_gpt_ai/widgets/task_card_widget.dart';
// import 'package:smart_gpt_ai/widgets/text_widget.dart';

// class TaskCardSectionListWidget extends StatelessWidget {
//   const TaskCardSectionListWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> conversation = [];
//     return Container(
//       child: Column(
//         children: [
//           for (TaskCardSectionModel taskSection in taskCardSectionList)
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8, top: 16, bottom: 4),
//                   child: TextWidget(
//                     label: taskSection.sectionTitle,
//                     fontSize: 20,
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     for (TaskCardModel taskCard
//                         in taskSection.taskCardModelList)
//                       TaskCard(
//                         title: taskCard.title,
//                         icon: taskCard.icon,
//                         isFullWidth: true,
//                         titleColor: subTextColor,
//                         titleFontSize: 16,
//                         onPressed: () {
//                           conversation.add({"msg": taskCard.msg, "index": 0});
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       ChatScreen(conversation)));
//                           // SendMessage.sendMessage(
//                           //     context: context, currentMessage: taskCard.msg);
//                         },
//                       ),
//                   ],
//                 )
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
