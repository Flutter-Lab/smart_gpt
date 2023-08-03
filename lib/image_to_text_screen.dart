import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:smart_gpt_ai/services/image_to_text_service.dart';
import 'package:smart_gpt_ai/widgets/task_card_ocr_summary_widget.dart';

class ImgToText extends StatefulWidget {
  const ImgToText({super.key});

  @override
  State<ImgToText> createState() => _ImgToTextState();
}

class _ImgToTextState extends State<ImgToText> {
  File? _imageFile;
  String _extractedText = "";
  int? selectedImgRsrc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imageFile != null
              ? Image.file(
                  _imageFile!,
                  height: 200,
                )
              : Text(
                  'No Image Selected',
                  style: TextStyle(color: Colors.white),
                ),
          TaskCardSummaryWidget(onPressed: () async {
            ImageToTextService imageToTextService = ImageToTextService();
            selectedImgRsrc = await imageToTextService.showBottomSheet(context);
            if (selectedImgRsrc != null) {
              imageToTextService.getImageAndExtractText(selectedImgRsrc!);
            }
          }),
          Flexible(
              child: Text(
            _extractedText,
            style: TextStyle(color: Colors.white),
          )),
        ],
      )),
    );
  }

  // Future<void> _getImageAndExtractText(int imageSource) async {
  //   final imageFile = await ImagePicker().pickImage(
  //       source: imageSource == 0 ? ImageSource.camera : ImageSource.gallery);
  //   if (imageFile == null) return;
  //   final InputImage inputImage;
  //   inputImage = InputImage.fromFilePath(imageFile.path);
  //   final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  //   final RecognizedText recognizedText =
  //       await textRecognizer.processImage(inputImage);
  //   String extractedText = "";
  //   for (TextBlock block in recognizedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       extractedText += line.text + "\n";
  //     }
  //   }
  //   setState(() {
  //     _imageFile = File(imageFile.path);
  //     _extractedText = extractedText;
  //   });
  //   textRecognizer.close();
  // }

  // Future<void> _showBottomSheet() async {
  //   // Create a Completer to wait for the user's selection
  //   Completer<int> completer = Completer<int>();
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             InkWell(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Text('Camera', textScaleFactor: 1.2),
  //                   ),
  //                 ],
  //               ),
  //               onTap: () {
  //                 completer.complete(
  //                     0); // Complete the Future with the selected number
  //                 Navigator.pop(context); // Close the bottom sheet
  //               },
  //             ),
  //             InkWell(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Text('Gallary', textScaleFactor: 1.2),
  //                   ),
  //                 ],
  //               ),
  //               onTap: () {
  //                 completer.complete(
  //                     1); // Complete the Future with the selected number
  //                 Navigator.pop(context); // Close the bottom sheet
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //   // Wait for the Future to complete and get the selected number
  //   int selected = await completer.future;
  //   setState(() {
  //     selectedImgRsrc = selected;
  //   });
  // }
}
