import 'package:flutter/material.dart';

import '../constants/constants.dart';

class PromptInputWidget extends StatefulWidget {
  final VoidCallback onPressedSendButton;
  final VoidCallback onPressedCameraButton;
  bool isStreaming;
  PromptInputWidget({
    super.key,
    required this.controller,
    required this.onPressedSendButton,
    required this.onPressedCameraButton,
    required this.isStreaming,
  });

  final TextEditingController controller;

  @override
  State<PromptInputWidget> createState() => _PromptInputWidgetState();
}

class _PromptInputWidgetState extends State<PromptInputWidget> {
  bool? hasData;
  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty || value.length == 0) {
        hasData = false;
      } else {
        hasData = true;
      }
    });
  }

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
                onChanged: _validateInput,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        widget.onPressedCameraButton();
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        size: 35,
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: 'How can I help you?',
                    hintStyle: TextStyle(color: Colors.grey.shade600)),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(16)),
            child: IconButton(
              onPressed: hasData == true || widget.isStreaming
                  ? widget.onPressedSendButton
                  : null,
              icon: Icon(
                widget.isStreaming ? Icons.stop : Icons.send,
                color: widget.isStreaming ? Colors.blueAccent : Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
