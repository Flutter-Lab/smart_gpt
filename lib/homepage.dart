// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/old/constants/screen_utils.dart';
import 'package:smart_gpt_ai/widgets/task_card_section_list_widget.dart';
import 'chatscreen.dart';
import 'constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // List<String> hotTopics = [
    //   'what is 2+2',
    //   'what is 4+4',
    //   'tell me a joke',
    //   'who is owner of twitter?',
    //   'what is color?',
    //   'what is light?',
    // ];

    return Scaffold(
      body: Container(
        height: ScreenUtil.screenHeight(context),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //// Old Hot Topics Button List
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: hotTopics.length,
              //     itemBuilder: (context, index) => Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: ElevatedButton(
              //         onPressed: () {
              //           List<Map<String, dynamic>> conversation = [];
              //           conversation
              //               .add({"msg": hotTopics[index], "index": 0});
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) =>
              //                       ChatScreen(conversation, 0, '', index)));
              //         },
              //         child: Text(hotTopics[index]),
              //       ),
              //     ),
              //   ),
              // ),

              Flexible(
                child: SingleChildScrollView(
                    child: Column(
                  children: const [
                    TaskCardSectionListWidget(),
                  ],
                )),
              ),

              //Send Message Input Section
              Container(
                padding: EdgeInsets.all(8.0),
                color: ColorPallate.cardColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: ColorPallate.bgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: _controller,
                          onSubmitted: (value) async {},
                          decoration: InputDecoration.collapsed(
                              hintText: 'How can I help you?',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        List<Map<String, dynamic>> conversation = [];
                        conversation.add({"msg": _controller.text, "index": 0});
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(conversation, 0, '', 0)));
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Row(
              //   children: [
              //     Flexible(
              //       child: TextField(
              //         controller: _controller,
              //       ),
              //     ),
              //     ElevatedButton(
              //         onPressed: () {
              //           List<Map<String, dynamic>> conversation = [];
              //           conversation
              //               .add({"msg": _controller.text, "index": 0});
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) =>
              //                       ChatScreen(conversation, 0, '', 0)));
              //         },
              //         child: Text('submit')),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
