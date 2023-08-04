// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:smart_gpt_ai/services/image_to_text_service.dart';
// import 'package:smart_gpt_ai/widgets/task_card_ocr_summary_widget.dart';

// class ImgToText extends StatefulWidget {
//   const ImgToText({super.key});

//   @override
//   State<ImgToText> createState() => _ImgToTextState();
// }

// class _ImgToTextState extends State<ImgToText> {
//   File? _imageFile;
//   String _extractedText = "";
//   int? selectedImgRsrc;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _imageFile != null
//               ? Image.file(
//                   _imageFile!,
//                   height: 200,
//                 )
//               : Text(
//                   'No Image Selected',
//                   style: TextStyle(color: Colors.white),
//                 ),
//           TaskCardSummaryWidget(onPressed: () async {
//             ImageToTextService imageToTextService = ImageToTextService();
//             selectedImgRsrc = await imageToTextService.showBottomSheet(context);
//             if (selectedImgRsrc != null) {
//               imageToTextService.getImageAndExtractText(selectedImgRsrc!);
//             }
//           }),
//           Flexible(
//               child: Text(
//             _extractedText,
//             style: TextStyle(color: Colors.white),
//           )),
//         ],
//       )),
//     );
//   }
// }
