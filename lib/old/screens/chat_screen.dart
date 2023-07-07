// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, empty_catches, unrelated_type_equality_checks, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_gpt_ai/hive/hive_model.dart';
// import 'package:smart_gpt_ai/providers/chats_provider.dart';
// import 'package:smart_gpt_ai/widgets/chat_widget.dart';
// import 'package:smart_gpt_ai/widgets/send_message_input_widget.dart';

// class ChatScreen extends StatelessWidget {
//   List<Map<String, dynamic>> conversation;
//   ChatScreen(this.conversation);

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = Provider.of<ChatProvider>(context);

//     List<Map<String, dynamic>> conWithTime = [];

//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         elevation: 2,
//         leading: Padding(
//           padding: const EdgeInsets.all(7.0),
//           child: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () async {
//                 goBack(chatProvider, context);
//               }),
//         ),
//         title: Center(child: Text('Smart GPT AI')),
//       ),
//       body: SafeArea(
//         child: Column(children: [
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ListView.builder(
//                   itemCount: conversation.length,
//                   itemBuilder: (context, index) {
//                     return ChatWidget(
//                       msg: conversation[index]["msg"],
//                       chatIndex: conversation[index]["index"],
//                     );
//                   }),
//             ),
//           ),
//           if (chatProvider.isTypingStatus) ...[
//             const SpinKitThreeBounce(
//               color: Colors.white,
//               size: 18,
//             ),
//           ],
//           SendMessageInputWidget(
//             textEditingController: chatProvider.textEditingController,
//             isChatScreen: true,
//           ),
//         ]),
//       ),
//     );
//   }

//   Future<void> goBack(ChatProvider chatProvider, BuildContext context) async {
//     {
//       var chatList = chatProvider.getCurrentModel;
//       List<Map<String, dynamic>> chatMapList = [];

//       for (var item in chatList) {
//         Map<String, dynamic> msg = {
//           'chatIndex': item.chatIndex,
//           'msg': item.msg
//         };
//         chatMapList.add(msg);
//       }

//       await ChatListHive.addChatToHiveDB(chatMapList, chatIndex);

//       Navigator.pop(context);
//     }
//   }
// }
