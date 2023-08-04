// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/home_screen_top_section.dart';
import 'package:smart_gpt_ai/widgets/task_card_full_width_widget_list.dart';
import '../constants/constants.dart';
import '../services/image_to_text_service.dart';
import '../widgets/image_scanning_animation_widget.dart';
import '../widgets/prompt_input_widget.dart';
import '../widgets/task_card_ocr_summary_widget.dart';
import '../widgets/task_card_widget_half_width.dart';
import '../widgets/text_widget.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();

  bool imageProcessing = false;

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
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: [
                      // HomeScreenTopSection(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: TaskCardSummaryWidget(onPressed: () async {
                              int? selectedImgSrc =
                                  await ImageToTextService.getImageSrc(context);

                              if (selectedImgSrc != null) {
                                setState(() {
                                  imageProcessing = true;
                                });

                                String? imageText =
                                    await ImageToTextService.getTextFromImage(
                                        selectedImgSrc);

                                setState(() {
                                  imageProcessing = false;
                                });

                                if (imageText != null) {
                                  List<Map<String, dynamic>> conversation = [];
                                  conversation.add({
                                    "msg": "Summarize this text\n$imageText",
                                    "index": 0
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              conversation: conversation,
                                              id: 0,
                                              dateTime: '',
                                              gobackPageIndex: 0)));
                                }
                              }
                            }),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                for (var cardmodel in card_list)
                                  TaskCardHalfWidth(
                                    taskModel: cardmodel,
                                    onPressed: () {
                                      List<Map<String, dynamic>> conversation =
                                          [];
                                      conversation.add(
                                          {"msg": cardmodel.msg, "index": 0});
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  conversation: conversation,
                                                  id: 0,
                                                  dateTime: '',
                                                  gobackPageIndex: 0)));
                                    },
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                      TaskCardSectionListWidget(),
                    ],
                  )),
                  if (imageProcessing == true) ImageScanAnimationWidget()
                ],
              ),
            ),
          ),

          //Send Message Input Section
          PromptInputWidget(
            controller: controller,
            onPressedSendButton: () {
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
            onPressedCameraButton: () async {
              int? selectedImgSrc =
                  await ImageToTextService.getImageSrc(context);

              if (selectedImgSrc != null) {
                setState(() {
                  imageProcessing = true;
                });

                String? imageText =
                    await ImageToTextService.getTextFromImage(selectedImgSrc);

                setState(() {
                  imageProcessing = false;
                });

                if (imageText != null) {
                  List<Map<String, dynamic>> conversation = [];
                  conversation.add(
                      {"msg": "Summarize this text\n$imageText", "index": 0});

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              conversation: conversation,
                              id: 0,
                              dateTime: '',
                              gobackPageIndex: 0)));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
