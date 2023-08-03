import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../constants/constants.dart';

class TaskCardSummaryWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  const TaskCardSummaryWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        // color: Colors.amber,
        padding: const EdgeInsets.only(left: 10, right: 8, top: 8, bottom: 10),
        margin: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
            // minHeight: 60.0, // Set the minimum height here
            ),
        // height: 100,
        decoration: BoxDecoration(
            color: ColorPallate.cardColor,
            borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    label: 'Summarize text from photos',
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextWidget(
                      label: '📷',
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
