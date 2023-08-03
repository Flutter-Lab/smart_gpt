import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';

class ImgToText extends StatefulWidget {
  const ImgToText({super.key});

  @override
  State<ImgToText> createState() => _ImgToTextState();
}

class _ImgToTextState extends State<ImgToText> {
  File? _imageFile;
  String _extractedText = "";
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
          ElevatedButton(
            onPressed: _getImageAndExtractText,
            child: Text('convert'),
          )
        ],
      )),
    );
  }

  Future<void> _getImageAndExtractText() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile == null) return;

    final visionImage = FirebaseVisionImage.fromFile(File(imageFile.path));
    final textRecognizer = FirebaseVision.instance.textRecognizer();

    final visionText = await textRecognizer.processImage(visionImage);
    String extractedText = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        extractedText += line.text! + "\n";
      }
    }

    setState(() {
      _imageFile = File(imageFile.path);
      _extractedText = extractedText;
    });

    textRecognizer.close();
  }
}
