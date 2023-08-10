import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

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
        padding: const EdgeInsets.only(left: 10, right: 8, top: 8, bottom: 10),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.cyan, borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
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
            Text(
              'Summarize text from photos',
              maxLines: 3,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextWidget(
                  label: '📷',
                  fontSize: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
