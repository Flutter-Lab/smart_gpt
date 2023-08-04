import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PromptInputWidget extends StatefulWidget {
  final VoidCallback onPressedSendButton;
  final VoidCallback onPressedCameraButton;
  PromptInputWidget({
    super.key,
    required this.controller,
    required this.onPressedSendButton,
    required this.onPressedCameraButton,
  });

  final TextEditingController controller;

  @override
  State<PromptInputWidget> createState() => _PromptInputWidgetState();
}

class _PromptInputWidgetState extends State<PromptInputWidget> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: ColorPallate.cardColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
              decoration: BoxDecoration(
                color: ColorPallate.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: widget.controller,
                onSubmitted: (value) async {},
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        widget.onPressedCameraButton();
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                    border: InputBorder.none,
                    hintText: 'How can I help you?',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onPressedSendButton,
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
