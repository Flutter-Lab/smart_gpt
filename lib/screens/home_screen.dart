// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/task_card_full_width_list_widget.dart';
import 'package:smart_gpt_ai/widgets/task_card_ocr_summary_widget.dart';
import '../constants/constants.dart';
import '../services/image_to_text_service.dart';
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
                children: [
                  TaskCardSummaryWidget(onPressed: () async {
                    await imageToText();
                    // String? imageText;
                    // ImageToTextService imageToTextService =
                    //     ImageToTextService();
                    // int? selectedImgRsrc =
                    //     await imageToTextService.showBottomSheet(context);
                    // if (selectedImgRsrc != null) {
                    //   imageText = await imageToTextService
                    //       .getImageAndExtractText(selectedImgRsrc);
                    //   List<Map<String, dynamic>> conversation = [];
                    //   conversation.add({
                    //     "msg": "Summarize this text\n$imageText",
                    //     "index": 0
                    //   });
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => ChatScreen(
                    //               conversation: conversation,
                    //               id: 0,
                    //               dateTime: '',
                    //               gobackPageIndex: 0)));
                    // }
                  }),
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
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
                    decoration: BoxDecoration(
                      color: ColorPallate.bgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: controller,
                      onSubmitted: (value) async {},
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                await imageToText();
                              },
                              icon: Icon(Icons.camera_alt)),
                          border: InputBorder.none,
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

  Future<void> imageToText() async {
    String? imageText;
    ImageToTextService imageToTextService = ImageToTextService();
    int? selectedImgRsrc = await imageToTextService.showBottomSheet(context);
    if (selectedImgRsrc != null) {
      imageText =
          await imageToTextService.getImageAndExtractText(selectedImgRsrc);

      print('Image Text $imageText');

      if (imageText != null) {
        List<Map<String, dynamic>> conversation = [];
        conversation
            .add({"msg": "Summarize this text\n$imageText", "index": 0});
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
  }
}
