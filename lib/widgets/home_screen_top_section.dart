// import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/models/half_width_task_card_model.dart';
// import '../screens/chat_screen.dart';
// import '../services/image_to_text_service.dart';
// import 'task_card_ocr_summary_widget.dart';
// import 'task_card_widget_half_width.dart';

// class HomeScreenTopSection extends StatefulWidget {
//   const HomeScreenTopSection({super.key});

//   @override
//   State<HomeScreenTopSection> createState() => _HomeScreenTopSectionState();
// }

// class _HomeScreenTopSectionState extends State<HomeScreenTopSection> {
//   bool imageProcessing = false;
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Flexible(
//           child: TaskCardSummaryWidget(onPressed: () async {
//             int? selectedImgSrc = await ImageToTextService.getImageSrc(context);

//             if (selectedImgSrc != null) {
//               setState(() {
//                 imageProcessing = true;
//               });

//               String? imageText =
//                   await ImageToTextService.getTextFromImage(selectedImgSrc);

//               setState(() {
//                 imageProcessing = false;
//               });

//               if (imageText != null) {
//                 List<Map<String, dynamic>> conversation = [];
//                 conversation.add(
//                     {"msg": "Summarize this text\n$imageText", "index": 0});

//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => ChatScreen(
//                             conversation: conversation,
//                             id: 0,
//                             dateTime: '',
//                             gobackPageIndex: 0)));
//               }
//             }
//           }),
//         ),
//         Flexible(
//           child: Column(
//             children: [
//               for (var cardmodel in card_list)
//                 TaskCardHalfWidth(
//                   taskModel: cardmodel,
//                   onPressed: () {
//                     List<Map<String, dynamic>> conversation = [];
//                     conversation.add({"msg": cardmodel.msg, "index": 0});
//                     Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ChatScreen(
//                                 conversation: conversation,
//                                 id: 0,
//                                 dateTime: '',
//                                 gobackPageIndex: 0)));
//                   },
//                 ),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   Future<String?> textFromImage(BuildContext context) async {
//     String? imageText;
//     // ImageToTextService imageToTextService = ImageToTextService();
//     int? selectedImgSrc = await ImageToTextService.getImageSrc(context);
//     if (selectedImgSrc != null) {
//       imageText = await ImageToTextService.getTextFromImage(selectedImgSrc);

//       print('Image Text $imageText');
//     }
//     return imageText;
//   }
// }

List<HalfWidthTaskCardModel> card_list = [
  HalfWidthTaskCardModel(
    title: 'Histoy',
    subtitle: 'Check my knowledge about history',
    icon: '⚔️',
    msg: 'Can you share some information about a historical event or figure?',
  ),
  HalfWidthTaskCardModel(
    title: 'Social',
    subtitle: 'Create an engaging post',
    icon: '👥',
    msg:
        'Need a catchy Twitter message for a new product launch. Add relevant hashtags to reach our target audience',
  ),
];
