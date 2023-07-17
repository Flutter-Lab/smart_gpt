// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/task_card_full_width_list_widget.dart';
import '../constants/constants.dart';
import '../widgets/text_widget.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorPallate.cardColor,
        title: Center(child: TextWidget(label: 'Smart GPT', fontSize: 20)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  child: Column(
                children: const [
                  TaskCardSectionListWidget(),
                ],
              )),
            ),
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
                      controller: controller,
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
                    conversation.add({"msg": controller.text, "index": 0});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                conversation: conversation,
                                id: 0,
                                dateTime: '',
                                gobackPageIndex: 0)));
                  },
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
