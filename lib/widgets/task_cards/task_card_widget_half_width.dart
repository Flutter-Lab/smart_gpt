import 'package:flutter/material.dart';

import 'package:smart_gpt_ai/models/half_width_task_card_model.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../../constants/constants.dart';

class TaskCardHalfWidth extends StatelessWidget {
  final HalfWidthTaskCardModel taskModel;
  final VoidCallback? onPressed;
  final Color? color;
  const TaskCardHalfWidth({
    Key? key,
    this.color = ColorPallate.cardColor,
    required this.taskModel,
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
        constraints: const BoxConstraints(minHeight: 100),

        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(16.0)),
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
                    taskModel.title,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    label: taskModel.subtitle,
                    color: color != null ? Colors.white : Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget(
                  label: taskModel.icon,
                  fontSize: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
