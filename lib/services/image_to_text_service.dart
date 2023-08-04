import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_gpt_ai/constants/constants.dart';

class ImageToTextService {
  static Future<int?> getImageSrc(BuildContext context) async {
    // Create a Completer to wait for the user's selection
    Completer<int?> completer = Completer<int?>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
              color: ColorPallate.cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Camera',
                        textScaleFactor: 1.2,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  completer.complete(
                      0); // Complete the Future with the selected number
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Gallary',
                        textScaleFactor: 1.2,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  completer.complete(
                      1); // Complete the Future with the selected number
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );

    // Wait for the Future to complete and get the selected number
    int? selected = await completer.future;
    // setState(() {
    //   selectedImgRsrc = selected;
    // });

    return selected;
  }

  static Future<String?> getTextFromImage(int imageSource) async {
    final imageFile = await ImagePicker().pickImage(
        source: imageSource == 0 ? ImageSource.camera : ImageSource.gallery);
    if (imageFile == null) {
      return null;
    }

    final InputImage inputImage;

    inputImage = InputImage.fromFilePath(imageFile.path);

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    String extractedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += line.text + "\n";
      }
    }

    textRecognizer.close();
    return extractedText;
  }
}
